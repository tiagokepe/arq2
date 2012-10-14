-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- test bench do seguimento 1 do pipeline
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_wires.all;
use work.p_matriz.all;

entity test is
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

	component seg1 is
		port(clk, rst     : in  std_logic;
		     v_norte      : in  reg8;
		     v_sul        : in  reg8;
		     v_leste      : in  reg8;
		     v_atual     : in  reg8;
		     reg_norte12  : out reg12;
		     reg_sul12    : out reg12;
		     reg_leste12  : out reg12;
		     reg_atual12 : out reg12);
	end component seg1;

    constant CLOCK : time := 20 ns;

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

	signal N, S, L, ATUAL : reg8;
	signal reg_N, reg_S, reg_L, reg_ATUAL : reg12;
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



--	mapeia_seg1: seg1 port map(rel, rst, N, S, L, ATUAL, v_N, v_S, v_L, v_ATUAL);

	mapeia_seg1: seg1 port map( clk =>rel,
								rst=> rst,
								v_norte => N,
								v_sul => S,
								v_leste => L,
								v_atual => ATUAL,
								reg_norte12 => reg_N,
								reg_sul12 => reg_S,
								reg_leste12 => reg_L,
								reg_atual12 => reg_ATUAL);


--	test: process
--	begin
--		N <= x"00";
--		S <= x"01";
--		L <= x"02";
--		ATUAL <= x"03";
--		wait for 20 ns;
--	end process;

end TB;



