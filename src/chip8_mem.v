`timescale 1ns / 1ps

module chip8_mem(
    input wire clk,
    input wire write,
    input wire [11:0] mem_address,
    input wire [7:0] mem_data_in,
    output reg [7:0] mem_data_out
    );

    // This describes a 4096x8-bit memory that will be inferred as BRAM.
    reg [7:0] memory[0:4095];

    // This block is for SIMULATION ONLY.
    // Synthesis tools will ignore this because the 'SIMULATION'
    // macro will not be defined during a hardware build.
`ifdef SIMULATION
    initial begin
        $readmemh("src/game.mem", memory, 512);
    end
`endif

    always @(posedge clk) begin
        if (write) begin
            memory[mem_address] <= mem_data_in;
        end
        // Registered read, typical of a synchronous BRAM.
        mem_data_out <= memory[mem_address];
    end

endmodule