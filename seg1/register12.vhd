-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_WIRES.all;

entity register12 is
  generic (CNT_LATENCY: time := 3 ns);
  port(rel, rst, ld: in  std_logic;
        D:           in  reg12;
        Q:           out reg12);
end register12;

architecture funcional of register12 is
  signal value: reg12;
begin

  process(rel, rst, ld)
  begin
    if rst = '0' then
      value <= x"000";
    elsif ld = '0' and rising_edge(rel) then
      value <= D;
    end if;
  end process;

  Q <= value after CNT_LATENCY;
end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
