module Imm_extender(immSrc, data, extended_data);

    parameter [2:0] I_type = 0 , S_type = 1 , J_type = 3 , B_type = 2 , U_type = 4;

    input [2:0] immSrc;
    input [24:0] data;
    
    output reg [31:0] extended_data;

    always @(immSrc, data) begin
        case(immSrc)
            I_type: extended_data <= {{20{data[24]}}, data[24:13]};
            S_type: extended_data <= {{20{data[24]}}, data[24:18], data[4:0]};
            J_type: extended_data <= {{12{data[24]}}, data[12:5], data[13], data[23:14], 1'b0};
            B_type: extended_data <= {{20{data[24]}}, data[0], data[23:18], data[4:1], 1'b0};
            U_type: extended_data <= {data[24:5], {12{1'b0}}};
            default: extended_data <= 32'b0;
        endcase
    end

endmodule