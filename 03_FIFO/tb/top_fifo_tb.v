`timescale 1ns / 1ps

module top_FIFO_tb;

    // Testbench Inputs (Registers)
    reg clk_100;
    reg rst;
    reg read;
    reg write;
    reg [3:0] din;

    // Testbench Outputs (Wires)
    wire full;
    wire empty;
    wire almost_empty;
    wire almost_full;
    wire [3:0] dout;
    wire [3:0] data_count;

    // Instantiate the DUT
    top_FIFO dut (
        .clk_100(clk_100),
        .rst(rst),
        .read(read),
        .write(write),
        .din(din),
        .full(full),
        .empty(empty),
        .almost_empty(almost_empty),
        .almost_full(almost_full),
        .dout(dout),
        .data_count(data_count)
    );

    // 100 MHz clock
    initial begin
        clk_100 = 0;
        forever #5 clk_100 = ~clk_100;
    end

    initial begin
        // ── Initialize all inputs ──────────────────────────
        rst   = 1;
        read  = 0;
        write = 0;
        din   = 4'b0000;

        // ── Phase 1: Reset ─────────────────────────────────
        @(posedge clk_100); #1;
        rst = 1;
        @(posedge clk_100); #1;
        rst = 0;            // release reset
        @(posedge clk_100); #1;

        // ── Phase 2: WRITE 'f' (1111) ──────────────────────
        write = 1;
        read  = 0;
        din   = 4'b1111;
        #3700;              // hold long enough for clk_pulse to latch

        // ── Phase 3: WRITE 'e' (1110) ──────────────────────
        @(posedge clk_100); #1;
        write = 1;
        read  = 0;
        din   = 4'b1110;
        #3700;

        // ── Phase 4: WRITE 'd' (1101) ──────────────────────
        @(posedge clk_100); #1;
        write = 1;
        read  = 0;
        din   = 4'b1101;
        #3700;

        // ── Phase 5: Stop writing, let FIFO settle ─────────
        @(posedge clk_100); #1;
        write = 0;
        read  = 0;
        #3700;              // wait for clk_pulse to go low

        // ── Phase 6: READ 'f' out ──────────────────────────
        @(posedge clk_100); #1;
        read  = 1;
        write = 0;
        #3700;

        // ── Phase 7: READ 'e' out ──────────────────────────
        @(posedge clk_100); #1;
        read  = 1;
        write = 0;
        #3700;

        // ── Phase 8: READ 'd' out ──────────────────────────
        @(posedge clk_100); #1;
        read  = 1;
        write = 0;
        #3700;

        // ── Phase 9: Stop reading ──────────────────────────
        @(posedge clk_100); #1;
        read  = 0;
        write = 0;

        // ── Let simulation settle and finish ───────────────
        #10000;
        $finish;
    end

    // Optional: monitor key signals in transcript
    initial begin
        $monitor("Time=%0t | write=%b read=%b din=%h | dout=%h data_count=%d | empty=%b full=%b almost_empty=%b almost_full=%b",
                  $time, write, read, din, dout, data_count, empty, full, almost_empty, almost_full);
    end

endmodule