module mux2to1(mux_in1, mux_in2,mux_sel, mux_out);    
    input [31:0] mux_in1, mux_in2;
    input mux_sel;

    output [31:0] mux_out;
    
    assign mux_out = mux_sel ? mux_in2 : mux_in1;
endmodule