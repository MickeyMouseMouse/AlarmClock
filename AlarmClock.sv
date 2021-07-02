// Device: EP4CE10F17C8
module AlarmClock (
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "E1" *)
		input bit clk,
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "M1" *)
		input bit alarm_on_off,
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "E16" *)
		input bit clock_alarm_switcher,
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "E15" *)
		input bit alarm_hour_plus,
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "M2" *)
		input bit alarm_minute_plus,
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "M16" *)
		input bit alarm_second_plus,
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "T15, R16, P15, P16, N15, N16" *)
		output bit [5:0] seven_segment_indicators,
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "D9, P11, N11, M10, N13, C9, N12, M11" *)
		output byte digit,
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "D11" *)
		output bit alarm_activate_status,
	(* altera_attribute = "-name IO_STANDARD \"3.3-V LVCMOS\"", chip_pin = "D12" *)
		output bit alarm_siren
);

	byte current_hour, current_minute, current_second, alarm_hour, alarm_minute, alarm_second;
	bit mode; // 0 = clock; 1 = alarm settings

	initial begin
		mode = 1'b0;
	end
	
	always_ff @(posedge clock_alarm_switcher) begin
		mode = ~mode;
	end
	
	Clock clock_int (
		.clk(clk),
		.current_hour(current_hour),
		.current_minute(current_minute),
		.current_second(current_second)
	);
	
	AlarmSettings alarmSettings_inst (
		.clk(clk),
		.mode(mode),
		.alarm_hour_plus(alarm_hour_plus),
		.alarm_minute_plus(alarm_minute_plus),
		.alarm_second_plus(alarm_second_plus),
		.alarm_hour(alarm_hour),
		.alarm_minute(alarm_minute),
		.alarm_second(alarm_second)
	);
	
	Indication indication_inst (
		.clk(clk),
		.mode(mode),
		.current_hour(current_hour),
		.current_minute(current_minute),
		.current_second(current_second),
		.alarm_hour(alarm_hour),
		.alarm_minute(alarm_minute),
		.alarm_second(alarm_second),
		.seven_segment_indicators(seven_segment_indicators),
		.digit(digit)
	);
	
	Siren siren_inst (
		.clk(clk),
		.alarm_on_off(alarm_on_off),
		.current_hour(current_hour),
		.current_minute(current_minute),
		.current_second(current_second),
		.alarm_hour(alarm_hour),
		.alarm_minute(alarm_minute),
		.alarm_second(alarm_second),
		.alarm_activate_status(alarm_activate_status),
		.alarm_siren(alarm_siren)
	);

endmodule 