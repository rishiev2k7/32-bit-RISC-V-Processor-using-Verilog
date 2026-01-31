
// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,
    input         RegWrite, Jalr,
    input [2:0]   ImmSrc,
    input [3:0]   ALUControl,
    output        Zero, 
	 output        Less_Than, Less_Than_U,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

wire [31:0] PCNext, PCPlus4, PCTarget, PCPlusUI, PCJalr;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult, UType, FReadData;

// next PC logic
reset_ff #(32) pcreg(clk, reset, PCJalr, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
adder          pcaddbranch(PC, ImmExt, PCTarget);
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext);

mux2 #(32)     jalrmux(PCNext, ALUResult, Jalr, PCJalr);


// register file logic
reg_file       rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, SrcA, WriteData);
imm_extend     ext (Instr[31:7], ImmSrc, ImmExt);
//UType Logic
//adder #(32)    AUIpcAdd(PC,{Instr[31:12],12'b0},PCPlusUI);
//mux2 #(32)     UTypemux(PCPlusUI, {Instr[31:12],12'b0}, Instr[5], UType);
mux2 #(32)     UTypemux(PCTarget, ImmExt, Instr[5], UType);
// ALU logic
mux2 #(32)     srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu            alu (SrcA, SrcB, ALUControl, ALUResult, Zero, Less_Than, Less_Than_U);

mux2 #(32)     lhumux(ReadData, {16'b0, ReadData[15:0]}, (Instr[6:0] == 7'b0000011 && Instr[14:12] == 3'b101), FReadData);
mux4 #(32)     resultmux(ALUResult, FReadData, PCPlus4, UType, ResultSrc, Result);

assign Mem_WrData = WriteData;
assign Mem_WrAddr = ALUResult;

endmodule

