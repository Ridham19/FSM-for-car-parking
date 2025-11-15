// parking_ctrl.v
// Keeps count of parked cars from 0..MAX_SPACES
module parking_ctrl #(
    parameter MAX_SPACES = 20
)(
    input  wire clk,
    input  wire rst,           // synchronous reset (active high)
    input  wire entry_pulse,   // one-cycle pulse when a car enters
    input  wire exit_pulse,    // one-cycle pulse when a car leaves
    output reg  [5:0] count,   // up to 63; we'll use only up to MAX_SPACES
    output wire full,
    output wire available
);
    // status
    assign full = (count == MAX_SPACES);
    assign available = (count < MAX_SPACES);

    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end else begin
            // priority: handle exit then entry in same cycle if both pressed
            if (exit_pulse && (count > 0))
                count <= count - 1;
            else if (entry_pulse && (count < MAX_SPACES))
                count <= count + 1;
        end
    end
endmodule
