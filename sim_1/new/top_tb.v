`timescale 1ns/1ps
module tb_parking_ctrl;
    reg clk = 0;
    reg rst = 0;
    reg entry_pulse = 0;
    reg exit_pulse  = 0;
    wire [5:0] count;
    wire full;
    wire available;

    // instantiate unit under test
    parking_ctrl #(.MAX_SPACES(20)) uut (
        .clk(clk), .rst(rst),
        .entry_pulse(entry_pulse),
        .exit_pulse(exit_pulse),
        .count(count), .full(full), .available(available)
    );

    // 100 MHz clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        $display("Time\tcount\tfull\tavail\tcomment");
        $monitor("%0t\t%0d\t%b\t%b\t%0s", $time, count, full, available, " ");
        // reset
        rst = 1; #20;
        rst = 0; #20;

        // increment 5 times
        repeat (5) begin
            entry_pulse = 1; #10;
            entry_pulse = 0; #30;
        end

        // decrement 2 times
        repeat (2) begin
            exit_pulse = 1; #10;
            exit_pulse = 0; #30;
        end

        // fast increment to reach MAX_SPACES (20)
        repeat (20) begin
            entry_pulse = 1; #10;
            entry_pulse = 0; #5;
        end
        #50;
        // attempt one extra entry -> should not increase beyond 20
        entry_pulse = 1; #10; entry_pulse = 0; #20;

        // now drain to zero
        repeat (22) begin
            exit_pulse = 1; #10;
            exit_pulse = 0; #5;
        end
        #50;

        // test simultaneous exit + entry in same cycle:
        // set count to 5 quickly
        rst = 1; #20; rst = 0; #20;
        repeat (5) begin entry_pulse = 1; #10; entry_pulse = 0; #5; end
        #20;
        // now assert both pulses same cycle (simulate both sensors firing)
        entry_pulse = 1; exit_pulse = 1; #10;
        entry_pulse = 0; exit_pulse = 0; #20;

        $display("Final count = %0d (should be 5)", count);
        $finish;
    end
endmodule
