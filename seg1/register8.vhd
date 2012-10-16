-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_WIRES.all;

entity register8 is
  generic (CNT_LATENCY: time := 3 ns);
  port(rel, rst, ld: in  std_logic;
        D:           in  reg8;
        Q:           out reg8);
end register8;

architecture funcional of register8 is
  signal value: reg8;
begin

  process(rel, rst, ld)
  begin
    if rst = '0' then
      value <= x"00";
    elsif ld = '0' and rising_edge(rel) then
      value <= D;
    end if;
  end process;

  Q <= value after CNT_LATENCY;
end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
