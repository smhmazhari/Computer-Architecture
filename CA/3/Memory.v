module Memory(mem_adr, to_be_written_data, MemWrite, clk, read_data);

    input MemWrite, clk;
    input [31:0] mem_adr, to_be_written_data;

    output [31:0] read_data;

    reg [7:0] data_memory [0:$pow(2, 16)-1]; // 64KB

    wire [31:0] address;

    initial $readmemb("memory.mem", data_memory); 

    assign address = {mem_adr[31:2], 2'b00};

    always @(posedge clk) begin
        if(MemWrite)
            {data_memory[address], data_memory[address + 1], data_memory[address + 2], data_memory[address + 3]} <= to_be_written_data;
    end

    assign read_data = {data_memory[address], data_memory[address + 1], data_memory[address + 2], data_memory[address + 3]};

endmodule