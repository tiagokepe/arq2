--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para count10
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component seg0 is
		port(clk, rst		 			: in std_logic;
			 TAM_COL, TAM_LIN			: in reg10;
			 norte, sul, leste, atual	: out reg10;
			 border 					: out std_logic
		);
	end component seg0;

	signal s_rel, s_rst, s_border: std_logic;
	signal s_norte, s_sul, s_leste, s_atual: reg10;
	constant CLOCK : time := 10 ns;
	constant s_COL, s_LIN : reg10 := x"00"&"11";

begin
	mapeia: seg0
		port map(s_rel, s_rst, s_COL, s_LIN, s_norte, s_sul, s_leste, s_atual,
				 s_border);

--	U_test: process
		
--		wait for CLOCK;
--	end process;


	U_clock: process
	begin
		s_rel <= '0';      -- executa e
		wait for CLOCK / 2;  -- espera meio ciclo
		s_rel <= '1';      -- volta a executar e
		wait for CLOCK / 2;  -- espera meio ciclo e volta ao topo
	end process;

	U_reset: process
	begin
		s_rst <= '0';      -- executa e
		wait for CLOCK * 0.75;  -- espera por 40ns
		s_rst <= '1';      -- volta a executar e
		wait;            -- espera para sempre
	end process;

end TB;
