module ALU_Controller(func3, func7, ALUOp, ALUControl);

    parameter [2:0] Add = 0 , Subtract = 1 , And = 2 , Or = 3,Slt = 4 , Sltu = 5 , Xor = 6;

    input [1:0] ALUOp;
    input [2:0] func3;
    input [6:0] func7;

    output reg [2:0] ALUControl;
    
    always @(ALUOp or func3 or func7)begin
        case (ALUOp)
            2'b00   : ALUControl <= Add;
            2'b01   : ALUControl <= Subtract;
            2'b10   : ALUControl <= 
                        (func3 == 3'h0 & func7 == 7'h00) ? Add:
                        (func3 == 3'h0 & func7 == 7'h10) ? Subtract:
                        (func3 == 3'h6 & func7 == 7'h00) ? Or:
                        (func3 == 3'h7 & func7 == 7'h00) ? And:
                        (func3 == 3'h2 & func7 == 7'h00) ? Slt:
                        (func3 == 3'h3 & func7 == 7'h00) ? Sltu : 3'bzzz;
            2'b11   : ALUControl <=  
                        (func3 == 3'h0) ? Add:
                        (func3 == 3'h4) ? Xor:
                        (func3 == 3'h6) ? Or:
                        (func3 == 3'h2) ? Slt:
                        (func3 == 3'h3) ? Sltu: 3'bzzz;
            default: ALUControl <= Add;
        endcase
    end
endmodule
