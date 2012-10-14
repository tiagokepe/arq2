-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- subtrator completo de um bit, modelo funcional
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component cast8to12 is
		port(input  : in  reg12;
			 output : out reg8);
	end component cast8to12;

	signal A : reg12;
	signal B : reg8;
begin
	mapeia: cast8to12 port map(A, B);

	test: process
	begin
		A <= x"001";
		wait for 2 ns;
		A <= x"000";
		wait for 2 ns;
		A <= x"0FF";
		wait for 2 ns;
		A <= x"0AA";
		wait for 2 ns;

	end process;

end TB;
