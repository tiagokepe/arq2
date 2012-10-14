-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- divisor por 8
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity div8 is
	port(input  : in  reg12;
	 	 output : out reg12);
end div8;

architecture div8 of div8 is
begin
	output <= "000" & input(11 downto 3);

end div8;

