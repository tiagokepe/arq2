-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Seguimento 0 do pipeline, calcula endereços dos pixels vizinhos e
-- verifica se eh uma borda
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity seg0 is
	port(clk, rst		 			: in  std_logic;
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

	
begin
	U_atual: count10 
		generic map(2 ns)
		port map(clk, rst, '1', '0', X"00"&"00", r_atual);

	-- Comparador que verifica de chegou no final de uma linha
	U_compCcol_TAMCOL: compare10
		port map(countCol, TAM_COL, s_compCol);

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
	

-- process(clk)
--	begin
--		if rising_edge(clk) then
--			
--		end if;
--	end process;
	
	atual <= r_atual;

	U_calc_norte: sub10
		port map(r_atual, TAM_COL, norte, '0', cout(0));


end estrutural;
