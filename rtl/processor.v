`default_nettype none

module processor(
	input clk,
	// input resetn,
	output [XLEN-1:0] mem_addr,
	input [XLEN-1:0] mem_rdata,
	output mem_rstrb,
	output [3:0] mem_wmask,
	output [XLEN-1:0] mem_wdata);

	parameter XLEN = 32;

	localparam OPCODE_OP		= 7'b01_100_11;
	localparam OPCODE_OP_IMM	= 7'b00_100_11;
	localparam OPCODE_LUI		= 7'b01_101_11;
	localparam OPCODE_AUIPC		= 7'b00_101_11;
	localparam OPCODE_JAL		= 7'b11_011_11;
	localparam OPCODE_JALR		= 7'b11_001_11;
	localparam OPCODE_BRANCH	= 7'b11_000_11;
	localparam OPCODE_LOAD		= 7'b00_000_11;
	localparam OPCODE_STORE		= 7'b01_000_11;
	localparam OPCODE_MISC_MEM	= 7'b00_011_11;
	localparam OPCODE_SYSTEM	= 7'b11_100_11;


	reg [31:0] pc;
	reg [XLEN-1:0] rs1;
	reg [XLEN-1:0] rs2;

	reg [31:0] instr;
	wire [6:0] opcode = instr[ 6: 0];
	wire [4:0] rdid   = instr[11: 7];
	wire [2:0] funct3 = instr[14:12];
	wire [4:0] rs1id  = instr[19:15];
	wire [4:0] rs2id  = instr[24:20];
	wire [6:0] funct7 = instr[31:25];

	wire [31:0] I_imm = {{21{instr[31]}}, instr[30:20]};
	wire [31:0] S_imm = {{21{instr[31]}}, instr[30:25], instr[11:7]};
	wire [31:0] B_imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
	wire [31:0] U_imm = {instr[31], instr[30:12], 12'b0};
	wire [31:0] J_imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};

	// register file
	reg [XLEN-1:0] x[0:XLEN-1];
	wire [XLEN-1:0] cpu_reg_ra  = x[1];
	wire [XLEN-1:0] cpu_reg_sp  = x[2];
	wire [XLEN-1:0] cpu_reg_gp  = x[3];
	wire [XLEN-1:0] cpu_reg_tp  = x[4];
	wire [XLEN-1:0] cpu_reg_t0  = x[5];
	wire [XLEN-1:0] cpu_reg_t1  = x[6];
	wire [XLEN-1:0] cpu_reg_t2  = x[7];
	wire [XLEN-1:0] cpu_reg_s0  = x[8];
	wire [XLEN-1:0] cpu_reg_s1  = x[9];
	wire [XLEN-1:0] cpu_reg_a0  = x[10];
	wire [XLEN-1:0] cpu_reg_a1  = x[11];
	wire [XLEN-1:0] cpu_reg_a2  = x[12];
	wire [XLEN-1:0] cpu_reg_a3  = x[13];
	wire [XLEN-1:0] cpu_reg_a4  = x[14];
	wire [XLEN-1:0] cpu_reg_a5  = x[15];
	wire [XLEN-1:0] cpu_reg_a6  = x[16];
	wire [XLEN-1:0] cpu_reg_a7  = x[17];
	wire [XLEN-1:0] cpu_reg_s2  = x[18];
	wire [XLEN-1:0] cpu_reg_s3  = x[19];
	wire [XLEN-1:0] cpu_reg_s4  = x[20];
	wire [XLEN-1:0] cpu_reg_s5  = x[21];
	wire [XLEN-1:0] cpu_reg_s6  = x[22];
	wire [XLEN-1:0] cpu_reg_s7  = x[23];
	wire [XLEN-1:0] cpu_reg_s8  = x[24];
	wire [XLEN-1:0] cpu_reg_s9  = x[25];
	wire [XLEN-1:0] cpu_reg_s10 = x[26];
	wire [XLEN-1:0] cpu_reg_s11 = x[27];
	wire [XLEN-1:0] cpu_reg_t3  = x[28];
	wire [XLEN-1:0] cpu_reg_t4  = x[29];
	wire [XLEN-1:0] cpu_reg_t5  = x[30];
	wire [XLEN-1:0] cpu_reg_t6  = x[31];

	integer i;
	initial begin
		pc = 0;
		for (i = 0; i < XLEN; i++) x[i] = 'b0;
	end

	// Top-level state machine
	localparam STATE_FETCH_INSTR	= 0;
	localparam STATE_WAIT_INSTR	= 1;
	localparam STATE_EXECUTE	= 2;
	localparam STATE_LOAD		= 3;
	localparam STATE_STORE		= 4;
	localparam STATE_WAIT_DATA	= 5;
	reg[2:0] state = STATE_FETCH_INSTR;

	always @(posedge clk) begin
		case (state)
		STATE_FETCH_INSTR: begin
			state <= STATE_WAIT_INSTR;
		end
		STATE_WAIT_INSTR: begin
			instr <= mem_rdata;
			rs1 <= x[mem_rdata[19:15]];
			rs2 <= x[mem_rdata[24:20]];

			state <= STATE_EXECUTE;
		end
		STATE_EXECUTE: begin
			$display("PC %x", pc);
			case (opcode)
			OPCODE_JAL:    pc <= pc + J_imm;
			OPCODE_JALR:   pc <= rs1 + I_imm;
			OPCODE_BRANCH: begin
				if (do_branch) pc <= pc + B_imm;
				else pc <= pc + 4;
			end
			default: pc <= pc + 4;
			endcase

			state <=
				opcode == OPCODE_LOAD ? STATE_LOAD :
				opcode == OPCODE_STORE ? STATE_STORE :
				STATE_FETCH_INSTR;
		end
		STATE_LOAD: begin
			state <= STATE_WAIT_DATA;
		end
		STATE_STORE: begin
			state <= STATE_WAIT_DATA;
		end
		STATE_WAIT_DATA: begin
			state <= STATE_FETCH_INSTR;
		end
		endcase
	end

	// Branching
	localparam BRANCH_BEQ	= 3'b000;
	localparam BRANCH_BNE	= 3'b001;
	localparam BRANCH_BLT	= 3'b100;
	localparam BRANCH_BGE	= 3'b101;
	localparam BRANCH_BLTU	= 3'b110;
	localparam BRANCH_BGEU	= 3'b111;

	reg do_branch;

	always @(*) begin
		case (funct3)
		BRANCH_BEQ:  do_branch = rs1 == rs2;
		BRANCH_BNE:  do_branch = rs1 != rs2;
		BRANCH_BLT:  do_branch = $signed(rs1) < $signed(rs2);
		BRANCH_BGE:  do_branch = $signed(rs1) >= $signed(rs2);
		BRANCH_BLTU: do_branch = rs1 < rs2;
		BRANCH_BGEU: do_branch = rs1 >= rs2;
		default:     do_branch = 'b0;
		endcase
	end

	// ALU
	localparam ALU_SUB_ADD	= 3'b000;
	localparam ALU_SLL	= 3'b001;
	localparam ALU_SLT	= 3'b010;
	localparam ALU_SLTU	= 3'b011;
	localparam ALU_XOR	= 3'b100;
	localparam ALU_SRA_SRL	= 3'b101;
	localparam ALU_OR	= 3'b110;
	localparam ALU_AND	= 3'b111;

	wire [XLEN-1:0] alu_in1 = rs1;
	wire [XLEN-1:0] alu_in2 = (opcode == OPCODE_OP) ? rs2 : I_imm;
	wire [4:0] shamt = (opcode == OPCODE_OP) ? rs2[4:0] : instr[24:20];

	reg [XLEN-1:0] alu_out;

	always @(*) begin
		case (funct3)
		ALU_SUB_ADD: alu_out = (funct7[5] & instr[5]) ?  alu_in1 - alu_in2 : alu_in1 + alu_in2;
		ALU_SLL:     alu_out = alu_in1 << shamt;
		ALU_SLT:     alu_out = {32{$signed(alu_in1) < $signed(alu_in2)}};
		ALU_SLTU:    alu_out = {32{alu_in1 < alu_in2}};
		ALU_XOR:     alu_out = alu_in1 ^ alu_in2;
		ALU_SRA_SRL: alu_out = funct7[5] ? $signed(alu_in1) >>> shamt : alu_in1 >> shamt;
		ALU_OR:      alu_out = alu_in1 | alu_in2;
		ALU_AND:     alu_out = alu_in1 & alu_in2;
		endcase

		// `include "debug/alu.v"
	end

	// Load-Store
	wire [XLEN-1:0] loadstore_addr = rs1 + ((opcode == OPCODE_LOAD) ? I_imm : S_imm);
	wire byte_access = funct3[1:0] == 2'b00;
	wire half_access = funct3[1:0] == 2'b01;

	wire [7:0] load_byte =
		loadstore_addr[1:0] == 2'b00 ? mem_rdata[7:0] :
		loadstore_addr[1:0] == 2'b01 ? mem_rdata[15:8] :
		loadstore_addr[1:0] == 2'b10 ? mem_rdata[23:16] :
		mem_rdata[31:24];

	wire [15:0] load_half =
		loadstore_addr[1] ? mem_rdata[31:16] :
		mem_rdata[15:0];

	wire load_sign = !funct3[2] & (byte_access ? load_byte[7] : load_half[15]);

	wire [XLEN-1:0] load_data =
		byte_access ? {{24{load_sign}}, load_byte} :
		half_access ? {{16{load_sign}}, load_half} :
		mem_rdata;

	assign mem_wdata[ 7: 0] = rs2[7:0];
	assign mem_wdata[15: 8] = loadstore_addr[0] ? rs2[7:0]  : rs2[15: 8];
	assign mem_wdata[23:16] = loadstore_addr[1] ? rs2[7:0]  : rs2[23:16];
	assign mem_wdata[31:24] = loadstore_addr[0] ? rs2[7:0]  :
		loadstore_addr[1] ? rs2[15:8] : rs2[31:24];

	wire [3:0] store_wmask =
		byte_access ? (
			loadstore_addr[1] ?
				(loadstore_addr[0] ? 4'b1000 : 4'b0100) :
				(loadstore_addr[0] ? 4'b0010 : 4'b0001)) :
		half_access ?
			(loadstore_addr[1] ? 4'b1100 : 4'b0011) :
		4'b1111;

	// write-back
	wire wben =
		((state == STATE_EXECUTE) && (opcode != OPCODE_BRANCH) && (opcode != OPCODE_LOAD) && (opcode != OPCODE_STORE)) ||
		(state == STATE_WAIT_DATA);

	wire [XLEN-1:0] wbdata =
		(opcode == OPCODE_LUI) ? U_imm :
		(opcode == OPCODE_AUIPC) ? pc + U_imm :
		((opcode == OPCODE_JAL) || (opcode == OPCODE_JALR)) ? pc + 4 :
		(opcode == OPCODE_LOAD) ? load_data :
		alu_out;

	always @ (posedge clk) begin
		if (wben && rdid != 0) begin
			x[rdid] <= wbdata;
		end
	end


`ifdef BENCH
	always @(posedge clk) begin
		if (state == STATE_EXECUTE) begin
			case (opcode)
			OPCODE_SYSTEM: begin
				$display("");
				$display("register file:\t");
				$display("pc:\t%x", pc);
				$display("ra:\t%x", x[1]);
				$display("sp:\t%x", x[2]);
				for (i = XLEN-1; i >= 0; i = i-2) $display("x%0d:\t%x\tx%0d:\t%x", i, x[i], i-1, x[i-1]);
				$finish;
			end
			endcase
		end
	end
`endif

	assign mem_addr = (state == STATE_FETCH_INSTR || state == STATE_WAIT_INSTR) ? pc : loadstore_addr;
	assign mem_rstrb = (state == STATE_FETCH_INSTR || state == STATE_LOAD);
	assign mem_wmask = {4{(state == STATE_STORE)}} & store_wmask;
endmodule
