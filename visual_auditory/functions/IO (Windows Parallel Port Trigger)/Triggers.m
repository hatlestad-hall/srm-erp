function Triggers
config_io; Address = hex2dec('B030');
WaitSecs(0.001); outp(Address, 0); WaitSecs(0.001);
for i = 41:100
	disp(i);
	outp(Address, i);
	WaitSecs(0.001);
	outp(Address, 0);
	WaitSecs(5);
end

end