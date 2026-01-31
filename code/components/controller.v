
// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        Zero, 
	 input        Less_Than, Less_Than_U,
    output       [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc, ALUSrc,
    output       RegWrite, Jump, Jalr,
    output [2:0] ImmSrc,
    output [3:0] ALUControl
);

wire [2:0] ALUOp;
wire       Branch;
wire flag;

main_decoder    md (op, funct3, funct7b5, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, Jalr, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5, ALUOp, ALUControl);

// for jump and branch
//assign flag = ((funct3 == 3'b000 && Zero)) || (funct3 == 3'b001 && ~Zero) || (funct3 == 3'b100 && Less_Than) || (funct3 == 3'b101 && ~Less_Than) || (funct3 == 3'b110 && Less_Than_U) || (funct3 == 3'b111 && ~Less_Than_U));
assign PCSrc = (Branch & ((funct3 == 3'b000 && Zero) || (funct3 == 3'b001 && ~Zero) || (funct3 == 3'b100 && Less_Than) || (funct3 == 3'b101 && ~Less_Than) || (funct3 == 3'b110 && Less_Than_U) || (funct3 == 3'b111 && ~Less_Than_U))) | Jump;

endmodule

