--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para count10
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component register10 is generic(CNT_LATENCY: time);
		  port(rel, rst, ld: in  std_logic;
				D:               in  reg10;
				Q:               out reg10);
	end component register10;

	signal t_rel, t_rst, t_ld: std_logic;
	signal inp, outp: reg10;
	constant CLOCK : time := 2 ns;
begin
	mapeia: register10 generic map (3 ns)
		port map(
			rel => t_rel,
			rst => t_rst,
			ld 	=> t_ld,
			D	=> inp,
			Q	=> outp
		);

  U_clock: process
  begin
    t_rel <= '0';      -- executa e
    wait for CLOCK / 2;  -- espera meio ciclo
    t_rel <= '1';      -- volta a executar e
    wait for CLOCK / 2;  -- espera meio ciclo e volta ao topo
  end process;

  U_reset: process
  begin
    t_rst <= '0';      -- executa e
    wait for CLOCK * 2;  -- espera por 40ns
    t_rst <= '1';      -- volta a executar e
    wait;            -- espera para sempre
  end process;

  U_en: process
  begin
	wait for 4 ns; 
	t_ld <= '0';
	inp <= "0000001111";
	wait for 8 ns; 
	t_ld <= '0';
	inp <= "0100000000";
	wait for 8 ns; 
	t_ld <= '0';
	inp <= "0000000001";
	wait for 8 ns; 
  end process;

end TB;
