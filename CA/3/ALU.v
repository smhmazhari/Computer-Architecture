module ALU(opcode, in1, in2, zero, negative, ALU_result);

    parameter [2:0] Add = 0 , Subtract = 1 , And = 2 , Or = 3,Slt = 4 , Sltu = 5 , Xor = 6;

    input [2:0] opcode;
    input  [31:0] in1, in2;
    
    output zero, negative;
    output reg  [31:0] ALU_result;
    
    always @(in1 or in2 or opcode) begin
        case (opcode)
            Add:  ALU_result = in1 + in2;
            Subtract:  ALU_result = in1 - in2;
            And:  ALU_result = in1 & in2;
            Or:  ALU_result = in1 | in2;
            Slt:  ALU_result = 
                        (in1[31] == 1 & in2[31] == 0) ? 32'd1 :
                        (in1[31] == 0 & in2[31] == 1) ? 32'd0 : (in1[30:0] < in2[30:0]);
            Sltu: ALU_result = (in1 < in2) ? 32'd1 : 32'd0;
            Xor:  ALU_result = in1 ^ in2;
            default:  ALU_result = {32{1'bz}};
        endcase
    end

    assign zero = (~|ALU_result);
    assign negative = ALU_result[31];

endmodule