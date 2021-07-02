module AlarmSettings(
	input bit clk, mode, alarm_hour_plus, alarm_minute_plus, alarm_second_plus,
	output byte alarm_hour, alarm_minute, alarm_second
);
	
	const integer div = 9000000;
	integer cnt;
	
	byte hour, minute, second;
	
	initial begin
		hour <= 8'd0;
		minute <= 8'd0;
		second <= 8'd0;
	end
	
	always_ff @(posedge clk) begin
		if (cnt != div)
			cnt <= cnt + 1;
		else begin
			cnt = 0;
			if (mode == 1'd1) begin // alarm mode
				if (!alarm_hour_plus)
					if (hour == 8'd23)
						hour <= 8'd0;
					else
						hour <= hour + 8'd1;
				if (!alarm_minute_plus)
					if (minute == 8'd59)
						minute <= 8'd0;
					else
						minute <= minute + 8'd1;
				if (!alarm_second_plus)
					if (second == 8'd59)
						second <= 8'd0;
					else
						second <= second + 8'd1;
			end
		end
	end

	assign alarm_hour = hour;
	assign alarm_minute = minute;
	assign alarm_second = second;
	
endmodule 