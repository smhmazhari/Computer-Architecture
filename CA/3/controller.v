module controller(clk, rst,opcode,PCWrite ,RegWrite,IRWrite,ImmSrc,ALUSrcA,ALUSrcB,ALUControl,MemWrite,,ResultSrc, AdrSrc ,zero, negative,func3,func7);
    input clk, rst;
    input zero, negative;
    input [2:0] func3;
    input [6:0] opcode , func7;
    
    output RegWrite, MemWrite,AdrSrc,PCWrite,IRWrite;
    output [1:0] ResultSrc,ALUSrcA,ALUSrcB;
    output [2:0] ALUControl, ImmSrc;
    
    wire  Branch, branch_result;
    wire [1:0] ALUOp;
    

    general_controller CU1(clk, rst,opcode ,RegWrite,PCUpdate,IRWrite,ImmSrc,ALUSrcA,ALUSrcB,MemWrite,,ResultSrc, AdrSrc,ALUOp ,Branch);

    ALU_Controller CU2(func3, func7, ALUOp, ALUControl);

    branching_controller CU3(func3, Branch, negative, zero, branch_result);

    assign PCWrite =  PCUpdate | branch_result;

endmodule