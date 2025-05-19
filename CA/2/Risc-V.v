module Risc_V(clk,rst);
    input clk, rst;
    
    wire RegWrite, MemWrite,  ALUSrc,zero, negative;
    wire [1:0] PCSrc , ResultSrc;
    wire [2:0] func3, ALUControl, ImmSrc;
    wire [6:0] opcode, func7; 

    controller CU(opcode , RegWrite,PCSrc,ResultSrc, MemWrite, func3, func7,  ALUControl,ALUSrc, ImmSrc,  zero,negative);

    datapath DP(clk, rst,opcode ,RegWrite,ImmSrc, ALUSrc,MemWrite,,ResultSrc, PCSrc,ALUControl, zero, negative, func7,  func3);
endmodule