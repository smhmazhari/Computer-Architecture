module branching_controller(func3, Branch, negative, zero, branch_result);

    parameter [1:0] BEQ = 0 , BNE = 1 , BLT = 2 , BGE = 3;

    input Branch, zero, negative;
    input [2:0] func3;

    output reg branch_result;
    
    always @(func3, Branch, negative, zero) begin
        branch_result <= 0;
        case(func3)
            BEQ: branch_result <= Branch & zero;
            BNE: branch_result <= Branch & ~zero;
            BLT: branch_result <= Branch & negative;
            BGE: branch_result <= Branch & (zero | ~negative);
            default: branch_result <= 0;
        endcase
    end
endmodule