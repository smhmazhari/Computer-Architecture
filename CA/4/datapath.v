module datapath(clk, rst, regWriteD, resultSrcD, memWriteD, jumpD, branchD, ALUControlD, ALUSrcD, immSrcD, luiD, opcode, func3, func7);

    input clk, rst, regWriteD, memWriteD, ALUSrcD, luiD;
    input  [1:0] resultSrcD, jumpD;
    input  [2:0] ALUControlD, branchD, immSrcD;

    output [6:0] opcode,func7;
    output [2:0] func3;

    wire regWriteW, regWriteM, memWriteM, luiE, 
         luiM, regWriteE, 
         ALUSrcE, memWriteE, flushE, zero, negative, 
         stallF, stallD, flushD;

    wire [1:0] resultSrcW, resultSrcM, jumpE, PCSrcE, resultSrcE, forwardAE, forwardBE;
    wire [2:0] branchE, ALUControlE;
    wire [4:0] RdW, RdM, Rs1E, Rs2E, RdE, Rs1D, Rs2D, RdD;

    wire [31:0] ALUResultM, writeDataM, PCPlus4M, extImmM, RDM,
                resultW, extImmW, ALUResultW, PCPlus4W, RDW,
                RD1E, RD2E, PCE, SrcAE, SrcBE, writeDataE,       
                PCTargetE, extImmE, PCPlus4E, ALUResultE, 
                PCPlus4D, instrD, PCD, RD1D, RD2D, extImmD,
                PCF_Prime, PCF, instrF, PCPlus4F,
                mux_result; 

    // F
    Adder32bit PCFAdder(PCF, 32'd4, PCPlus4F);

    register32bitEN PCreg(PCF_Prime, clk,rst,~stallF,PCF);

    Instruction_memory IM(PCF, instrF);

    mux4to1 PCmux(PCPlus4F, PCTargetE, ALUResultE, 32'bz,PCSrcE, PCF_Prime);

    reg_if_id regIFID(.clk(clk), .rst(rst), 
        .en(~stallD), .clr(flushD),.PCF(PCF),.PCD(PCD),
        .PCPlus4F(PCPlus4F),.PCPlus4D(PCPlus4D),.instrF(instrF),.instrD(instrD));


    // D
    RegisterFile RF(.clk(clk), .regWrite(regWriteW),.readRegister1(instrD[19:15]), 
        .readRegister2(instrD[24:20]),.writeRegister(RdW), .writeData(resultW),.readData1(RD1D), .readData2(RD2D));
    
    Imm_extender immunit(immSrcD,instrD[31:7],extImmD);

    ALU alu(ALUControlE, SrcAE, SrcBE, zero, negative, ALUResultE);

    reg_id_ex regIDEX(.clk(clk), .rst(rst), .clr(flushE), 
        .regWriteD(regWriteD),.regWriteE(regWriteE), .PCD(PCD),.PCE(PCE),
        .Rs1D(Rs1D),.Rs1E(Rs1E),.Rs2D(Rs2D),.Rs2E(Rs2E),
        .RdD(RdD),.RdE(RdE),.RD1D(RD1D),.RD1E(RD1E),
        .RD2D(RD2D),.RD2E(RD2E), .resultSrcD(resultSrcD),.resultSrcE(resultSrcE),
        .memWriteD(memWriteD),.memWriteE(memWriteE),.jumpD(jumpD),.jumpE(jumpE),
        .branchD(branchD),.branchE(branchE),.ALUControlD(ALUControlD),.ALUControlE(ALUControlE), 
        .ALUSrcD(ALUSrcD),.ALUSrcE(ALUSrcE),    .extImmD(extImmD),.extImmE(extImmE),
        .luiD(luiD),.luiE(luiE),.PCPlus4D(PCPlus4D),.PCPlus4E(PCPlus4E) );
     

    
    // E    
    mux4to1 SrcAreg ( RD1E, resultW, mux_result, 32'bz,forwardAE, SrcAE);

    mux4to1 BSrcBreg(RD2E, resultW, mux_result, 32'bz,forwardBE,  writeDataE);

    mux2to1 SrcBreg(writeDataE, extImmE,ALUSrcE, SrcBE);

    Adder32bit PCEAdder(PCE, extImmE, PCTargetE);

    reg_ex_mem regEXMEM(.clk(clk), .rst(rst), .PCPlus4M(PCPlus4M),.PCPlus4E(PCPlus4E),
        .resultSrcE(resultSrcE),   .resultSrcM(resultSrcM),.writeDataE(writeDataE),   .writeDataM(writeDataM),
        .luiE(luiE),               .luiM(luiM),.regWriteE(regWriteE),     .regWriteM(regWriteM), 
        .RdE(RdE),                 .RdM(RdM),.memWriteE(memWriteE),     .memWriteM(memWriteM),
        .ALUResultE(ALUResultE), .ALUResultM(ALUResultM),.extImmE(extImmE), .extImmM(extImmM));


    // M
    Data_memory DM(ALUResultM, writeDataM, memWriteM, clk, RDM);

    mux2to1 muxMSrcA(ALUResultM, extImmM,luiM ,mux_result);

    reg_mem_wb regMEMWB(.clk(clk), .rst(rst), .regWriteM(regWriteM),  .regWriteW(regWriteW),
        .ALUResultM(ALUResultM),   .ALUResultW(ALUResultW),.RDM(RDM),    .RDW(RDW),
        .RdM(RdM), .RdW(RdW),.resultSrcM(resultSrcM), .resultSrcW(resultSrcW),  
        .PCPlus4M(PCPlus4M),  .PCPlus4W(PCPlus4W),.extImmM(extImmM),  .extImmW(extImmW));


    // W
    mux4to1 resMux(ALUResultW, RDW, PCPlus4W, extImmW,resultSrcW ,resultW);

    
    HazardUnit hazard(Rs1D, Rs2D, RdE, RdM, RdW, Rs2E, Rs1E,PCSrcE, resultSrcE[0], regWriteW,regWriteM,
                    stallF, stallD, flushD,flushE, forwardAE, forwardBE);

    branching_controller branch_cu(branchE, jumpE, negative, zero, PCSrcE);


    assign opcode = instrD[6:0];
    assign RdD = instrD[11:7];
    assign func3 = instrD[14:12];
    assign Rs1D =  instrD[19:15];
    assign Rs2D = instrD[24:20];
    assign func7 = instrD[31:25];

endmodule