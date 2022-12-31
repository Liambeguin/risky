if (state == STATE_DEBUG) begin
	case (funct3)
	ALU_SUB_ADD: $display("ALU: %0d <- %0d %s %0d", alu_out, alu_in1, funct7[5] ? "SUB" : "ADD", alu_in2);
	// 	if (funct7[5])
	// 		$display("ALU: %0d <- %0d SUB %0d", alu_out, alu_in1, alu_in2);
	// 	else
	// 		$display("ALU: %0d <- %0d ADD %0d", alu_out, alu_in1, alu_in2);
	// end
	// ALU_SLL:     alu_out = alu_in1 << shamt;
	// ALU_SLT:     alu_out = {32{$signed(alu_in1) < $signed(alu_in2)}};
	// ALU_SLTU:    alu_out = {32{alu_in1 < alu_in2}};
	// ALU_XOR:     alu_out = alu_in1 ^ alu_in2;
	// ALU_SRA_SRL: alu_out = funct7[5] ? $signed(alu_in1) >>> shamt : alu_in1 >> shamt;
	// ALU_OR:      alu_out = alu_in1 | alu_in2;
	// ALU_AND:     alu_out = alu_in1 & alu_in2;
	endcase
end
