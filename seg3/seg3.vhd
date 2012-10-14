-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Seguimento 2 do pipeline, faz a soma = note + sul + leste + anterior
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity seg3 is
	port(clk, rst, ld, en, sel : in  std_logic;
		 sum, atual			   : in  reg12;
		 result 		       : out reg8
	);
end seg3;

architecture estrutural of seg3 is
	component mux2X1 is
		port(A, B	: in reg12;
			 sel	: in std_logic;
		 	 R		: out reg12);
	end component mux2X1;

	component cast8to12 is
		port(input  : in  reg12;
			 output : out reg8);
	end component cast8to12;

	signal outMux: reg12;
	
begin
	U_mux: mux2X1
		port map(sum, atual, sel, outMux);

	U_cast: cast8to12
		port map(outMux, result);


end estrutural;
