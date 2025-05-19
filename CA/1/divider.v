module divider(A,B,Q_out,reset,start,clock,busy,DVZ,OVF,valid);
	input [9:0] A,B;
	input reset,start,clock;
	output [9:0] Q_out;
	output busy,OVF,valid,DVZ;

	wire [9:0] Q;
	wire dvz , ovf;
	wire load_a,load_b,load_Q,load_Q_next,load_acc,load_acc_next,
    load_counter,enable_counter,sel_Q,sel_acc,sel_dvz,done,carry_out , lt_comp3 ;

	datapath dp(A,B,load_a,load_b,load_Q,load_Q_next,load_acc,load_acc_next,load_counter
			,clock,reset,enable_counter,sel_Q,sel_acc,sel_dvz,Q,dvz,ovf,carry_out,lt_comp3);

	controller cu(lt_comp3,carry_out,start,done,load_a,load_b,load_Q,load_Q_next,load_acc,load_acc_next,
                load_counter,clock,reset,enable_counter,sel_Q,sel_acc,sel_dvz,busy,dvz,ovf,valid);

	assign Q_out = (valid) ? Q : 10'bz;
	assign DVZ = (dvz) ? 1:1'bz;
	assign OVF = (ovf) ? 1:1'bz;
endmodule