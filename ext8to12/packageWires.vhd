-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, ci312,ci702 2012-1 trabalho semestral, autor: Roberto Hexsel, 28set
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- ESTE ARQUIVO NAO PODE SER ALTERADO

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- baseado em MRstd_tb.vhd [Calazans,Moraes06], [TortatoJr09]
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
library std;  use std.textio.all;
package p_WIRES is -- tipos para os barramentos e sinais

  constant CLOCK_PER : time := 50 ns;
  constant LATENCIA_MEM : time := 10 ns;

  subtype reg2  is std_logic_vector(1 downto 0);
  subtype reg3  is std_logic_vector(2 downto 0);
  subtype reg4  is std_logic_vector(3 downto 0);
  subtype reg5  is std_logic_vector(4 downto 0);
  subtype reg8  is std_logic_vector(7 downto 0);
  subtype reg9  is std_logic_vector(8 downto 0);
  subtype reg10 is std_logic_vector(9 downto 0);
  subtype reg12 is std_logic_vector(11 downto 0);
  subtype reg16 is std_logic_vector(15 downto 0);
  subtype reg17 is std_logic_vector(16 downto 0);
  subtype reg24 is std_logic_vector(23 downto 0);

  constant MAT_LINHA_SZ : integer := 3;  -- matriz de entrada
  
  function log2_ceil(n: natural) return natural;
  function CONVERT_STRING(s: in string) return std_logic_vector;
  function CONVERT_VECTOR(letra: string(1 to MAT_LINHA_SZ);  pos: integer)
    return std_logic_vector;
   
end p_WIRES;

package body p_WIRES is

   -- find minimum number of bits required to
   -- represent N as an unsigned binary number
  function log2_ceil(n: natural) return natural is
   begin
     if n < 2 then
       return 0;
     else
       return 1 + log2_ceil(n/2);
     end if;
   end;

  
  --converte string em std_logic_vector 
  function CONVERT_STRING(s: in string) return std_logic_vector is
    variable result : std_logic_vector(s'range);
  begin
    for i   in s'range loop
      if s(i) = '0' then
        result(i) := '0'; 
      elsif s(i) = '1' then 
        result(i) := '1';
      elsif s(i) = 'x' then
        result(i) := 'X';
      else
        result(i) := 'Z';
      end if;
    end loop;
    return result;
  end CONVERT_STRING;

  
  -- converte caractere de uma linha para um std_logic_vector
  function CONVERT_VECTOR(letra: string(1 to MAT_LINHA_SZ); pos: integer)
    return std_logic_vector
  is
    variable bin: reg4;
  begin
    case (letra(pos)) is
      when '0' => bin := "0000";
      when '1' => bin := "0001";
      when '2' => bin := "0010";
      when '3' => bin := "0011";
      when '4' => bin := "0100";
      when '5' => bin := "0101";
      when '6' => bin := "0110";
      when '7' => bin := "0111";
      when '8' => bin := "1000";
      when '9' => bin := "1001";
      when 'A' | 'a' => bin := "1010";
      when 'B' | 'b' => bin := "1011";
      when 'C' | 'c' => bin := "1100";
      when 'D' | 'd' => bin := "1101";
      when 'E' | 'e' => bin := "1110";
      when 'F' | 'f' => bin := "1111";
      when others =>  bin := "UUUU";  
    end case;
    return bin;
  end CONVERT_VECTOR;

end p_WIRES;

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
