module general_controller(clk, rst,opcode ,RegWrite,PCUpdate,IRWrite,ImmSrc,ALUSrcA,ALUSrcB,MemWrite,,ResultSrc, AdrSrc,ALUOp ,Branch);

    parameter [6:0] R_type = 7'b0110011 , I_type = 7'b0010011 , JumpR_type = 7'b1100111,LW = 7'b0000011 , S_type = 7'b0100011 
                    , J_type = 7'b1101111, B_type = 7'b1100011 , U_type = 7'b0110111;

    
    parameter [4:0] IF = 30 , ID = 31;

    input clk , rst;
    input [6:0] opcode;

    output reg RegWrite, MemWrite,PCUpdate,IRWrite,AdrSrc,Branch;
    output reg [1:0] ALUSrcA,ALUSrcB;
    output reg [1:0] ResultSrc, ALUOp;
    output reg [2:0] ImmSrc;

    reg [4:0] ps , ns;

    always @(posedge clk) 
        begin
            if(rst)
                ps <= IF;
            else
                ps <= ns;
        end

    always @(ps , opcode)
        begin
            case (ps)
                IF: ns = ID;
                ID: ns = (opcode == R_type) ? 1 :
                        (opcode == I_type) ? 3 :
                        (opcode == B_type) ? 10 :
                        (opcode == U_type) ? 14 :
                        (opcode == J_type) ? 11 :
                        (opcode == JumpR_type) ? 5 :
                        (opcode == S_type) ? 15 :
                        (opcode == LW) ? 7 : IF;
                1: ns = 2;
                2: ns = IF;
                3: ns = 4;
                4: ns = IF;
                5: ns = 6;
                6: ns = 4;
                7: ns = 8;
                8: ns = 9;
                9: ns = IF;
                10:ns = IF;
                11: ns = 12;
                12: ns = 13;
                13: ns = IF;
                14: ns = IF;
                15: ns = 16;
                16: ns = IF;
                default:ns = IF;
            endcase
        end

    always @(ps)
        begin
            {RegWrite, MemWrite,PCUpdate,IRWrite,AdrSrc,Branch,ALUSrcA,ALUSrcB,ResultSrc, ALUOp,ImmSrc} = 17'b0;
            case (ps)
                IF:begin
                    IRWrite <= 1;
                    PCUpdate <= 1;
                    ALUSrcA <= 2'b00;
                    ALUSrcB <= 2'b10;
                    ALUOp <= 00;
                    ResultSrc <= 10;
                end

                ID:begin
                    ALUSrcA = 2'b01;
                    ALUSrcB = 2'b01;
                    ImmSrc = 3'b010;
                    ALUOp = 2'b00; 
                end

                1:begin
                    ALUSrcA <= 2'b10;
                    ALUSrcB <= 2'b00;
                    ALUOp <= 2'b10;
                end

                2:begin
                    ResultSrc <= 2'b00;
                    RegWrite <= 1;
                end

                3:begin
                    ALUSrcA <= 2'b10;
                    ALUSrcB <= 2'b01;
                    ALUOp <= 2'b11;
                    ImmSrc <=3'b000;
                end

                4:begin
                    ResultSrc <= 2'b00;
                    RegWrite <= 1;
                end

                5:begin
                    ALUSrcA <= 2'b10;
                    ALUSrcB <= 2'b01;
                    ALUOp <= 2'b00;
                    ImmSrc <= 3'b000;
                end

                6:begin
                    PCUpdate <= 1;
                    ALUSrcA <= 2'b01;
                    ALUSrcB <= 2'b10;
                    ALUOp <= 2'b00;
                    ResultSrc <= 2'b00;
                end

                7:begin
                    ALUSrcA <= 2'b10;
                    ALUSrcB <= 2'b01;
                    ALUOp <= 2'b00;
                    ImmSrc <= 3'b000;
                end

                8:begin
                    AdrSrc <= 1;
                    ResultSrc <= 2'b00;
                end

                9:begin
                    ResultSrc <= 2'b01;
                    RegWrite <= 1;
                end

                10:begin
                    ALUSrcA <= 2'b10;
                    ALUSrcB <= 2'b00;
                    ALUOp <= 2'b01;
                    ResultSrc <= 0;
                    Branch <= 1;
                end

                11:begin
                    ALUSrcA <= 2'b01;
                    ALUSrcB <= 2'b10;
                    ALUOp <= 2'b00;
                end

                12:begin
                    ImmSrc <= 3'b011;
                    ALUSrcA <= 2'b01;
                    ALUSrcB <= 2'b01;
                    ALUOp <= 2'b00;
                    RegWrite <= 1;
                end

                13:begin
                    ResultSrc <= 2'b00;
                    PCUpdate <= 1;
                end

                14:begin
                    ImmSrc <= 3'b100;
                    ResultSrc <= 2'b11;
                    RegWrite <= 1;
                end

                15:begin
                    ALUSrcA   <= 2'b10;
                    ALUSrcB   <= 2'b01;
                    ALUOp     <= 2'b00;
                    ImmSrc    <= 3'b001;
                end

                16:begin
                    ResultSrc <= 2'b00;
                    AdrSrc    <= 1'b1;
                    MemWrite  <= 1'b1;
                end

            endcase
        end
     
endmodule