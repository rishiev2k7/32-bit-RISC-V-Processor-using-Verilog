
// alu_decoder.v - logic for ALU decoder

module alu_decoder (
    input            opb5,
    input [2:0]      funct3,
    input            funct7b5,
    input [2:0]      ALUOp,
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        3'b000: ALUControl = 4'b0000;             // addition
        3'b001: ALUControl = 4'b0001;             // subtraction
        3'b010:
            case (funct3) // R-type or I-type ALU
                3'b000: begin
                    // True for R-type subtract
                    if   (funct7b5 & opb5) ALUControl = 3'b001; //sub
                    else ALUControl = 4'b0000; // add, addi
                end
                3'b010:  ALUControl = 4'b0101; // slt, slti
					 3'b011:  ALUControl = 4'b0110; //sltu, sltiu
                3'b110:  ALUControl = 4'b0011; // or, ori
                3'b111:  ALUControl = 4'b0010; // and, andi
					 3'b100:  ALUControl = 4'b0100; //xor
                default: ALUControl = 4'bxxxx; // ???
            endcase
        3'b011:
            case(funct3)
                3'b001: ALUControl = 4'b0111; //sll
                3'b101: ALUControl = funct7b5 ? 4'b1001 : 4'b1000; //srl/sra
					 default : ALUControl = 4'bxxxx;
            endcase
				
		  3'b100: ALUControl = 4'b1010;
		  3'b101: ALUControl = 4'b1011;
		  default: ALUControl = 4'bxxxx;
    endcase
end

endmodule

