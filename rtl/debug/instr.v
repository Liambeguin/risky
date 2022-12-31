`define DEBUG

always @(posedge clk) begin
`ifdef DEBUG
	if (state == STATE_EXECUTE) begin
		case (opcode)
		OPCODE_OP: begin
			// $display("%d\tOP:\tx%0d <- x%0d (OP=%0b) x%0d", pc, rdid, rs1id, funct3, rs2id);
			$write("%d\tOP:\tx%0d <- ", pc, rdid);
			case (funct3)
			ALU_SUB_ADD: $write("%s", (funct7[5] & instr[5]) ?  "SUB" : "ADD");
			ALU_SLL:     $write("SLL");
			ALU_SLT:     $write("SLT");
			ALU_SLTU:    $write("SLTU");
			ALU_XOR:     $write("XOR");
			ALU_SRA_SRL: $write("%s", funct7[5] ? "SRA" : "SRL");
			ALU_OR:      $write("OR");
			ALU_AND:     $write("AND");
			endcase
			$display("(x%0d, x%0d)", rs1id, rs2id);

		end
		OPCODE_OP_IMM:	begin
			// $display("%d\tOP-IMM:\tx%0d <- x%0d (OP=%0b) %0d", pc, rdid, rs1id, funct3, I_imm);
			$write("%d\tOP-IMM:\tx%0d <- ", pc, rdid);
			case (funct3)
			ALU_SUB_ADD: $write("ADDI");
			ALU_SLL:     $write("SLLI");
			ALU_SLT:     $write("SLTI");
			ALU_SLTU:    $write("SLTIU");
			ALU_XOR:     $write("XORI");
			ALU_SRA_SRL: $write("%s", funct7[5] ? "SRAI" : "SRLI");
			ALU_OR:      $write("ORI");
			ALU_AND:     $write("ANDI");
			endcase
			$display("(x%0d, %0d)", rs1id, I_imm);
		end
		OPCODE_LUI: begin
			$display("%d\tLUI:\t", pc);
		end
		OPCODE_AUIPC: begin
			$display("%d\tAUIPC:\t", pc);
		end
		OPCODE_JAL: begin
			$display("%d\tJAL:\tx%d <- (pc+4); pc <- pc + %0d", pc, rdid, J_imm);
		end
		OPCODE_JALR: begin
			$display("%d\tJALR:\tx%0d <- (pc+4); pc <- pc + %0d", pc, rdid, I_imm);
		end
		OPCODE_BRANCH:	begin
			$write("%d\tBRANCH:\t", pc);
			case (funct3)
			BRANCH_BEQ:  $write("x%0d == x%0d (%x)\n", rs1id, rs2id, rs1 == rs2);
			BRANCH_BNE:  $write("x%0d != x%0d (%x)\n", rs1id, rs2id, rs1 != rs2);
			BRANCH_BLT:  $write("x%0d <  x%0d (%x)\n", rs1id, rs2id, $signed(rs1) < $signed(rs2));
			BRANCH_BGE:  $write("x%0d >= x%0d (%x)\n", rs1id, rs2id, $signed(rs1) >= $signed(rs2));
			BRANCH_BLTU: $write("x%0d <  x%0d (%x)\n", rs1id, rs2id, rs1 < rs2);
			BRANCH_BGEU: $write("x%0d >= x%0d (%x)\n", rs1id, rs2id, rs1 >= rs2);
			endcase
		end
		OPCODE_LOAD: begin
			$write("%d\tLOAD_", pc);
			case (funct3)
			3'b000: $write("BYTE");
			3'b001: $write("HALF");
			3'b010: $write("WORD");
			3'b100: $write("BYTEU");
			3'b101: $write("HALFU");
			endcase
			$display(":\tx%0d <- mem[x%0d + %0d]", rdid, rs1id, I_imm);
		end
		OPCODE_STORE: begin
			$write("%d\tSTORE_", pc);
			case (funct3)
			3'b000: $write("BYTE");
			3'b001: $write("HALF");
			3'b010: $write("WORD");
			endcase
			$display(":\tmem[x%0d + %0d] <- x%0d", rs1id, S_imm, rs2id);
		end
		OPCODE_MISC_MEM: begin
			$display("%d\tMEM-MISC:\t", pc);
		end
		OPCODE_SYSTEM: begin
			$display("SYSTEM:\t");
			$display("register file:\t");
			for (i = 0; i < XLEN; i++) $display("%d\t0x%x", i, x[i]);
			$finish;
		end
		default: begin
			$display("Unknown OPCODE: 7'b%b_%b_%b (%d)", opcode[6:5], opcode[4:2], opcode[1:0], opcode);
			$finish;
		end
		endcase
	end else if (state == STATE_DEBUG) begin
		if (opcode == OPCODE_OP ||
		    opcode == OPCODE_OP_IMM ||
		    opcode == OPCODE_LOAD || opcode == OPCODE_STORE
		) begin
			$display("\t\t\tx%0d=0x%x\t(%0d)", rdid, x[rdid], x[rdid]);
		end
	end
`else
	if (state == STATE_DEBUG) begin
		$display("%b", x[10]);
	end
	if (opcode == OPCODE_SYSTEM) begin
		$finish;
	end
`endif
end

