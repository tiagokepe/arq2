-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- subtrator completo de um bit, modelo funcional
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component div8 is
		port(input  : in  reg12;
			 output : out reg12);
	end component div8;

	signal A : reg12;
	signal B : reg12;
begin
	mapeia: div8 port map(A, B);

	test: process
	begin
		A <= x"008";
		wait for 2 ns;
		A <= x"010";
		wait for 2 ns;
		A <= x"020";
		wait for 2 ns;
		A <= x"040";
		wait for 2 ns;

	end process;

end TB;
