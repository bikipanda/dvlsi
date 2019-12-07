
`timescale 1 ns / 10 ps

`include "Hopefield_main.v"

module tb_Hopefield_main();

integer i=0;
integer j=0;

reg clk, rst;
reg [7:0] weight_ele;
reg [15:0] input_patt;

// wires
wire [15:0] detected;
//wire complete;
//wire [15:0] input_;
wire [3:0] counter1;
wire [3:0] counter2;
wire detect_rst;

//main m1(we, oe, memory_ipop, cntr_rst, clk, rst);
//detect d1 (input_, complete, weight_ele, input_patt, clk, rst);
//detect d1 (complete, weight_ele, input_patt, clk, rst);
//main m1(weight_ele, input_patt, clk, rst);
//add_ a1 (input_, input_, weight_ele, ctrl, clk, rst);
top_detect top_detect_module (counter1, counter2, detect_rst, detected, weight_ele, input_patt, clk, rst);


// generating clock
always
begin 

	clk = 1'b0;
	#10;
	clk = 1'b1;
	#10;

end

// reading weight elements from file and 
// store them in a reg

////////////////////////////////////////////////////

reg [7:0] test_memory [0:16*16-1];

    initial 
    begin
        $display("Loading rom...");
        $readmemh("weight_elements.mem", test_memory);
    end

////////////////////////////////////////////////////


always @(posedge clk)
begin
	if (detect_rst == 0)
	begin
		weight_ele <= 0;
	end
	else
	begin
		// based on the address, send the weight elements
		weight_ele <= test_memory[{counter2, counter1}];
	end
end



initial 
begin

	$dumpfile("tb_Hopefield.vcd");
	$dumpvars(0,tb_Hopefield_main);

	rst = 1'b0; 

	////////////////////////////////////////////
	///// standard input patterns //////////////
	////////////////////////////////////////////
	
	//input_patt = 16'b1000_1110_1110_1000; // C
	//input_patt = 16'b1000_1010_1011_1011; // J 
	//input_patt = 16'b0001_1101_1101_1101; // L
	//input_patt = 16'b0000_0110_0110_0110; // U
	
	
	////// matlab standard patterns
	//inputpatt0 = [0 0 0 1 0 1 1 1 0 1 1 1 0 0 0 1]; // c
	//inputpatt1 = [1 1 0 1 1 1 0 1 0 1 0 1 0 0 0 1]; // J
	//inputpatt2 = [1 0 1 1 1 0 1 1 1 0 1 1 1 0 0 0]; // L
	//inputpatt3 = [0 1 1 0 0 1 1 0 0 1 1 0 0 0 0 0]; // U
	
	
	/////// errored pattern
	
	input_patt = 16'b1001_1100_1110_1001; // C
	//input_patt = 16'b1000_1010_1011_1011; // J 
	//input_patt = 16'b0001_1101_1101_1101; // L
	//input_patt = 16'b0000_0110_0110_0110; // U
	
	////// matlab errored pattern
	// noisy C =[0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 1]
	// noisy J =[0 0 0 1 1 1 0 1 0 1 0 1 0 0 0 1]
	// noisy L =[1 0 1 1 1 0 1 1 1 0 1 0 0 0 0 0]
	// noisy U =[0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0]
	
	
	#70;
	rst = 1'b1;


	
	#70000;
	
	$finish();

end

endmodule
