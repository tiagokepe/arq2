-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Seguimento 2 do pipeline, faz a soma = note + sul + leste + anterior
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity seg2 is
	port(clk, rst, ld, en 			 		: in  std_logic;
		 norte, sul, leste, anterior, atual : in  reg12;
		 resultSeg2					 		: out reg12
	);
end seg2;

architecture estrutural of seg2 is
	component add12 is
		port(inpA, inpB : in reg12; --entradas A,B,
             outC : out reg12; -- saída outC
		     vem : in std_logic; -- vem-um
		     vai : out std_logic);  -- saída vai-um
	end component add12;

	component div8 is
		port(input  : in  reg12;
		 	 output : out reg12);
	end component div8;

	component div2 is
		port(input  : in  reg12;
		 	 output : out reg12);
	end component div2;

	signal cout : reg3;
	signal outDiv8, outDiv2: reg12;
	signal sumNS, sumLO, sumNSLO, sumAll: reg12;
	
begin
	U_sumNS: add12 
		port map(norte, sul, sumNS, '0', cout(0));

	U_sumLO: add12 
		port map(leste, anterior, sumLO, '0', cout(0));

	U_sumNSLO: add12 
		port map(sumNS, sumLO, sumNSLO, '0', cout(0));

	U_div8: div8
		port map(sumNSLO, outDiv8);

	U_div2: div2
		port map(atual, outDiv2);

	U_result: add12
		port map(outDiv8, outDiv2, resultSeg2, '0', cout(0));

end estrutural;
