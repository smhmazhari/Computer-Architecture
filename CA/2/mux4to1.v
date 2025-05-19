module mux4to1(mux_in1, mux_in2,mux_in3,mux_in4,mux_sel, mux_out);    
    input [31:0] mux_in1, mux_in2,mux_in3,mux_in4;
    input [1:0] mux_sel;

    output [31:0] mux_out;
    
    assign mux_out =(mux_sel == 0) ? mux_in1: 
                    (mux_sel == 1) ? mux_in2:
                    (mux_sel == 2) ? mux_in3:
                    mux_in4;

endmodule