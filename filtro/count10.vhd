-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_WIRES.all;
entity count10 is
  generic (CNT_LATENCY: time := 2 ns);
  port(rel, rst, ld, en: in  std_logic;
        D:               in  reg10;
        Q:               out reg10);
end count10;

architecture funcional of count10 is
  signal count: reg10;
begin

  process(rel, rst, ld)
  begin
    if rst = '0' then
      count <= "0000000000";
    elsif ld = '0' and rising_edge(rel) then
      count <= D;
    elsif en = '0' and rising_edge(rel) then
      count <= count + "0000000001";
    end if;
  end process;

  Q <= count after CNT_LATENCY;
end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
