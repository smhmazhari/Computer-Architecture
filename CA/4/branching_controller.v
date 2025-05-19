module branching_controller(branchE, jumpE, negative, zero, PCSrcE);

    parameter [2:0] BEQ = 1 , BNE = 2 , BLT = 3 , BGE = 4 , NOB = 0;
    parameter [1:0] NOJ = 0 , JAL = 1 , JALR = 2;

    input zero, negative;
    inout [2:0] branchE;
    input [1:0] jumpE;

    output reg [1:0] PCSrcE;
    
    always @(jumpE, zero, negative, branchE) begin
        case(branchE)
            NOB : PCSrcE <= (jumpE == JAL)  ? 2'b01 :
                             (jumpE == JALR) ? 2'b10 : 2'b00;

            BEQ : PCSrcE <= (zero)           ? 2'b01 : 2'b00;
            BNE : PCSrcE <= (~zero)          ? 2'b01 : 2'b00;
            BLT : PCSrcE <= (negative)            ? 2'b01 : 2'b00;
            BGE : PCSrcE <= (zero | ~negative)    ? 2'b01 : 2'b00;
        endcase
    end

endmodule