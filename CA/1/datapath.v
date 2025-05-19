module datapath(par_in_a,par_in_b,load_a,load_b,load_Q,load_Q_next,load_acc,load_acc_next,
                load_counter,clock,reset,enable_counter,sel_Q,sel_acc,sel_dvz,
                par_out_Q,dvz,ovf,carry_out,lt_comparator3);

	input [9:0] par_in_a , par_in_b;
	input load_a,load_b,load_Q,load_Q_next,load_acc,load_acc_next,load_counter;
	input clock,reset,enable_counter;
	input sel_Q,sel_acc,sel_dvz;

	output [9:0]par_out_Q;
    output ovf , dvz , carry_out,lt_comparator3;

	parameter [3:0] PAR_IN_COUNTER = 4'b0001;

	wire [3:0] par_out_counter;
	wire lt_comp1,eq_comp1,gt_comp1;
	wire lt_comp2,eq_comp2,gt_comp2;
	wire eq_comp3,gt_comp3;

	wire [9:0] par_out_a , par_out_b , par_out_Q_next;

	wire [10:0] par_in_Q; //result mux 1

	wire [10:0] par_out_acc,par_out_acc_next;

	wire [10:0] sub_result;

	wire [10:0] par_in_acc,par_in_acc_next;

	wire [10:0] result_mux3;

	counter_4bit counter(clock,reset,load_counter,enable_counter,PAR_IN_COUNTER,par_out_counter,carry_out);

	comparator_11 comparator1({5'b0,par_out_Q_next[9:4]},11'b0,lt_comp1,eq_comp1,gt_comp1);
	comparator_11 comparator2({7'b0,par_out_counter},{7'b0,4'b1010},lt_comp2,eq_comp2,gt_comp2);
	comparator_11 comparator3(result_mux3,{1'b0,par_out_b},lt_comparator3,eq_comp3,gt_comp3);

	register_10 reg_A(par_in_a,clock,reset,load_a,par_out_a);
	register_10 reg_B(par_in_b,clock,reset,load_b,par_out_b);
	register_10 reg_Q(par_in_Q[9:0],clock,reset,load_Q,par_out_Q);
	register_10 reg_Q_next({par_out_Q[8:0],~lt_comparator3},clock,reset,load_Q_next,par_out_Q_next);

	register_11 reg_ACC(par_in_acc,clock,reset,load_acc,par_out_acc);
	register_11 reg_ACC_next(par_in_acc_next,clock,reset,load_acc_next,par_out_acc_next);

	mux_2_to_1 mux1({1'b0,par_out_a[8:0],1'b0},{1'b0,par_out_Q_next} , sel_Q , par_in_Q);
	mux_2_to_1 mux2({10'b0,par_out_a[9]},par_out_acc_next , sel_acc , par_in_acc);
	mux_2_to_1 mux3(par_out_acc,11'b0,sel_dvz,result_mux3);
	mux_2_to_1 mux4({par_out_acc[9:0],par_out_Q[9]},{sub_result[9:0],par_out_Q[9]} , ~lt_comparator3 , par_in_acc_next);

	subtractor_11 subtractor(par_out_acc , {1'b0,par_out_b} , sub_result);

	assign ovf = ~eq_comp1 && eq_comp2 ;
	assign dvz = ~|{par_in_b};
endmodule
