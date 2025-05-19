module controller(opcode , RegWrite,PCSrc,ResultSrc, MemWrite, func3, func7,  ALUControl,ALUSrc, ImmSrc,  zero,negative);

    input zero, negative;
    input [2:0] func3;
    input [6:0] opcode , func7;
    
    output RegWrite, MemWrite, ALUSrc;
    output [1:0] PCSrc, ResultSrc;
    output [2:0] ALUControl, ImmSrc;
    
    wire Jump, Jumpr, Branch, branch_result;
    wire [1:0] ALUOp;
    

    general_controller CU1(opcode,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,ALUOp ,Branch ,Jump, Jumpr);

    ALU_Controller CU2(func3, func7, ALUOp, ALUControl);

    branching_controller CU3(func3, Branch, negative, zero, branch_result);

    assign PCSrc =  (Jumpr) ? 2'b10 : (Jump | branch_result) ? 2'b01: 2'b00;

endmodule