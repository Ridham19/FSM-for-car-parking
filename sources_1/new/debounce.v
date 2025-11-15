// debounce.v
// Debounce a mechanical button and produce a one-clock-cycle pulse on press
module debounce #(
    parameter CLK_FREQ_HZ = 100_000_000,
    parameter DEBOUNCE_MS = 20
)(
    input  wire clk,
    input  wire btn_in,
    output reg  btn_pressed_pulse
);
    localparam integer CNT_MAX = (CLK_FREQ_HZ/1000) * DEBOUNCE_MS;
    reg [31:0] cnt;
    reg btn_sync_0, btn_sync_1;
    reg btn_stable;

    // 2-stage synchronizer
    always @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
    end

    // simple debounce
    always @(posedge clk) begin
        if (btn_sync_1 == btn_stable) begin
            cnt <= 0;
            btn_pressed_pulse <= 1'b0;
        end else begin
            if (cnt < CNT_MAX) begin
                cnt <= cnt + 1;
                btn_pressed_pulse <= 1'b0;
            end else begin
                // stable change
                btn_stable <= btn_sync_1;
                // produce pulse only when transitioning 0->1 (pressed)
                btn_pressed_pulse <= btn_sync_1 & ~btn_stable;
                cnt <= 0;
            end
        end
    end
endmodule
