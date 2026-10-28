`timescale 1ns/1ps

module tb_sync_ram;
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    parameter DEPTH = (1 << ADDR_WIDTH);

    reg clk = 1'b0;
    reg en = 1'b0;
    reg we = 1'b0;
    reg [ADDR_WIDTH-1:0] addr = 0;
    reg [DATA_WIDTH-1:0] wdata = 0;
    wire [DATA_WIDTH-1:0] rdata;

    integer pass_count = 0;
    integer fail_count = 0;
    reg [DATA_WIDTH-1:0] expected;
    reg [8*256-1:0] init_file;
    reg [8*256-1:0] dump_file;
    integer init_loaded;
    integer dump_requested;

    sync_ram #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .DEPTH(DEPTH)) dut (
        .clk(clk), .en(en), .we(we), .addr(addr), .wdata(wdata), .rdata(rdata)
    );

    always #5 clk = ~clk;

    task fd_write;
        input [ADDR_WIDTH-1:0] a;
        input [DATA_WIDTH-1:0] d;
        begin
            @(negedge clk);
            en = 1'b1; we = 1'b1; addr = a; wdata = d;
            @(posedge clk); #1;
            @(negedge clk);
            en = 1'b0; we = 1'b0;
        end
    endtask

    task fd_read_check;
        input [ADDR_WIDTH-1:0] a;
        input [DATA_WIDTH-1:0] exp;
        begin
            @(negedge clk);
            en = 1'b1; we = 1'b0; addr = a;
            @(posedge clk); #1;
            if (rdata !== exp) begin
                $display("FAIL FD read addr=%0d expected=0x%0h got=0x%0h", a, exp, rdata);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS FD read addr=%0d data=0x%0h", a, rdata);
                pass_count = pass_count + 1;
            end
            @(negedge clk);
            en = 1'b0;
        end
    endtask

    task bd_write;
        input [ADDR_WIDTH-1:0] a;
        input [DATA_WIDTH-1:0] d;
        begin
            @(negedge clk);
            dut.mem[a] = d;
            $display("INFO BD write addr=%0d data=0x%0h", a, d);
        end
    endtask

    task bd_read_check;
        input [ADDR_WIDTH-1:0] a;
        input [DATA_WIDTH-1:0] exp;
        reg [DATA_WIDTH-1:0] actual;
        begin
            actual = dut.mem[a];
            if (actual !== exp) begin
                $display("FAIL BD read addr=%0d expected=0x%0h got=0x%0h", a, exp, actual);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS BD read addr=%0d data=0x%0h", a, actual);
                pass_count = pass_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("sync_ram.vcd");
        $dumpvars(0, tb_sync_ram);

        // Optional initialization: pass +INIT_FILE=sim/init.hex to the simulator.
        init_loaded = $value$plusargs("INIT_FILE=%s", init_file);
        if (init_loaded) begin
            $display("INFO loading memory from %0s", init_file);
            $readmemh(init_file, dut.mem);
        end else begin
            $display("INFO INIT_FILE not supplied; starting with simulator-default memory contents");
        end

        // Scenario 1: Front-door write -> front-door read.
        fd_write(4'd1, 8'hA1);
        fd_read_check(4'd1, 8'hA1);

        // Scenario 2: Back-door write -> back-door read.
        bd_write(4'd2, 8'hB2);
        bd_read_check(4'd2, 8'hB2);

        // Scenario 3: Back-door write -> front-door read.
        bd_write(4'd3, 8'hC3);
        fd_read_check(4'd3, 8'hC3);

        // Scenario 4: Front-door write -> back-door read.
        fd_write(4'd4, 8'hD4);
        bd_read_check(4'd4, 8'hD4);

        // Optional memory export controlled by a runtime plusarg.
        dump_requested = $value$plusargs("DUMP_FILE=%s", dump_file);
        if (dump_requested) begin
            $writememh(dump_file, dut.mem);
            $display("INFO wrote memory dump to %0s", dump_file);
        end else begin
            $writememh("ram_dump.hex", dut.mem);
            $display("INFO wrote memory dump to ram_dump.hex");
        end

        $display("--------------------------------");
        $display("RAM test summary: PASS=%0d FAIL=%0d", pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL RAM TESTS PASSED");
        else
            $display("RAM TESTS FAILED");
        $finish;
    end
endmodule
