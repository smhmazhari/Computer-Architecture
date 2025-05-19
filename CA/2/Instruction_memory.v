module Instruction_memory(pc, instruction);

    input [31:0] pc;

    output [31:0] instruction;

    reg [7:0] instruction_memory [0:$pow(2, 16)-1]; 
    wire [31:0] adr;

    initial $readmemb("instructions2.mem", instruction_memory);

    assign adr = {pc[31:2], 2'b00}; 
    assign instruction = {instruction_memory[adr], instruction_memory[adr + 1], instruction_memory[adr + 2], instruction_memory[adr + 3]};
endmodule