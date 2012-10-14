--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para count10
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component seg3 is
		port(clk, rst, ld, en, sel : in  std_logic;
			 sum, atual			   : in  reg12;
			 result 		       : out reg8
		);
	end component seg3;

	signal s_rel, s_rst, s_ld, s_en, s_sel: std_logic;
	signal s_sum, s_atual: reg12;
	signal s_res: reg8;

	constant CLOCK : time := 20 ns;

begin
	mapeia: seg3
		port map(s_rel, s_rst, s_ld, s_en, s_sel, s_sum, s_atual, s_res); 

	U_test: process
	begin
		s_sel <= '0';
		s_sum <= x"008";
		s_atual <= x"001";
		wait for CLOCK;

		s_sel <= '1';
		s_sum <= x"008";
		s_atual <= x"001";
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
