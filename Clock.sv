module Clock(
	input bit clk,
	output byte current_hour, current_minute, current_second
);

	const integer div = 50000000;
	integer cnt;
	byte hour, minute, second;
	
	initial begin
		cnt <= 0;
		hour <= 8'd0;
		minute <= 8'd0;
		second <= 8'd0;
	end
	
	always_ff @(posedge clk) begin
		if (cnt != div)
			cnt <= cnt + 1;
		else begin
			cnt = 0;
			if (second == 8'd59) begin
				second <= 8'd0;
				if (minute == 8'd59) begin
					minute <= 8'd0;
					if (hour == 8'd23)
						hour <= 8'd0;
					else
						hour <= hour + 8'd1;
				end
				else
					minute <= minute + 8'd1;
			end
			else
				second <= second + 8'd1;
		end
	end
	
	assign current_hour = hour;
	assign current_minute = minute;
	assign current_second = second;
	
endmodule 