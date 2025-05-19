module datapath(clk, rst,opcode ,RegWrite,ImmSrc, ALUSrc,MemWrite,,ResultSrc, PCSrc,ALUControl, zero, negative, func7,  func3);

    input clk, rst, RegWrite, ALUSrc, MemWrite; 
    input [1:0] ResultSrc, PCSrc;
    input [2:0] ImmSrc, ALUControl;

    output zero, negative;
    output [2:0] func3;
    output [6:0] func7;
    output [6:0] opcode;

    wire [31:0] PC, instruction,next_PC, PC_plus4, PC_plusImm, extended_imm, RD2, RD1, ALU_in1, ALU_in2, ALU_result, read_data, result;

    register32bit pc(next_PC, clk, rst, PC);

    mux4to1 mux1(PC_plus4, PC_plusImm,ALU_result,32'bz,PCSrc, next_PC);

    Adder32bit PCPlus4(PC, 32'd4, PC_plus4);

    Adder32bit PCPlusImm(PC, extended_imm, PC_plusImm);

    mux2to1 mux2(RD2, extended_imm ,ALUSrc, ALU_in2);
    
    mux4to1 mux3(ALU_result, read_data,PC_plus4,extended_imm,ResultSrc, result);

    Imm_extender Imm_ext(ImmSrc, instruction[31:7], extended_imm);

    ALU alu(ALUControl, ALU_in1, ALU_in2, zero, negative, ALU_result);

    Instruction_memory IM(PC, instruction);

    RegisterFile RF(clk, RegWrite,instruction[19:15],instruction[24:20],instruction[11:7],result,RD1, RD2);

    Data_memory DM(ALU_result, RD2, MemWrite, clk, read_data);

    assign opcode = instruction[6:0];
    assign func3 = instruction[14:12];
    assign func7 = instruction[31:25];
    assign ALU_in1 = RD1;
    
endmodule