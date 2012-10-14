--------------------------------------------------------------------------
-- Modulo que implementa um modelo comportamental de uma ROM Assincrona.
-- O arquivo com matriz de entrada contem um inteiro de 8 bits
-- codificado em dois caracteres hexadecimais em cada linha.
--------------------------------------------------------------------------
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.p_wires.all;
use work.p_matriz.all;

entity ROM is
  generic (load_file_name : string := "matriz.txt";
           MEM_LATENCY: time := 10 ns);
  port (rst     : in    std_logic;
        sel     : in    std_logic;
        address : in    addressMem;   -- depende do tamanho da matriz
        data    : inout reg8);
end entity ROM;

architecture behavioral of ROM is

begin  -- behavioral

  behave: process (rst,sel,address)
    subtype word is std_logic_vector(0 to data'length - 1);
    type storage_array is
      array (natural range 0 to 2**address'length - 1) of word;
    variable storage : storage_array;
    variable index : natural;
    
    file load_file: TEXT open read_mode is load_file_name;

    variable arq_line: line;
    variable rom_line: string(1 to MAT_LINHA_SZ);
    variable nibble0,nibble1 : reg4;
    variable val : integer;
    
  begin
    
    if rst = '0' then                   -- reset, leia arquivo

      -- formato do arquivo de entrada:
      -- MAT_LINHA_SZxMAT_LINHA_SZ linhas de 2 caracteres (+\n)
      -- codificados em hexadecimal, sem prefixo
      
      index := 0;
      while not endfile(load_file) loop
        readline(load_file,arq_line);
        read(arq_line, rom_line(1 to arq_line'length));
        nibble0 := CONVERT_VECTOR(rom_line,1);
        nibble1 := CONVERT_VECTOR(rom_line,2);
        storage(index) := nibble0 & nibble1; 
        index := index + 1;
        --val := CONV_INTEGER(nibble0 & nibble1);
        --assert false report integer'image(val) severity note;
      end loop;

    else                                -- operacao normal

      index := CONV_INTEGER(address);
      if sel = '0' then
        data <= storage(index) after MEM_LATENCY;
      else
        data <= (others => 'Z');
      end if;

    end if;

  end process;

end behavioral;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

