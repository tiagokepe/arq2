-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- divisor por 8
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity mux2X1 is
	port(A, B	: in reg12;
		 sel	: in std_logic;
	 	 R		: out reg12);
end mux2X1;

architecture funcional of mux2X1 is
begin
	R <= A when (sel = '0') else
		 B when (sel = '1');
end funcional;
