module general_controller(opcode, func3, regWriteD, ALUOp,resultSrcD, memWriteD, jumpD,branchD, ALUSrcD, immSrcD, luiD);

    parameter [6:0] R_type = 7'b0110011 , I_type = 7'b0010011 , JumpR_type = 7'b1100111,LW = 7'b0000011 , S_type = 7'b0100011 
                    , J_type = 7'b1101111, B_type = 7'b1100011 , U_type = 7'b0110111;

    parameter [2:0] BEQ = 0 , BNE = 1 , BLT = 2 , BGE = 3;

    input [6:0] opcode;
    input [2:0] func3;

    output reg memWriteD, regWriteD, ALUSrcD, luiD;
    output reg [1:0] resultSrcD, jumpD, ALUOp;
    output reg [2:0] branchD, immSrcD;
    
    always @(opcode,func3) begin 
        {ALUOp, regWriteD, immSrcD, ALUSrcD, memWriteD, resultSrcD, jumpD, ALUOp, branchD, immSrcD, luiD} <= 16'b0;
        case(opcode)
            R_type:begin
                ALUOp      <= 2'b10;
                regWriteD  <= 1'b1;
            end

            I_type:begin
                ALUOp      <= 2'b11;
                regWriteD  <= 1'b1;
                immSrcD    <= 3'b000;
                ALUSrcD    <= 1'b1;
                resultSrcD <= 2'b00;
            end

            JumpR_type:begin
                ALUOp      <= 2'b00;
                regWriteD  <= 1'b1;
                immSrcD    <= 3'b000;
                ALUSrcD    <= 1'b1;
                jumpD      <= 2'b10;
                resultSrcD <= 2'b10;
            end

            LW:begin
                ALUOp      <= 2'b00;
                regWriteD  <= 1'b1;
                immSrcD    <= 3'b000;
                ALUSrcD    <= 1'b1;
                resultSrcD <= 2'b01;
            end


            S_type:begin
                ALUOp      <= 2'b00;
                memWriteD  <= 1'b1;
                immSrcD    <= 3'b001;
                ALUSrcD    <= 1'b1;
            end
            
            J_type:begin
                resultSrcD <= 2'b10;
                immSrcD    <= 3'b011;
                jumpD      <= 2'b01;
                regWriteD  <= 1'b1;
            end

            B_type:begin
                ALUOp      <= 2'b01;
                immSrcD    <= 3'b010;
                case(func3)
                    BEQ   : branchD <= 3'b001;
                    BNE   : branchD <= 3'b010;
                    BLT   : branchD <= 3'b011;
                    BGE   : branchD <= 3'b100;
                    default: branchD <= 3'b000;
                endcase
            end

            U_type:begin
                resultSrcD <= 2'b11;
                immSrcD    <= 3'b100;
                regWriteD  <= 1'b1;
                luiD <= 1'b1;
            end

            default: begin
                regWriteD <= 1'b0;
                ALUSrcD   <= 2'b00;
                ALUOp     <= 3'b000;
            end
        endcase
    end
endmodule