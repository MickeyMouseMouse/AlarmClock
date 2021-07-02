module Siren(
	input bit clk, alarm_on_off,
	input byte current_hour, current_minute, current_second,
		alarm_hour, alarm_minute, alarm_second,
	output bit alarm_activate_status, alarm_siren
);

	const integer div = 9000000;
	integer cnt;

	bit status, siren;
	
	initial begin
		status = 1'd0;
		siren = 1'd0;
	end
	
	always_ff @(posedge clk) begin
		if (cnt != div)
			cnt <= cnt + 1;
		else begin
			cnt = 0;
			if (!alarm_on_off)
				if (siren == 1'd1) begin
					siren = 1'd0;
					status = 1'd0;
				end
				else
					status = ~status;
			else
				if (status == 1'd1 &&
						current_hour == alarm_hour &&
							current_minute == alarm_minute && 
								current_second == alarm_second) siren = 1'd1;
		end
	end
	
	assign alarm_activate_status = status;
	assign alarm_siren = siren;

endmodule 