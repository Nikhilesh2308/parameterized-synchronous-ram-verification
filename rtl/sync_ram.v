// Parameterized synchronous single-port RAM.
// Verilog-2001 compatible.
module sync_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4,
    parameter DEPTH = (1 << ADDR_WIDTH)
) (
    input  wire                  clk,
    input  wire                  en,
    input  wire                  we,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] wdata,
    output reg  [DATA_WIDTH-1:0] rdata
);
    // Kept visible for testbench back-door access in simulation.
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (en) begin
            if (we)
                mem[addr] <= wdata;
            else
                rdata <= mem[addr];
        end
    end
endmodule
