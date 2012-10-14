-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Seguimento soma vizinho norte com anterior já armazenado
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity seg1 is
    port(clk, rst    : in  std_logic;
         v_norte     : in  reg8;
         v_anterior  : in  reg12;
         result_seg1 : out reg12);
end seg1;

architecture estrutural of seg1 is
    component ext8to12 is
		port(input  : in  reg8;
			 output : out reg12);
    end component ext8to12;

	component add12 is
		port(inpA, inpB : in reg12; --entradas A,B,
	 		 outC : out reg12; -- saída outC
			 vem : in std_logic; -- vem-um
			 vai : out std_logic);  -- saída vai-um
	end component add12;

	signal norte12 : reg12;
	signal cout    : std_logic;
begin

	U_ext: ext8to12 port map(v_norte, norte12);
	U_add: add12 port map(norte12, v_anterior, result_seg1, '0', cout);
	
end estrutural;
