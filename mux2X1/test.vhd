-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- subtrator completo de um bit, modelo funcional
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component mux2X1 is
		port(A, B	: in reg12;
			 sel	: in std_logic;
		 	 R		: out reg12);
	end component mux2X1;

	signal inpA, inpB, outR: reg12;
	signal s : std_logic;
begin
	mapeia: mux2X1 port map(inpA, inpB, s, outR);

	test: process
	begin
		s <= '0';
		inpA <= x"FFF";
		inpB <= x"008";
		wait for 2 ns;

		s <= '1';
		inpA <= x"FFF";
		inpB <= x"008";
		wait for 2 ns;

	end process;

end TB;
