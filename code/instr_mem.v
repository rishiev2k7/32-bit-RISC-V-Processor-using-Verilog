
// instr_mem.v - instruction memory

module instr_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 512) (
    input       [ADDR_WIDTH-1:0] instr_addr,
    output      [DATA_WIDTH-1:0] instr
);

// array of 64 32-bit words or instructions
reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];

//In your module:
//No clock
//No writes
//Only reads
//Synthesizer will infer ROM, not RAM.

initial begin
//    $readmemh("rv32i_book.hex", instr_ram);
    $readmemh("rv32i_test.hex", instr_ram);
end

// word-aligned memory access, last 2 bits always 0 as PC always increments by 4
// Word aligned access = Accessing 32-bit words only at addresses divisible by 4
// combinational read logic
assign instr = instr_ram[instr_addr[31:2]];

endmodule

