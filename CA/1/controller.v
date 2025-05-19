module controller(lt_comparator3,carry_out,start,done,load_a,load_b,load_Q,load_Q_next,load_acc,load_acc_next,
        load_counter,clock,reset,enable_counter,sel_Q,sel_acc,sel_dvz,
        busy,dvz,ovf,valid);
        input start,reset,clock,lt_comparator3,ovf,carry_out,dvz;
        output reg load_a,load_b,load_Q,load_Q_next,load_acc,load_acc_next,
                load_counter,enable_counter,sel_Q,sel_acc,sel_dvz,
                busy,valid,done;

        parameter [3:0]  Init = 1 , S2 = 2,S3 = 3,S4 = 4,S5 = 5,S6 = 6,S7 = 7,S8 = 8,S9 = 9,S10 = 10,S11 = 11,Done = 12,VALID = 13 ;

        reg [3:0] ps , ns;

        always @(posedge clock) 
        begin
            if(reset)
                ps <= Init;
            else
                ps <= ns;
        end

        always @(ps , start , dvz , ovf)
        begin
            case (ps)
                Init: ns = (start)? S2 : Init;
                S2: ns = (~start) ? S3 : S2;
                S3: ns = S4;
                S4: ns = (dvz)? Done : S5;
                S5: ns = S6;
                S6: ns = (lt_comparator3)? S7 : S8;
                S7: ns = S10;
                S8: ns = S9;
                S9: ns = S10;
                S10: ns = (ovf) ? Done : S11;
                S11: ns = (carry_out) ? VALID : S6;
                Done:ns = Init;
                VALID: ns = Init;
                default:ns = Init;
            endcase
        end

        always @(ps)
        begin
            {load_a,load_b,load_counter,sel_dvz,load_Q,load_acc,enable_counter
            ,load_acc_next,load_Q_next,done} = 10'b0;
            {valid,busy} = 2'bzz;
            {sel_Q,sel_acc} = 2'b11;
            case (ps)
                S3:{load_a,load_b,load_counter,busy,sel_dvz} = 5'b1_1111;
                S4:{busy}=1'b1;
                S5:
                begin
                {load_acc,busy,load_Q} = 3'b111;
                {sel_Q,sel_acc} = 2'b00;
                end
                S6:{enable_counter,busy} = 2'b11; 
                S7:{load_acc_next,load_Q_next , busy} = 3'b111;
                S8:{load_acc_next,busy} = 2'b11;
                S9:{load_acc_next,load_Q_next,busy} = 3'b111;
                S10:{busy} = 1'b1;
                S11:{load_acc,load_Q,busy} = 3'b111;
                VALID:valid = 1'b1;
                Done:done = 1'b1; 
            endcase
        end
endmodule