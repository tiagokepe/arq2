--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para count10
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component isBorder is
		port(ccol, clin, COL, LIN: in reg10;
			border				 : out std_logic
		);
	end component isBorder;
	
	constant col: reg10 := "1111111111";
	constant lin: reg10 := "1111111111";
	signal s_col, s_lin: reg10;
	signal result: std_logic;
begin
	mapeia: isBorder port map(s_col, s_lin, col, lin, result);

	test: process
	begin
		s_col <= "0000000000";
		s_lin <= "0000000000";
		wait for 10 ns;
		s_col <= "0000000000";
		s_lin <= "0000000000";
		wait for 10 ns;
		s_col <= "1111111111";
		s_lin <= "0000000001";
		wait for 10 ns;
		s_col <= "0000000100";
		s_lin <= "0000000111";
		wait for 10 ns;

	end process;

end TB;
