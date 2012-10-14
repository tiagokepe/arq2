--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para count10
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component seg2 is
		port(clk, rst, ld, en 			 		: in  std_logic;
			 norte, sul, leste, anterior, atual : in  reg12;
			 resultSeg2					 		: out reg12
		);
	end component seg2;

	signal s_rel, s_rst, s_ld, s_en: std_logic;
	signal s_norte, s_sul, s_leste, s_anterior, s_atual, result: reg12;
	constant CLOCK : time := 20 ns;

begin
	mapeia: seg2
		port map(s_rel, s_rst, s_ld, s_en, s_norte, s_sul, s_leste, 
				 s_anterior, s_atual, result);

	U_test: process
	begin
		s_norte    <= x"008";
		s_sul      <= x"008";
		s_leste    <= x"008";
		s_anterior <= x"008";
		s_atual    <= x"002";
		wait for CLOCK;

		s_norte    <= x"001";
		s_sul      <= x"002";
		s_leste    <= x"003";
		s_anterior <= x"004";
		s_atual    <= x"004";
		wait for CLOCK;

		s_norte    <= x"009";
		s_sul      <= x"001";
		s_leste    <= x"000";
		s_anterior <= x"007";
		s_atual    <= x"003";
		wait for CLOCK;

		s_norte    <= x"001";
		s_sul      <= x"007";
		s_leste    <= x"005";
		s_anterior <= x"003";
		s_atual    <= x"004";
		wait for CLOCK;

	end process;

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
