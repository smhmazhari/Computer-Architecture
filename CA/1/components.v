module counter_4bit (clock,reset,load,enable,parallel_input,count,carryO);
    input clock , reset , load , enable;
    input [3:0] parallel_input;
    output reg [3:0] count;
    output carryO;
    always @(posedge clock)
    begin
        if(reset)
            count <= 0;
        else if(load)
            count <= parallel_input;
        else if(enable)
            count <= count + 1;
    end
    assign carryO = &{count};
endmodule

module comparator_11(first,second,lt,eq,gt);
    input [10:0] first ,second;
    output lt ,eq,gt;
    assign lt = (first < second);
    assign eq = (first == second);
    assign gt = (first > second);
endmodule

module register_10(parallel_in,clock,reset,load,parallel_out);
    input [9:0] parallel_in;
    input clock , reset , load;
    output reg [9:0] parallel_out;
    always @(posedge clock)
    begin
        if(reset)
            parallel_out <= 0;
        else if(load)
            parallel_out <= parallel_in ;
    end
endmodule

module register_11(parallel_in,clock,reset,load,parallel_out);
    input [10:0] parallel_in;
    input clock , reset , load;
    output reg [10:0] parallel_out;
    always @(posedge clock)
    begin
        if(reset)
            parallel_out <= 0;
        else if(load)
            parallel_out <= parallel_in ;
    end
endmodule

module subtractor_11(a , b , sub_result);
    input [10:0] a , b;
    output [10:0] sub_result;
    assign sub_result = a - b ;
endmodule

module mux_2_to_1(first_option,second_option , selector , result);
    input [10:0] first_option,second_option;
    input selector;
    output [10:0]result;
    assign result = (selector) ? second_option : first_option;
endmodule


