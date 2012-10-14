-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador completo de um bit, modelo estrutural
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity ext8to12 is
	port(input  : in  reg8;
		 output : out reg12);
end ext8to12;

architecture ext12 of ext8to12 is
begin
	output <= x"0" & input;
end ext12;
