module general_controller(opcode,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,ALUOp ,Branch ,Jump, JumpR);

    parameter [6:0] R_type = 7'b0110011 , I_type = 7'b0010011 , JumpR_type = 7'b1100111,LW = 7'b0000011 , S_type = 7'b0100011 
                    , J_type = 7'b1101111, B_type = 7'b1100011 , U_type = 7'b0110111;

    input [6:0] opcode;

    output reg RegWrite, MemWrite, ALUSrc, Jump, JumpR, Branch;
    output reg [1:0] ResultSrc, ALUOp;
    output reg [2:0] ImmSrc;
    
    always @(opcode) begin 
        {MemWrite, RegWrite, ALUSrc, Jump, JumpR, Branch, ResultSrc, ALUOp, ImmSrc} <= 13'b0;
        case(opcode)
            R_type:begin
                ALUOp     <= 2'b10;
                RegWrite  <= 1'b1;
            end

            I_type:begin
                ALUOp     <= 2'b11;
                RegWrite  <= 1'b1;
                ImmSrc    <= 3'b000;
                ALUSrc    <= 1'b1;
                JumpR      <= 1'b0;
                ResultSrc <= 2'b00;
            end

            JumpR_type:begin
                ALUOp     <= 2'b00;
                RegWrite  <= 1'b1;
                ImmSrc    <= 3'b000;
                ALUSrc    <= 1'b1;
                JumpR      <= 1'b1;
                ResultSrc <= 2'b10;
            end

            LW:begin
                ALUOp     <= 2'b00;
                RegWrite  <= 1'b1;
                ImmSrc    <= 3'b000;
                ALUSrc    <= 1'b1;
                JumpR      <= 1'b0;
                ResultSrc <= 2'b01;
            end


            S_type:begin
                ALUOp     <= 2'b00;
                MemWrite  <= 1'b1;
                ImmSrc    <= 3'b001;
                ALUSrc    <= 1'b1;
            end
            
            J_type:begin
                ResultSrc <= 2'b10;
                ImmSrc    <= 3'b011;
                Jump       <= 1'b1;
                RegWrite  <= 1'b1;
            end

            B_type:begin
                ALUOp     <= 2'b01;
                ImmSrc    <= 3'b010;
                Branch    <= 1'b1;
            end

            U_type:begin
                ResultSrc <= 2'b11;
                ImmSrc    <= 3'b100;
                RegWrite  <= 1'b1;
            end
        endcase
    end
endmodule