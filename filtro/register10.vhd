-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_WIRES.all;

entity register10 is
  generic (CNT_LATENCY: time := 3 ns);
  port(rel, rst, ld: in  std_logic;
        D:           in  reg10;
        Q:           out reg10);
end register10;

architecture funcional of register10 is
  signal value: reg10;
begin

  process(rel, rst, ld)
  begin
    if rst = '0' then
      value <= "0000000000";
    elsif ld = '0' and rising_edge(rel) then
      value <= D;
    end if;
  end process;

  Q <= value after CNT_LATENCY;
end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
