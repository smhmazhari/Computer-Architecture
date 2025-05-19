module datapath(clk, rst,opcode ,RegWrite,PCWrite,IRWrite,ImmSrc,ALUSrcA,ALUSrcB,MemWrite,,ResultSrc, AdrSrc,ALUControl, zero, negative, func7,  func3);

    input clk, rst, RegWrite, MemWrite,PCWrite,IRWrite; 
    input [1:0] ResultSrc, AdrSrc,ALUSrcA,ALUSrcB;
    input [2:0] ImmSrc, ALUControl;

    output zero, negative;
    output [2:0] func3;
    output [6:0] func7;
    output [6:0] opcode;

    wire [31:0] PC, instruction, extended_imm, RD2, RD1, ALU_in1, ALU_in2, ALU_result, read_data, result;

    wire [31:0] Old_PC ,MDR_out,A_out,B_out,ALUOut,Adr;

    register32bitEN pc(result, clk, rst,PCWrite ,PC);
    register32bit oldPC(PC , clk , rst , Old_PC);
    register32bitEN IR (read_data,clk,rst,IRWrite,instruction);
    register32bit MDR (read_data , clk, rst , MDR_out);
    register32bit A(RD1 , clk , rst , A_out);
    register32bit B(RD2 , clk , rst , B_out);
    register32bit ALUReg(ALU_result,clk,rst,ALUOut);

    mux2to1 mux1(PC, result ,AdrSrc, Adr);

    Memory IDM(Adr, B_out, MemWrite, clk, read_data);

    Imm_extender Imm_ext(ImmSrc, instruction[31:7], extended_imm);

    RegisterFile RF(clk, RegWrite,instruction[19:15],instruction[24:20],instruction[11:7],result,RD1, RD2);
    
    mux4to1 mux2(PC, Old_PC,A_out,32'bz,ALUSrcA, ALU_in1);
    
    mux4to1 mux3(B_out, extended_imm,32'd4,32'bz,ALUSrcB, ALU_in2);
    
    ALU alu(ALUControl, ALU_in1, ALU_in2, zero, negative, ALU_result);

    mux4to1 mux4(ALUOut, MDR_out,ALU_result,extended_imm,ResultSrc, result);

    assign opcode = instruction[6:0];
    assign func3 = instruction[14:12];
    assign func7 = instruction[31:25];
    
endmodule