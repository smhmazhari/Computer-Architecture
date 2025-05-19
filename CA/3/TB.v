module TB();
    reg clk, rst;
    Risc_V CUT(clk, rst);

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        #2 rst = 1'b1;
        #7 rst = 1'b0;
        #5000 $stop;
    end
    
endmodule
