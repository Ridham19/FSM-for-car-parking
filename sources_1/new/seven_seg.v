// sevenseg_mux.v
// 4-digit multiplexed 7-segment driver with configurable polarity and bit-order
// - LUT defined with order {a,b,c,d,e,f,g} where 1 means "segment ON"
// - If BIT_REVERSE=1, the output 'seg' bits are reversed before applying polarity.
//   This handles boards where seg[0] != 'a' but maybe 'g' or reversed mapping.
//
// Usage examples:
//  - Typical Basys3 (seg[0]=a ... seg[6]=g, active-low segments): 
//      sevenseg_mux #(.SEG_ACTIVE_LOW(1), .BIT_REVERSE(0)) disp (...);
//  - If your wiring expects seg[0]=g ... seg[6]=a and active-low:
//      sevenseg_mux #(.SEG_ACTIVE_LOW(1), .BIT_REVERSE(1)) disp (...);

`timescale 1ns/1ps
module sevenseg_mux #(
    parameter SEG_ACTIVE_LOW = 1, // 1 if segment outputs are active-low
    parameter AN_ACTIVE_LOW  = 1, // 1 if anodes are active-low
    parameter BIT_REVERSE    = 1  // 1 to reverse the bit order when outputting to 'seg'
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] value, // {d3,d2,d1,d0}, each nibble 0..9 (or blank=0xF)
    output reg  [6:0]  seg,   // seg[0]..seg[6] (mapping to physical pins via XDC)
    output reg  [3:0]  an
);

    // refresh counter
    reg [15:0] refresh_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) refresh_cnt <= 0;
        else refresh_cnt <= refresh_cnt + 1;
    end
    wire [1:0] digit_idx = refresh_cnt[15:14];

    // extract digits
    wire [3:0] d0 = value[3:0];
    wire [3:0] d1 = value[7:4];
    wire [3:0] d2 = value[11:8];
    wire [3:0] d3 = value[15:12];
    reg [3:0] cur_digit;
    always @(*) begin
        case (digit_idx)
            2'b00: cur_digit = d0;
            2'b01: cur_digit = d1;
            2'b10: cur_digit = d2;
            default: cur_digit = d3;
        endcase
    end

    // canonical LUT: bits = {a,b,c,d,e,f,g}, 1 = segment ON
    reg [6:0] lut_high; // high = ON
    always @(*) begin
        case (cur_digit)
            4'd0: lut_high = 7'b1111110; // a b c d e f on, g off
            4'd1: lut_high = 7'b0110000; // b c
            4'd2: lut_high = 7'b1101101; // a b d e g
            4'd3: lut_high = 7'b1111001; // a b c d g
            4'd4: lut_high = 7'b0110011; // f g b c
            4'd5: lut_high = 7'b1011011; // a f g c d
            4'd6: lut_high = 7'b1011111; // a f e d c g
            4'd7: lut_high = 7'b1110000; // a b c
            4'd8: lut_high = 7'b1111111; // all
            4'd9: lut_high = 7'b1111011; // a b c d f g
            default: lut_high = 7'b0000000; // blank
        endcase
    end

    // optionally reverse bit order before applying polarity
    // canonical lut_high = {a,b,c,d,e,f,g} where lut_high[6]=a ... lut_high[0]=g? 
    // (we keep lut_high[6]=a, lut_high[0]=g in declaration above)
    // Now produce seg_out such that seg_out[6:0] maps to seg[6:0] before polarity inversion.
    reg [6:0] seg_out;
    integer ii;
    always @(*) begin
        if (BIT_REVERSE) begin
            // reverse bit order: seg_out[i] = lut_high[6-i]
            for (ii = 0; ii < 7; ii = ii + 1)
                seg_out[ii] = lut_high[6-ii];
        end else begin
            seg_out = lut_high;
        end
    end

    // apply polarity: lut defined as 1=ON, if SEG_ACTIVE_LOW invert
    always @(*) begin
        if (SEG_ACTIVE_LOW) seg = ~seg_out;
        else seg = seg_out;
        case (digit_idx)
            2'b00: an = (AN_ACTIVE_LOW ? 4'b1110 : 4'b0001);
            2'b01: an = (AN_ACTIVE_LOW ? 4'b1101 : 4'b0010);
            2'b10: an = (AN_ACTIVE_LOW ? 4'b1011 : 4'b0100);
            default: an = (AN_ACTIVE_LOW ? 4'b0111 : 4'b1000);
        endcase
    end

endmodule
