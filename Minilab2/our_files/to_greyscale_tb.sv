/**
    * Authors: 
        * David Eapen
        * Kailan Kraft
        * Madi Licht     
*/
`timescale 1 ps / 1 ps
module to_greyscale_tb();

    // to_greyscale values
    logic [10:0] iX_Cont;
    logic [10:0] iY_Cont;
    logic [11:0] iDATA;
    logic		 iDVAL;
    logic		 clk;
    logic		 rst_n;
    logic        mDVAL;
    logic [11:0] oDATA;
    logic [11:0] data [0:1][0:1];
    logic [11:0] data_in;
    logic signed [14:0] exp_output;

    // testbench values
    logic [11:0] data_num;
    logic [10:0] x_count;
    logic [10:0] y_count;

    to_greyscale greyscale_inst(.iX_Cont(iX_Cont), .iY_Cont(iY_Cont), .iDATA(data_in), .iDVAL(iDVAL), .iCLK(clk), .iRST(rst_n),
                                .mDVAL(mDVAL), .oDATA(oDATA));

    initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		data_in = 12'h000;
		iDVAL = 1'b0;

        iX_Cont = 11'h000;
        iY_Cont = 11'h000;

		exp_output = 12'h000;
		data = '{ {12'h001, 12'h002},
				  {12'h003, 12'h004}};


		@(negedge clk);
		rst_n = 1'b1;
		iDVAL = 1'b1;

		for (int i = 0; i < 2; i++) begin
			for (int j = 0; j < 2; j++) begin
				data_in = data[i][j];
				exp_output = exp_output + data[i][j];
				@(negedge clk);
			end
			data_in = 12'h000;
			repeat(1278) @(negedge clk);
		end


		repeat(2) @(negedge clk);
        exp_output = exp_output >> 2; // divide by 4

		if (oDATA !== exp_output) begin
			$display("Output is incorrect!!");
			$display("Expected: %h", exp_output);
			$display("Actual: %h", oDATA);
			$stop();
		end

		$display("YAHOO!! Tests passed!");
		$stop();
	end


    always 
        #5 clk = ~clk;

endmodule