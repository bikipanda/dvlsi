
////////////////////////////////////////////////////////////////////////
		//////	Hopefield Network using Hebb's rule //////
////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 10 ps

/////////////////////////////////////////////////////////////////////////
/////// top module //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


module top_detect(counter1, counter2, detect_rst, detected_op, weight_ele, input_patt, clk, rst);

// input ports
input clk, rst;
input [7:0] weight_ele;
input [15:0] input_patt;

// output ports
output reg [15:0] detected_op;
output reg detect_rst;
output [3:0] counter1; 
output [3:0] counter2;

// internal registers
reg [15:0] modified_input;
reg [15:0] modified_prev;
reg [15:0] input_pattern;
reg cmp_rst;
//reg [7:0] weight_reg;

// internal wires
wire complete;
wire [15:0] input_;
wire cmp_out;


////// instantiation of the modules //////

// detect module, on reset high (active high), takes input and weight elements and modifies the input pattern 
detect d (counter1, counter2, input_, complete, weight_ele, input_pattern, clk, detect_rst);

// Once detect module modifies the input, compare module compares the previous pattern and modified pattern
// and raises the output cmp_out 'high' if patterns are not equal and hence repeat the process.
compare cmp_old_and_new (cmp_out, modified_input, modified_prev, clk, cmp_rst);


always @(posedge clk)
begin

	if(rst == 0)
	begin
		// on reset low, reset all the registers to zero or required values.
		detected_op <= 0;
		modified_input <= 0;
		cmp_rst <= 0;
		input_pattern <= input_patt;
		modified_prev <= input_patt;
	end
	else
	begin
	
		// if the detect modules modifies the input pattern, it raises the complete flag.
		if(complete == 1)
		begin
			// if pattern is modified, disable the detect module,
			// enable the compare module
			detect_rst <= 0;
			modified_input <= input_;
			cmp_rst <= 1;
		end
		else
		begin
			cmp_rst <= 0;
		end
		
		// if the compare module gives high output, i.e. the patterns are not equal
		// then repeat the process again
		if(cmp_out == 1)
		begin
			// enable the detect module again
			detect_rst <= 1;
			input_pattern <= modified_input;
			modified_prev <= modified_input;
		end
		else 
		begin
			// if the patterns are equal, then the modified pattern is the output.
			detected_op <= modified_input;
		end

	end
	
end


always @*
begin

	detect_rst <= rst;

end


endmodule
/////////////////////////////////////////////////////////////////////////
/////// top module ends /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////
/////// detect module ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////// 

module detect(counter1, counter2, input_, complete, weight_ele, input_patt, clk, rst);

// module constants
parameter wt_bits = 8;
parameter cntr1_width = 4;
parameter cntr2_width = 4;  

// input ports
input clk, rst;
input [7:0] weight_ele;
input [15:0] input_patt;
//input we, oe, cntr_rst;

// output ports
output reg complete;
output reg [15:0] input_;

// internal wires
//wire [cntr1_width-1:0] counter1;
//wire [cntr2_width-1:0] counter2;
wire [cntr1_width-1:0] counter1_delayed;	
wire [cntr2_width-1:0] counter2_delayed;
wire [7:0] fdbk_wire;

// changed 
output [cntr1_width-1:0] counter1;
output [cntr2_width-1:0] counter2;

// internal reg
reg en_update_ip; // for updation of input pixel
reg [7:0] weight_reg;
reg adder_rst;
reg rst_;
reg tempwire;
//reg cs; // memory control signals
//reg [7:0] address;


// module instantiation

// counter module
counter c1(counter1, counter1_delayed, counter2, counter2_delayed, clk, rst);

// adder module
add_ mac(fdbk_wire, fdbk_wire, weight_reg, input_[counter1_delayed], clk, adder_rst);

//ram weight_mat(clk , {counter2, counter1} , weight_ele , cs , we , oe); 


always @(posedge clk)
begin

    if(rst == 0)
    begin
    	// reset all the reg to zero or required values
        en_update_ip <= 1'b0;
        complete <= 1'b0;
        weight_reg <= 0;
		input_ <= input_patt;
	end
	else 
	begin
	
		//cs = 1'b1; // chip select ram 
        //we = 1'b0; // to write = 1 and to read = 0
        //oe = 1'b1; // output enable

		// raise a signal to update the pattern
		if(counter1_delayed == 4'hF)
			en_update_ip <= 1'b1;
		if(counter1_delayed == 4'd0)
			en_update_ip <= 1'b0;
			
		// to update the input pattern on calculating the weighted sum 
		// and applying the threshold.
		if (en_update_ip == 1)
        begin
			input_[counter2_delayed] <= tempwire;
		end	
		
		// all pixels have been modified-- raise flag
		// below is the condition for the same 
		if ((counter1 == 0)&&(counter1_delayed == 0)&&(counter2 == 0)&&(counter2_delayed == 4'hF))
		begin
			complete <= 1'b1;
		end
		else 
		begin
			complete <= 1'b0;
		end
			
	end
	
end


always @*
begin
	rst_ <= rst;
	tempwire <= ~fdbk_wire[7];
	adder_rst <= rst_ & (~en_update_ip);
	weight_reg <= weight_ele;	
end

endmodule

/////////////////////////////////////////////////////////////////////////
/////// detect module ends //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////
/////// compare module //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


module compare(cmp_out, modified1, mod_prev, clk, rst);

// input ports	
input rst, clk;
input [15:0]modified1;
input [15:0]mod_prev;

// output ports
output reg cmp_out;


always @(posedge clk)
begin
	
	if (rst == 0)
	begin
		// reset the comparator out to zero initially
		cmp_out <= 0;
	end
	else
	begin

		if (modified1 != mod_prev)
		begin
			// if both are not equal, give 'high'.
			cmp_out <= 1;
		end
		else if (modified1 == mod_prev)
		begin
			// otherwise 'low'.
			cmp_out <= 0;
		end
	
	end

end

endmodule

/////////////////////////////////////////////////////////////////////////
/////// compare module ends /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////
/////// counter module //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

module counter(counter1, counter1_delayed, counter2, counter2_delayed, clk, rst);

// module constants
parameter cntr1_width = 4;
parameter cntr2_width = 4;  
parameter count_upto = 15;

// input ports
input clk, rst;

// output ports
output reg [cntr1_width-1:0] counter1;
output reg [cntr2_width-1:0] counter2;
output reg [cntr1_width-1:0] counter1_delayed;
output reg [cntr1_width-1:0] counter2_delayed;

// internal reg
reg [cntr1_width-1:0] temp1;
reg [cntr1_width-1:0] temp2;
  
always @(posedge clk)
begin
	
	if(rst == 0)
	begin 
		counter1 <= 0;
		counter2 <= 0;
		counter1_delayed <= 0;
		counter2_delayed <= 0;
		temp1 <= 0;
		temp2 <= 0;
	end
	else
	begin
		
		// delay the counter1 by one clock cycle once it completes counting 16.
		if (counter1_delayed == 4'b1111)
		begin
			counter1 <= counter1; 
		end
		else
		begin
			counter1 <= counter1 + 1;
		end
		
		// delay counter1 by one clock cycles
		counter1_delayed <= counter1;
		
		// delay counter2 by 3 clock cycles
		temp1 <= counter2;
		counter2_delayed <= temp1;

	end	

end


always @(negedge counter1[cntr1_width-1])
begin

	counter2 <= counter2 + 1; 

end

endmodule

/////////////////////////////////////////////////////////////////////////
/////// counter module ends /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////
/////// adder module ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


module add_ (op, input1, input2, ctrl, clk, rst);

// input ports
input [7:0] input1;
input [7:0] input2;
input ctrl;
input clk, rst;

// output ports
output reg [7:0] op;

// internal reg
reg [7:0] sum;
reg [7:0] diff;


always @(posedge clk)
begin
	
	if(rst == 0)
	begin
		op <= 0;
	end
	else
	begin
		// based on the control signal, give output sum or the difference
		op <= ctrl ? (sum) : (diff);
	end
	
end


always @*
begin

	if(rst == 0)
	begin
		sum <= 0;
		diff <= 0;
	end
	else
	begin
		sum <= input1 + input2;
		diff <= input1 - input2;
	end
	
end

endmodule

/////////////////////////////////////////////////////////////////////////
/////// adder module ends ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////






