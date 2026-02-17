/**
    * Authors: 
        * David Eapen
        * Kailan Kraft
        * Madi Licht     
*/

`timescale 1 ps / 1 ps
module Convolution_tb();

	logic clk, rst_n;
	logic [11:0] data [0:2][0:2];
	logic [11:0] data_in;
	logic valid;
	logic [11:0] data_out;
	logic signed [17:0] exp_output;
	logic signed [2:0] filter [0:2][0:2];

	Convolution iCONV(.iCLK(clk), .iRST(rst_n), .iDATA(data_in), .iDVAL(valid), .oData(data_out));

	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		data_in = 12'h000;
		valid = 1'b0;

		exp_output = 12'h000;
		data = '{ {12'h001, 12'h002, 12'h003},
				  {12'h004, 12'h005, 12'h006},
				  {12'h007, 12'h008, 12'h009} };
		filter = '{ {-3'sd1, 3'sd0, 3'sd1},
	                {-3'sd2, 3'sd0, 3'sd2},
	                {-3'sd1, 3'sd0, 3'sd1} };

		@(negedge clk);
		rst_n = 1'b1;
		valid = 1'b1;

		for (int i = 0; i < 3; i++) begin
			for (int j = 0; j < 3; j++) begin
				data_in = data[i][j];
				exp_output = exp_output + ( $signed(data[i][j]) * $signed(filter[i][j]) );
				@(negedge clk);
			end
			data_in = 12'h000;
			repeat(1277) @(negedge clk);
		end

		repeat(2) @(negedge clk);
		if (exp_output[17] == 1) begin
			exp_output = -exp_output;
		end

		if (data_out !== exp_output) begin
			$display("Output is incorrect!!");
			$display("Expected: %h", exp_output);
			$display("Actual: %h", data_out);
			$stop();
		end

		$display("YAHOO!! Tests passed!");
		$stop();
	end

	always
		#5 clk = ~clk;

endmodule