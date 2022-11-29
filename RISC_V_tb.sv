module RISC_V_tb;
    logic clk,reset;
    logic[31:0] out;
    RISC_V dut(.clk(clk), .reset(reset), .out(out));

    initial
	begin
		clk <= 0;
		forever  begin 
            #5 clk = ~clk;
        end
	end

    initial
    begin
        reset <= 0;
        @(posedge clk);
        reset <= 1;
        repeat (1) @(posedge clk);
        reset <= 0;
        repeat(500)@(posedge clk);
        $stop;
    end

endmodule