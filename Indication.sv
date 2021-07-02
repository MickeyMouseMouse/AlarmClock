module Indication(
	input bit clk, mode,
	input byte current_hour, current_minute, current_second, alarm_hour, alarm_minute, alarm_second,
	output bit [5:0] seven_segment_indicators,
	output byte digit
);

	const integer div = 10000;
	integer cnt;
	
	bit [5:0] current_indicator;
	byte current_digit;

	initial begin
		cnt = 0;
	end
	
	function byte get_seven_segment_digit;
		input byte digit;
		input bit dot;
		case (digit)
			8'd0: get_seven_segment_digit = {dot, 7'b1000000};
			8'd1: get_seven_segment_digit = {dot, 7'b1111001};
			8'd2: get_seven_segment_digit = {dot, 7'b0100100};
			8'd3: get_seven_segment_digit = {dot, 7'b0110000};
			8'd4: get_seven_segment_digit = {dot, 7'b0011001};
			8'd5: get_seven_segment_digit = {dot, 7'b0010010};
			8'd6: get_seven_segment_digit = {dot, 7'b0000010};
			8'd7: get_seven_segment_digit = {dot, 7'b1111000};
			8'd8: get_seven_segment_digit = {dot, 7'b0000000};
			default: get_seven_segment_digit = {dot, 7'b0010000};
		endcase
	endfunction
			
	always_ff @(posedge clk) begin
		if (cnt != div)
			cnt <= cnt + 1;
		else begin
			cnt = 0;
			case (current_indicator)
				6'b111110: begin
					current_indicator <= 6'b111101;
					if (mode == 1'b0) // clock mode
						current_digit = get_seven_segment_digit(current_second / 10, 1'b1);
					else
						current_digit = get_seven_segment_digit(alarm_second / 10, 1'b1);
				end
				6'b111101: begin
					current_indicator <= 6'b111011;
					if (mode == 1'b0) // clock mode
						current_digit = get_seven_segment_digit(current_minute % 10, 1'b0);
					else
						current_digit = get_seven_segment_digit(alarm_minute % 10, 1'b0);
				end
				6'b111011: begin
					current_indicator <= 6'b110111;
					if (mode == 1'b0) // clock mode
						current_digit = get_seven_segment_digit(current_minute / 10, 1'b1);
					else
						current_digit = get_seven_segment_digit(alarm_minute / 10, 1'b1);
				end
				6'b110111: begin
					current_indicator <= 6'b101111;
					if (mode == 1'b0) // clock mode
						current_digit = get_seven_segment_digit(current_hour % 10, 1'b0);
					else
						current_digit = get_seven_segment_digit(alarm_hour % 10, 1'b0);
				end
				6'b101111: begin
					current_indicator <= 6'b011111;
					if (mode == 1'b0) // clock mode
						current_digit = get_seven_segment_digit(current_hour / 10, 1'b1);
					else
						current_digit = get_seven_segment_digit(alarm_hour / 10, 1'b1);
				end
				6'b011111: begin
					current_indicator <= 6'b111110;
					if (mode == 1'b0) // clock mode
						current_digit = get_seven_segment_digit(current_second % 10, 1'b1);
					else
						current_digit = get_seven_segment_digit(alarm_second % 10, 1'b1);
				end
			endcase
		end
	end
	
	assign seven_segment_indicators = current_indicator;
	assign digit = current_digit;

endmodule 