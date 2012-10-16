-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, ci312,ci702 2012-1 trabalho semestral, autor: Roberto Hexsel, 26set
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- definicao do modulo filtro
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
use work.p_WIRES.all;
use work.p_MATRIZ.all;
entity filtro is
  generic (CIRC_LATENCY: time := 20 ns);
  port(rel,rst,ld,en: in std_logic;
       --outros sinais
       lin,col: in integer);             -- dimensoes das matrizes
end filtro;

architecture estrutural of filtro is
begin
  --comandos e processos
end estrutural;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Seguimento 0 do pipeline, calcula endereços dos pixels vizinhos e
-- verifica se eh uma borda
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity seg0 is
	port(clk, rst, ld, en 			: in  std_logic;
		 TAM_COL, TAM_LIN			: in  reg10;
		 norte, sul, leste, atual	: out reg10;
		 border 					: out std_logic
	);
end seg0;

architecture estrutural of seg0 is
	component add10 is
		port(inpA, inpB : in reg10; --entradas A,B,
             outC : out reg10; -- saída outC
		     vem : in std_logic; -- vem-um
		     vai : out std_logic);  -- saída vai-um
	end component add10;

	component sub10 is
		port(inpA, inpB: in reg10;
			 outC: out reg10;
		     vem : in std_logic; -- vem-um
		     vai : out std_logic);  -- saída vai-um
	end component sub10;

	component count10 is
		generic (CNT_LATENCY: time := 2 ns);
		port(rel, rst, ld, en : in  std_logic;
			 D				  : in  reg10;
			 Q				  : out reg10);
	end component count10;

	component compare10 is
		port(A, B : in reg10;  -- entradas A,Bestrutural em 
  		     S    : out std_logic);  -- saída S 
	end component compare10;

	component register10 is
		generic (CNT_LATENCY: time := 3 ns);
		port(rel, rst, ld : in  std_logic;
			 D			  : in  reg10;
			 Q			  : out reg10);
	end component register10;

	component isBorder is
		port(ccol, clin, COL, LIN : in reg10;
  			 border				  : out std_logic
		);
	end component isBorder;

	signal cout : reg3;
	signal countCol, countLin : reg10;
	signal r_atual : reg10;
	signal r_isBorder : std_logic;
	signal s_compCol: std_logic;
	signal s_ld: std_logic;
	signal s_en_lin: std_logic;
	signal s_tam_col: reg10;
	signal s_tam_lin: reg10;

	constant UM : reg10 := x"00"&"01";

	
begin
	U_atual: count10 
		generic map(2 ns)
		port map(clk, rst, ld, en, X"00"&"00", r_atual);

	atual <= r_atual;

	U_calc_norte: sub10
		port map(r_atual, TAM_COL, norte, '0', cout(0));

	U_calc_sul: add10
		port map(r_atual, TAM_COL, sul, '0', cout(0));

	U_calc_leste: add10
		port map(r_atual, X"00"&"01", leste, '0', cout(0));

	-- Subtrai 1 de TAM_COL para acertar a entrada do isBorder
	U_sub_tam_col: sub10
		port map(TAM_COL, UM, s_tam_col, '0', cout(0));


	-- Comparador que verifica de chegou no final de uma linha
	U_compCcol_TAMCOL: compare10
		port map(countCol, s_tam_col, s_compCol);

	s_ld <= not s_compCol; -- sinal de load do countCol

	U_countCol: count10
		generic map(2 ns)
		port map(clk, rst, s_ld, s_compCol, X"00"&"00", countCol);

	s_en_lin <= not s_compCol; -- sinal que habilita o contador de linha

	U_countLin: count10
		generic map(2 ns)
		port map(clk, rst, '1', s_en_lin, X"00"&"00", countLin);

	U_isBorder: isBorder
		port map(countCol, countLin, TAM_COL, TAM_LIN, border);
	
end estrutural;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Seguimento armazena valores do NORTE, SUL, LESTE e ATUAL em registradores
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity seg1 is
    port(clk, rst, ld : in  std_logic;
         v_norte      : in  reg8;
         v_sul        : in  reg8;
         v_leste      : in  reg8;
         v_atual      : in  reg8;
         reg_norte12  : out reg12;
         reg_sul12    : out reg12;
         reg_leste12  : out reg12;
         reg_atual12  : out reg12);
end seg1;

architecture estrutural of seg1 is
    component ext8to12 is
		port(input  : in  reg8;
			 output : out reg12);
    end component ext8to12;

	component register12 is
		generic (CNT_LATENCY:time);
		port(rel, rst, ld: in  std_logic;
			 D:           in  reg12;
			 Q:           out reg12);
	end component register12;

	signal aux_norte, out_norte : reg12;
	signal aux_sul, out_sul : reg12;
	signal aux_leste, out_leste : reg12;
	signal aux_atual, out_atual : reg12;

begin

	U_ext_norte	: ext8to12 port map(v_norte, aux_norte);
	U_ext_sul	: ext8to12 port map(v_sul, 	 aux_sul);
	U_ext_leste	: ext8to12 port map(v_leste, aux_leste);
	U_ext_atual	: ext8to12 port map(v_atual, aux_atual);

	U_reg_norte : register12 generic map(3 ns)
  		   					 port map(clk, rst, ld, aux_norte, reg_norte12);

	U_reg_sul : register12 generic map(3 ns) 
						   port map(clk, rst, ld, aux_sul, reg_sul12);

	U_reg_leste : register12 generic map(3 ns)
							 port map(clk, rst, ld, aux_leste, reg_leste12);

	U_reg_atual : register12 generic map(3 ns)
							 port map(clk, rst, ld, aux_atual, reg_atual12);

end estrutural;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Segmento 2 do pipeline, faz a soma = note + sul + leste + anterior
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

	component register12 is
		generic (CNT_LATENCY:time);
		port(rel, rst, ld: in  std_logic;
			 D:           in  reg12;
			 Q:           out reg12);
	end component register12;

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
		port map(outDiv8, outDiv2, sumAll, '0', cout(0));

	U_reg_leste : register12 generic map(3 ns)
							 port map(clk, rst, ld, sumAll, resultSeg2);


end estrutural;


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
