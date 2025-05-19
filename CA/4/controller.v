module controller(clk, rst, opcode, func3, func7,regWriteD, resultSrcD, memWriteD,jumpD, branchD, ALUControlD,ALUSrcD, immSrcD, luiD);

    input clk, rst;
    input [2:0] func3;
    input [6:0] opcode,func7;
    
    output ALUSrcD, memWriteD, regWriteD, luiD;
    output [1:0] resultSrcD, jumpD;
    output [2:0] ALUControlD, immSrcD,branchD;

    wire [1:0] ALUOp;

    general_controller general(opcode, func3, regWriteD, ALUOp,resultSrcD, memWriteD, jumpD,branchD, ALUSrcD, immSrcD, luiD);
    
    ALU_Controller ALU_CU(func3, func7, ALUOp, ALUControlD);
    
endmodule