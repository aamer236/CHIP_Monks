`timescale 1ns / 1ps

module chip8_mem(
    input wire clk,
    input wire write,
    input wire read,
    input wire [7:0] mem_data_in,
    input wire [11:0] mem_address,
    output reg [7:0] mem_data_out
    );

    // This memory will be inferred as a Block RAM (BRAM) on an FPGA.
    // To initialize this memory on hardware, you would typically use a
    // memory initialization file (.mif or .coe) specified in your
    // FPGA project settings, or use a synthesis directive.
    reg [7:0] memory[0:4095];

    // The font set needs to be loaded into the BRAM during initialization.
    // For simulation, we can still use an initial block. For synthesis,
    // this block should be wrapped in a `ifdef SIMULATION` guard or
    // be handled by vendor-specific memory initialization.
    initial begin
        memory[0] = 8'hF0; memory[1] = 8'h90; memory[2] = 8'h90; memory[3] = 8'h90; memory[4] = 8'hF0; // 0
        memory[5] = 8'h20; memory[6] = 8'h60; memory[7] = 8'h20; memory[8] = 8'h20; memory[9] = 8'h70; // 1
        // ... (rest of the font set)
        $readmemh("src/game.mem", memory, 512);
    end

    always @(posedge clk) begin
        if (write) begin
            memory[mem_address] <= mem_data_in;
        end
        // The read is registered, data will be available on the next clock cycle
        mem_data_out <= memory[mem_address];
    end

endmodule