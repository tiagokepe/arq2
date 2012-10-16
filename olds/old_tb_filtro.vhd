-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, ci312,ci702 2012-1 trabalho semestral, autor: Roberto Hexsel, 28set
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



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
        address : in    reg12;          -- depende do tamanho da matriz
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
        address : in    reg12;          -- depende do tamanho da matriz
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
    -- variable val : integer;
  begin 

    if sel = '0' and wr = '0' then
      index := CONV_INTEGER(address);

      storage(index) <= data;
      -- val := CONV_INTEGER(data);        
      -- assert false report "ramWR " & integer'image(val) severity note;
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




--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para filtro 2D
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_wires.all;
use work.p_matriz.all;

entity tb_filtro is
end tb_filtro;

architecture TB of tb_filtro is
  
  component ROM is 
    generic (load_file_name : string := "matriz.txt";
             MEM_LATENCY: time := 10 ns);
    port (rst     : in std_logic;
          sel     : in    std_logic;
          address : in    std_logic_vector;
          data    : inout std_logic_vector);
  end component ROM;

  component RAM is
    generic (MEM_LATENCY: time := 10 ns);
    port (sel     : in    std_logic;
          wr      : in    std_logic;
          address : in    std_logic_vector;
          data    : inout std_logic_vector);
  end COMPONENT RAM;

  component count12 is
    generic (CNT_LATENCY: time := 5 ns);
    port(rel, rst, ld, en: in  std_logic;
         D:                in  reg12;
         Q:                out reg12);
  end component count12;
  
  component filtro                      -- interface incompleta
    generic (CIRC_LATENCY: time := 10 ns);
    port(rel, rst, ld, en: in std_logic;
         lin,col: in integer);
  end component filtro;

  signal rel,rst,ld,en : std_logic;
  signal selram : std_logic := '1';
  signal selrom : std_logic := '1';
  signal wr : std_logic := '1';
  signal a : reg12 := x"000";
  signal datrom,datram : reg8;
  signal lin,col : integer := 64;
  
  signal phase : std_logic;
  signal ramRDY : std_logic := '1';     -- inativo, ativo em '0'
  signal lido : reg8;

begin  -- TB

  U_clock: process
  begin
    rel <= '0';      -- executa e
    wait for CLOCK_PER / 2;  -- espera meio ciclo
    rel <= '1';      -- volta a executar e
    wait for CLOCK_PER / 2;  -- espera meio ciclo e volta ao topo
  end process;

  U_reset: process
  begin
    rst <= '0';      -- executa e
    wait for CLOCK_PER * 0.75;  -- espera por 40ns
    rst <= '1';      -- volta a executar e
    wait;            -- espera para sempre
  end process;

  U_filtro:  filtro
    generic map (5 ns)
    port map (rel, rst, ld, en, lin, col);

  U_count12: count12
    generic map (2 ns)
    port map (rel, rst, '1', '0', x"000", a);

  U_ROM_INP: ROM
    generic map ("matriz.txt", 1 ns)
    port map (rst,selrom,a,datrom);

  U_RAM_OUT: RAM
    generic map (1 ns)
    port map (selram,wr,a,datram);
  
  selrom <= rel;

  -- =================================================================
  -- O trecho de codigo abaixo e somente uma indicacao de como o seu
  -- modelo deve acessar as memorias ROM (fonte) e RAM (destino);
  -- Seu projeto deve incorporar o comportamento do filtro, o que
  -- possivelmente mudara o acesso aas memorias.
  -- =================================================================

  -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- acesso aa memoria adaptado de VHDL Designers's Guide [Ashenden96]
  -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  U_leROM: process                      -- copia da ROM para a RAM
    variable val : integer;
  begin

    phase <= '0';                       -- copia ROM para RAM
    wait until rst = '1';               -- ROM inicializada no reset

    -- #############
    -- ATENCAO: este código ignora as dimensões da matriz e deve ser
    --          alterado
    -- #############
    wr <= '0';
    for i in 0 to (MEM_SZ - 1) loop

      wait until selrom = '0'; wait for 7 ns;  -- espera acesso aa ROM
          -- val := CONV_INTEGER(datrom);        
          -- assert false report "romrd " & integer'image(val) severity note;
      datram <= datrom; wait for 0 ns;
          -- val := CONV_INTEGER(datram);        
          -- assert false report "romcp " & integer'image(val) severity note;
      selram <= '0';
      wait until ramRDY = '0';
      -- wait for RAM     
      wait until ramRDY = '1';
      selram <= '1';

      wait until selrom = '1';
      
    end loop;

    datram <= (others => 'Z');
    phase <= '1';                       -- observa o que gravou na RAM
    -- neste ponto o contador deve ter virado: 0xfff -> 0x000

    wr <= '1';
    for i in 0 to (MEM_SZ - 1) loop

      wait until rel = '0';
      selram <= '0';
      wait until ramRDY = '0';
      --wait for 11 ns;
      lido <= datram;
      wait for 0 ns;
         val := CONV_INTEGER(lido);        
         assert false report integer'image(val) severity note;
      wait until ramRDY = '1';
      selram <= '1';
      wait until rel = '1';

    end loop;

  end process U_leROM;

 
  U_controlaRAM: process
    variable val : integer;
  begin
    -- controla temporizacao da RAM
    wait until selram = '0';
    ramRDY <= '0';
        wait for 10 ns;                 -- MEM_LATENCY
    ramRDY <= '1';
    wait until selram = '1';
  end process U_controlaRAM;
   
end TB;
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

----------------------------------------------------------------
configuration CFG_TB of tb_filtro is
	for TB
        end for;
end CFG_TB;
----------------------------------------------------------------
