-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- divisor por 8
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity div2 is
	port(input  : in  reg12;
	 	 output : out reg12);
end div2;

architecture div2 of div2 is
begin
	output <= "0" & input(11 downto 1);
end div2;
