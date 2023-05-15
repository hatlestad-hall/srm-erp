function em_send_clear ( addr, value, wait )

outp ( addr, value );
if wait, WaitSecs ( 0.001 ); end
outp ( addr, 0 );

end