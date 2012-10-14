-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- subtrator completo de um bit, modelo funcional
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component ext8to12 is
		port(input  : in  reg8;
			 output : out reg12);
	end component ext8to12;

	signal A : reg8;
	signal B : reg12;
begin
	mapeia: ext8to12 port map(A, B);

	test: process
	begin
		A <= x"01";
		wait for 2 ns;
		A <= x"00";
		wait for 2 ns;
		A <= x"FF";
		wait for 2 ns;
		A <= x"AA";
		wait for 2 ns;

	end process;

end TB;
