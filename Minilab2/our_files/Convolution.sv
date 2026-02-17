/**
    * Authors: 
        * David Eapen
        * Kailan Kraft
        * Madi Licht     
*/

module Convolution #(
	parameter logic signed [0:26] filter = { {-3'sd1, 3'sd0, 3'sd1},
	                                       	 {-3'sd2, 3'sd0, 3'sd2},
	                                       	 {-3'sd1, 3'sd0, 3'sd1} }

)(	

	input iCLK,
	input iRST,
	input [11:0] iDATA,
	input iDVAL,
	output logic oDVAL,
	output logic [11:0] oData
);


	logic [11:0] data [0:1][0:2];
	logic [11:0] data_in [0:2];
	logic signed [17:0] conv_rslt;


	LineBuffer3 iLB3 ( .clken(iDVAL),
					   .clock(iCLK),
					   .shiftin(iDATA),
					   .taps0x(data_in[2]),
					   .taps1x(data_in[1]),
					   .taps2x(data_in[0]));


	always_ff @(posedge iCLK or negedge iRST) begin
		if (!iRST) begin
			data <= '{ default: 12'h000 };
		end else begin
			data[1] <= data_in;
			data[0] <= data[1];
		end
	end

	always_ff @(posedge iCLK or negedge iRST) begin
		if (!iRST) begin
			oDVAL <= 1'b0;
		end else begin
			oDVAL <= iDVAL;
		end
	end

	always_comb begin
		conv_rslt = $signed(filter[0:2]) * $signed(data[0][0]) + 
				    $signed(filter[3:5]) * $signed(data[1][0]) +
		        	$signed(filter[6:8]) * $signed(data_in[0]) +
		        	$signed(filter[9:11]) * $signed(data[0][1]) +
		        	$signed(filter[12:14]) * $signed(data[1][1]) +
		        	$signed(filter[15:17]) * $signed(data_in[1]) +
		        	$signed(filter[18:20]) * $signed(data[0][2]) +
		       		$signed(filter[21:23]) * $signed(data[1][2]) +
		        	$signed(filter[24:26]) * $signed(data_in[2]);

		oData = (conv_rslt[17]) ? -conv_rslt : conv_rslt;
	end

endmodule