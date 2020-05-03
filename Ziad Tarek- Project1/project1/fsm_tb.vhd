Library IEEE;
use IEEE.all;
USE ieee.std_logic_1164.ALL;

Entity fsmTb is
End Entity fsmTb;

Architecture archiTb of fsmTb is
Component fsm is
port  (
	ck    : in	bit;
	vdd   : in	bit;
	vss   : in	bit;
	inp   : in	bit;
	reset : in	bit;
	op    : out	bit;
	tr    : out	bit
      );
end Component fsm;

For dut: fsm use entity work.fsm(archi);


SIGNAL clock : bit := '0';
SIGNAL VDD   : bit := '1';
SIGNAL VSS   : bit := '0';
SIGNAL input : bit := '0';
SIGNAL rst : bit := '1';
SIGNAL output  : bit := '0';
SIGNAL termination  : bit := '0';


constant clk_period : time := 20 ns;
constant sequence1 : bit_vector := "11011010010";
constant sequence2 : bit_vector := "00101010010";
SIGNAL string_Recognized : bit_vector (2 downto 0);


Begin
	dut : fsm PORT MAP ( clock, VDD, VSS, input, rst, output, termination);
	

	clk_Process: process
	begin
		clock <= '1';
		wait for clk_period/2;	
		clock <= '0';
		wait for clk_period/2;
 	end process;

	stim_proc: PROCESS IS
	BEGIN
	rst <= '1';
	wait for clk_period;
	rst <= '0';
	
	string_Recognized <= "000";
	for i in 0 to sequence2'length-1 loop
		wait for clk_period;
		if(rst <= '0') then
			string_Recognized <= string_Recognized(1) & string_Recognized(2) & input;	
		else string_Recognized <= "000";
		end if;
	input <= sequence2(i);		
	end loop;
	string_Recognized <= string_Recognized(1) & string_Recognized(2) & input;
	

	if(rst = '1') then
		wait for clk_period;
		Assert output = '0' and termination = '0' 
		Report "output=0 & termination=0"
 		Severity error;	
	
	elsif(termination = '0' and rst = '0') then
		if    (string_Recognized = "010") then
			wait for clk_period;
			Assert output = '1' and termination = '0' 
			Report "output=1 & termination=0"
 			Severity error;	
		elsif (string_Recognized = "100") then
			wait for clk_period;
			Assert output = '0' and termination = '1' 
			Report "output=0 & termination=1"
 			Severity error;	
		else    wait for clk_period;
			Assert output = '0' and termination = '0' 
			Report "output=0 & termination=0"
 			Severity error;	
		end if;
	

	elsif (termination = '1' and rst = '0') then
			wait for clk_period;
			Assert output = '0' and termination = '1' 
			Report "output=0 & termination=1"
 			Severity error;	
		
	end if;

WAIT; -- stop process simulation run
END PROCESS;
END ARCHITECTURE archiTb;