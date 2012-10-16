-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador completo de um bit, modelo estrutural
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity cast8to12 is
	port(input  : in  reg12;
		 output : out reg8);
end cast8to12;

architecture cast8to12 of cast8to12 is
begin
	output <= input(7 downto 0);
end cast8to12;
