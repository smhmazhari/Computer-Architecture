module RISCV(clk, rst);
    input clk, rst;

    wire ALUSrcD, memWriteD, regWriteD, luiD;    
    wire [1:0] resultSrcD, jumpD;
    wire [2:0] immSrcD, branchD;
    wire [2:0] func3, ALUControlD;
    wire [6:0] opcode,func7; 

    controller CU(clk, rst, opcode, func3, func7,regWriteD, resultSrcD, memWriteD,jumpD, branchD, ALUControlD,ALUSrcD, immSrcD, luiD);

    datapath DP(clk, rst, regWriteD, resultSrcD, memWriteD, jumpD, branchD, ALUControlD, ALUSrcD, immSrcD, luiD, opcode, func3, func7);

endmodule