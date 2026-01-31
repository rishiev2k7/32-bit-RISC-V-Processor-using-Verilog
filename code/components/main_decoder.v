
// main_decoder.v - logic for main decoder

module main_decoder (
    input  [6:0] op,
	 input  [2:0] funct3,
	 input        funct7b5,
    output [1:0] ResultSrc,
    output       MemWrite, Branch, ALUSrc,
    output       RegWrite, Jump, Jalr,
    output [2:0] ImmSrc,
    output [2:0] ALUOp
	 
);

reg [13:0] controls;

always @(*) begin
    casez (op)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump_Jalr
        7'b0000011: controls = 14'b1_000_1_0_01_0_000_0_0; // lw
        7'b0100011: controls = 14'b0_001_1_1_00_0_000_0_0; // sw
		  
        7'b0110011: begin
		      casez(funct3)
				    3'b?01 : controls = 14'b1_xxx_0_0_00_0_011_0_0; //sll,srl,sra
					 default : controls = 14'b1_xxx_0_0_00_0_010_0_0; // R–type
				endcase
		  end
		  
        7'b1100011: begin
		      casez(funct3)
				    3'b00? : controls = 14'b0_010_0_0_00_1_001_0_0; // beq or bne
					 3'b10? : controls = 14'b0_010_0_0_00_1_100_0_0; // blt or bge
					 3'b11? : controls = 14'b0_010_0_0_00_1_101_0_0; // bltu or bgeu
					 default : controls = 14'bx_xxx_x_x_xx_x_xxx_x_x;
				endcase
		  end
		  
        7'b0010011: begin
		      casez(funct3)
				    3'b?01 : controls = 14'b1_101_1_0_00_0_011_0_0; //slli,srli,srai
					 default : controls = 14'b1_000_1_0_00_0_010_0_0; // I–type ALU
				endcase
		  end
        7'b1101111: controls = 14'b1_011_0_0_10_0_000_1_0; // jal
        7'b0?10111: controls = 14'b1_100_x_0_11_0_xxx_0_0; //lui or auipc
		  7'b1100111: controls = 14'b1_000_1_0_10_0_000_0_1; // jalr
        default:    controls = 14'bx_xxx_x_x_xx_x_xxx_x_x; // ???
    endcase
end

assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = controls;

endmodule

