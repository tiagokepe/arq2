-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- test bench do seguimento 1 do pipeline
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
use work.p_wires.all;
use work.p_matriz.all;

entity test is
  function to_string(sv: Std_Logic_Vector) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := to_bitvector(sv);
    variable lp: line;
  begin
    write(lp, bv);
    return lp.all;
  end;

  function decrese_length(source: Std_Logic_Vector; newSize: integer) return Std_Logic_Vector is
    variable v: std_logic_vector((newSize - 1) downto 0);
  begin
	v := source((newSize - 1) downto 0);
	report "No descrese = " & to_string(v) severity note;
    return v;
  end decrese_length;


end test;

architecture TB of test is
	component ROM is 
		generic (load_file_name : string := "matriz.txt";
				 MEM_LATENCY: time := 10 ns);
		port (rst     : in std_logic;
			  sel     : in    std_logic;
			  address : in    address;
			  data    : inout std_logic_vector);
	end component ROM;

	component seg0 is
		port(clk, rst, ld, en 			: in std_logic;
			 TAM_COL, TAM_LIN			: in reg10;
			 norte, sul, leste, atual	: out reg10;
			 border 					: out std_logic
		);
	end component seg0;

	component seg1 is
		port(clk, rst, ld : in  std_logic;
		     v_norte      : in  reg8;
		     v_sul        : in  reg8;
		     v_leste      : in  reg8;
		     v_atual      : in  reg8;
		     reg_norte12  : out reg12;
		     reg_sul12    : out reg12;
		     reg_leste12  : out reg12;
		     reg_atual12  : out reg12);
	end component seg1;

	component seg2 is
		port(clk, rst, ld, en 			 		: in  std_logic;
			 norte, sul, leste, anterior, atual : in  reg12;
			 resultSeg2					 		: out reg12
		);
	end component seg2;


--    constant CLOCK : time := 20 ns;
	constant TAM_COL : reg10  := conv_std_logic_vector(MAT_COL, 10);
	constant TAM_LIN : reg10  := conv_std_logic_vector(MAT_LIN, 10);
	constant LEN_ADDRESS : integer := address'length;

	signal rel,rst,ld,en : std_logic;

	signal selram : std_logic := '1';
	signal selrom : std_logic := '1';
	signal wr : std_logic := '1';
	signal a : address := x"000";
	signal datrom,datram : reg8;
	signal lin,col : integer := 64;

	signal phase : std_logic;
	signal ramRDY : std_logic := '1';     -- inativo, ativo em '0'
	signal lido : reg8;

	signal endNorte, endSul, endLeste, endAtual, endAnt : reg10;
	signal isBorder: std_logic;
	signal valueNorte, valueSul, valueLeste, valueAtual : reg8;
	signal reg_N, reg_S, reg_L, reg_ATUAL, reg_ANT, resultSeg2 : reg12;
begin
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

    U_seg0: seg0
    	port map(rel, rst, '1', en, TAM_COL, TAM_LIN, endNorte, endSul, endLeste, 
				 endAtual, isBorder);

	U_seg1: seg1 port map(rel, rst, '0', valueNorte, valueSul, valueLeste, valueAtual,
						  reg_N, reg_S, reg_L, reg_ATUAL);

	U_seg2: seg2 port map(rel, rst, ld, en, reg_N, reg_S, reg_L, reg_ANT, reg_ATUAL, resultSeg2);

	U_ROM_INP: ROM
		generic map ("matriz.txt", 1 ns)
		port map (rst,selrom,a,datrom);


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
    en <= '1'; 							-- Enable desabilitado

	report "MEM_SIZE " & integer'image(MEM_SZ) severity note;
	report "LENG = " & integer'image(LEN_ADDRESS) severity note;
	report "TAM_COL = " & to_string(TAM_COL) severity note;
	report "TAM_LIN = " & to_string(TAM_LIN) severity note;
--    report "AKI = " & integer'image(i) severity note;


    -- #############
    -- ATENCAO: este código ignora as dimensões da matriz e deve ser
    --          alterado
    -- #############
    wr <= '0';
    for i in 0 to (MEM_SZ - 1) loop

      en <= '0'; -- Habilita seg0 para o proximo clock

--      wait until selrom = '0'; wait for 7 ns;  -- espera acesso aa ROM
--	  wait until en = '0';
	  a <= decrese_length(endNorte, LEN_ADDRESS); -- ajusta tamanhos
      selrom <= isBorder; wait for 7 ns;  -- espera acesso aa ROM
	  valueNorte <= datrom;

	  a <= decrese_length(endSul, LEN_ADDRESS); -- ajusta tamanhos
      selrom <= isBorder; wait for 7 ns;  -- espera acesso aa ROM
	  valueSul <= datrom;

	  a <= decrese_length(endLeste, LEN_ADDRESS); -- ajusta tamanhos
      selrom <= isBorder; wait for 7 ns;  -- espera acesso aa ROM
	  valueLeste <= datrom;

	  a <= decrese_length(endAtual, LEN_ADDRESS); -- ajusta tamanhos
      selrom <= isBorder; wait for 7 ns;  -- espera acesso aa ROM
	  valueAtual <= datrom;


          -- val := CONV_INTEGER(datrom);        
          -- assert false report "romrd " & integer'image(val) severity note;
--      datram <= datrom; wait for 0 ns;
          -- val := CONV_INTEGER(datram);        
          -- assert false report "romcp " & integer'image(val) severity note;
--      selram <= '0';
--      wait until ramRDY = '0';
      -- wait for RAM     
--      wait until ramRDY = '1';
--      selram <= '1';

--      wait until selrom = '1';

      report "END LOOP = " & integer'image(i) severity note;
      
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


end TB;

--	mapeia_seg1: seg1 
--		port map(rel, rst, ld, N, S, L, ATUAL, reg_N, reg_S, reg_L, reg_ATUAL);

--	test: process
--	begin
--		ld <= '0';
--		N <= x"00";
--		S <= x"01";
--		L <= x"02";
--		ATUAL <= x"03";
--		wait for 18 ns;

--		ld <= '1';
--		wait for 2 ns;
--		N <= x"FF";
--		S <= x"AA";
--		L <= x"CC";
--		ATUAL <= x"88";
--		wait for 18 ns;

--		ld <= '0';
--		wait for 2 ns;
--		N <= x"00";
--		S <= x"01";
--		L <= x"10";
--		ATUAL <= x"11";
--		wait for 18 ns;

--	end process;
