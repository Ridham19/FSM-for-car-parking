// top_parking.v
// Synthesis-friendly top-level for Basys3 (XC7A35T)
// - Uses leds[15:0] bus only (leds[14]=available, leds[15]=full)
// - Ports match the XDC provided earlier
`timescale 1ns/1ps

module top_parking #(
    parameter CLK_FREQ_HZ = 100_000_000,
    parameter DEBOUNCE_MS  = 20
)(
    input  wire        clk,        // 100 MHz input (W5 on Basys3 XDC)
    input  wire        btn_entry,  // pushbutton (U18 in XDC)
    input  wire        btn_exit,   // pushbutton (T18 in XDC)
    input  wire        btn_reset,  // pushbutton (U17 in XDC)
    output wire [6:0]  seg,        // segments a..g (W7,W6,U8,V8,U5,V5,U7 in XDC)
    output wire [3:0]  an,         // anodes (U2,U4,V4,W4 in XDC)
    output wire        dp,         // decimal point (V7 in XDC)
    output wire [15:0] leds        // user LEDs (mapped in XDC: leds[0]..leds[15])
);

    // ---------------------------------------------------------------------
    // Debounce buttons -> single-cycle pulses
    // ---------------------------------------------------------------------
    wire entry_pulse;
    wire exit_pulse;
    wire reset_pulse;

    debounce #(.CLK_FREQ_HZ(CLK_FREQ_HZ), .DEBOUNCE_MS(DEBOUNCE_MS)) db_entry (
        .clk(clk),
        .btn_in(btn_entry),
        .btn_pressed_pulse(entry_pulse)
    );

    debounce #(.CLK_FREQ_HZ(CLK_FREQ_HZ), .DEBOUNCE_MS(DEBOUNCE_MS)) db_exit (
        .clk(clk),
        .btn_in(btn_exit),
        .btn_pressed_pulse(exit_pulse)
    );

    debounce #(.CLK_FREQ_HZ(CLK_FREQ_HZ), .DEBOUNCE_MS(DEBOUNCE_MS)) db_reset (
        .clk(clk),
        .btn_in(btn_reset),
        .btn_pressed_pulse(reset_pulse)
    );

    // ---------------------------------------------------------------------
    // Parking controller: count 0..MAX_SPACES (20)
    // ---------------------------------------------------------------------
    wire [5:0] count; // enough for 0..20
    wire full;
    wire available;

    parking_ctrl #(.MAX_SPACES(20)) ctrl (
        .clk(clk),
        .rst(reset_pulse),
        .entry_pulse(entry_pulse),
        .exit_pulse(exit_pulse),
        .count(count),
        .full(full),
        .available(available)
    );

    // Map status into LEDs: leds[14] = available, leds[15] = full
    // (leds[0..13] show first 14 spots)
    // Note: XDC must map leds[0..15] to physical pins; see provided XDC.
    genvar i;
    generate
        for (i = 0; i < 14; i = i + 1) begin : LEDS_LOW
            // light LED i when count > i (first N LEDs lit)
            assign leds[i] = (count > i) ? 1'b1 : 1'b0;
        end
    endgenerate

    assign leds[14] = available;
    assign leds[15] = full;

    // ---------------------------------------------------------------------
    // 7-seg display: show count (0..20) on lower two digits (d1 d0)
    // d3 d2 are blank/zero.
    // Use synthesis-friendly logic for tens/ones:
    // ---------------------------------------------------------------------
    wire [3:0] tens;
    wire [3:0] ones;

    // tens: 0..2
    assign tens = (count >= 20) ? 4'd2 : (count >= 10 ? 4'd1 : 4'd0);
    // ones = count - tens*10
    wire [5:0] tens_x10;
    assign tens_x10 = (tens == 4'd2) ? 6'd20 : (tens == 4'd1 ? 6'd10 : 6'd0);
    assign ones = count - tens_x10; // result fits 0..9

    // pack into 4-digit value: {d3,d2,d1,d0}
    // show_value[15:12] = d3 (blank/0)
    // show_value[11:8]  = d2 (blank/0)
    // show_value[7:4]   = tens
    // show_value[3:0]   = ones
    wire [15:0] show_value;
    assign show_value = {4'd0, 4'd0, tens, ones};

    // decimal point unused: drive inactive (Basys3 DP is active-low; we drive high to turn off)
    assign dp = 1'b1;

    // instantiate display driver (defaults to active-low segments and anodes for Basys3)
// use module defaults (no named parameter overrides)
sevenseg_mux disp (
    .clk(clk),
    .rst(1'b0),
    .value(show_value),
    .seg(seg),
    .an(an)
);

endmodule
