-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, ci312,ci702 2012-1 trabalho semestral, autor: Roberto Hexsel, 28set
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
library std;  use std.textio.all;
use work.p_wires.all;
package p_MATRIZ is
 
  constant MAT_LIN : integer := 4;        -- linha da matriz
  constant MAT_COL : integer := 4;        -- coluna da matriz

  constant MEM_SZ : integer := (MAT_LIN * MAT_COL);
  type memoria is array (0 to MEM_SZ) of std_logic_vector(7 downto 0);

  subtype addressMem is std_logic_vector(log2_ceil(MEM_SZ) downto 0);
   
end p_MATRIZ;

-- package body p_MATRIZ is
-- end p_MATRIZ;

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
