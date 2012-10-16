-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Segmento 3 do pipeline, escolhe qual valor inserir na RAM
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

	component register8 is
		generic (CNT_LATENCY: time := 3 ns);
		port(rel, rst, ld: in  std_logic;
			  D:           in  reg8;
			  Q:           out reg8);
	end component register8;

	signal outMux: reg12;
	signal outCast: reg8;
	
begin
	U_mux: mux2X1
		port map(sum, atual, sel, outMux);

	U_cast: cast8to12
		port map(outMux, outCast);

	U_reg_atual : register8 generic map(3 ns)
							 port map(clk, rst, ld, outCast, result);


end estrutural;
