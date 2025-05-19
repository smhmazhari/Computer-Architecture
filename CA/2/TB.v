module TB();
    reg clk, rst;

    Risc_V CUT(clk , rst);

    always #10 clk = ~clk;

    initial begin
        clk = 1'b0;
        #5 rst = 1'b1;
        #8 rst = 1'b0;
        #1450 $stop;
    end

endmodule