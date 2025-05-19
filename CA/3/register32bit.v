module register32bit(parIn, clk, rst, parOut);
    input [31:0] parIn;
    input clk, rst;

    output reg [31:0] parOut;
    
    always @(posedge clk , posedge rst) begin
        if(rst)
            parOut <= {32{1'b0}};
        else
            parOut <= parIn;
    end

endmodule

module register32bitEN(parIn, clk, rst,enable ,parOut);
    input [31:0] parIn;
    input clk, rst,enable;

    output reg [31:0] parOut;
    
    always @(posedge clk , posedge rst) begin
        if(rst)
            parOut <= {32{1'b0}};
        else if(enable)
            parOut <= parIn;
    end

endmodule