--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para count10
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component count10 is
		  port(rel, rst, ld, en: in  std_logic;
				D:               in  reg10;
				Q:               out reg10);
	end component count10;

	signal t_rel, t_rst, t_ld, t_en: std_logic;
	signal inp, outp: reg10;
	constant CLOCK : time := 2 ns;
begin
	mapeia: count10 port map(
		rel => t_rel,
		rst => t_rst,
		ld 	=> t_ld,
		en 	=> t_en,
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
    wait for CLOCK * 0.75;  -- espera por 40ns
    t_rst <= '1';      -- volta a executar e
    wait;            -- espera para sempre
  end process;

  U_en: process
  begin
	for i in 0 to 4 loop
		t_ld <= '1';
		t_en <= '0';      -- executa e
		wait for CLOCK;  -- espera 2 ciclo
		t_en <= '1';      -- volta a executar e
		wait for CLOCK;  -- espera meio ciclo e volta ao topo
	end loop;
	inp <= "0000001111";
	t_ld <= '0';
	wait for CLOCK;
  end process;

end TB;
