--------------------------------------------------------------------------
-- Modulo que implementa um modelo comportamental de uma RAM Assincrona
--------------------------------------------------------------------------
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_wires.all;
use work.p_matriz.all;

entity RAM is
  generic (MEM_LATENCY: time := 10 ns);
  port (sel     : in    std_logic;
        wr      : in    std_logic;
        address : in    address;          -- depende do tamanho da matriz
        data    : inout reg8);
end entity RAM;

architecture behavioral of RAM is
  subtype word is std_logic_vector(0 to data'length - 1);
  type storage_array is
    array (natural range 0 to 2**address'length - 1) of word;
  signal storage : storage_array;
begin  -- behavioral

  writeRAM: process(sel)
    variable index : natural;
    variable val : integer;
  begin 

    if sel = '0' and wr = '0' then
      index := CONV_INTEGER(address);

      storage(index) <= data;
       val := CONV_INTEGER(data);        
       assert false report "Index " & integer'image(index) severity note;
       assert false report "ramWR " & integer'image(val) severity note;
    end if;

  end process writeRAM;

  readRAM: process(sel)
    variable index : natural;
    variable d : reg8;                  -- usado por causa do assert
    -- variable val : integer;
  begin 

    if sel = '0' then
      if wr = '1' then
        index := CONV_INTEGER(address);
      
        d := storage(index);
        -- val := CONV_INTEGER(d);        
        -- assert false report "ramRD " & integer'image(val) severity note;
      end if;
    else
      d := (others=>'Z');
    end if;

    data <= d;
    
  end process readRAM;

end behavioral;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

