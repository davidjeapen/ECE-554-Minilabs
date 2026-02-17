/**
    * Authors: 
        * David Eapen
        * Kailan Kraft
        * Madi Licht     
*/

module to_greyscale(
    input	[10:0]	iX_Cont,
    input	[10:0]	iY_Cont,
    input	[11:0]	iDATA,
    input			iDVAL,
    input			iCLK,
    input			iRST,
    output logic mDVAL,
    output logic [11:0] oDATA
);

logic	[11:0]	pixel_0;
logic	[11:0]	pixel_1;
logic   [11:0]	pixel_2;
logic   [11:0]	pixel_3;

logic   [13:0]  pixel_sum;


Line_Buffer1 	u0	(	.clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						.taps0x(pixel_3),
						.taps1x(pixel_1));

    always_ff @( posedge iCLK, negedge iRST ) begin
        if ( !iRST ) begin
            pixel_0 <= 0;
            pixel_2 <= 0;
        end
        else begin 
            pixel_0 <= pixel_1;
            pixel_2 <= pixel_3;
        end
    end

    always_ff @( posedge iCLK, negedge iRST ) begin
        if ( !iRST ) begin
            mDVAL <= 0;
        end
        else begin
            mDVAL <= {iY_Cont[0]|iX_Cont[0]}	? 1'b0	:	iDVAL;
        end
    end

    always_ff @(posedge iCLK, negedge iRST) begin
        if(!iRST) begin
            pixel_sum <= 14'd0;
        end else begin
            pixel_sum <= (pixel_0 + pixel_1 + pixel_2 + pixel_3);
        end
    end

    assign oDATA = pixel_sum[13:2];
endmodule