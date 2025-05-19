module Risc_V(clk,rst);
    input clk, rst;
    
    wire RegWrite, MemWrite,  ALUSrc,zero, negative;
    wire [1:0] PCSrc , ResultSrc;
    wire [2:0] func3, ALUControl, ImmSrc;
    wire [6:0] opcode, func7; 

    wire [1:0] ALUSrcA ,ALUSrcB;
    wire PCWrite ,IRWrite,AdrSrc;

    controller CU(clk, rst,opcode,PCWrite ,RegWrite,IRWrite,ImmSrc,ALUSrcA,ALUSrcB,ALUControl,MemWrite,,ResultSrc, AdrSrc ,zero, negative,func3,func7);

    datapath DP(clk, rst,opcode ,RegWrite,PCWrite,IRWrite,ImmSrc,ALUSrcA,ALUSrcB,MemWrite,,ResultSrc, AdrSrc,ALUControl, zero, negative, func7,  func3);
endmodule