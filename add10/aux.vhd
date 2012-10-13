-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, ci312,ci702 2012-1 trabalho semestral, autor: Roberto Hexsel, 03out
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- ESTE ARQUIVO NAO PODE SER ALTERADO

--------------------------------------------------------------------------
-- Material adaptado de VHDL Designer's Guide [Ashenden96], MRstd_tb.vhd
-- [Calazans,Moraes06] e Sistemas Digitais [Hexsel12].
--------------------------------------------------------------------------

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador completo de um bit, modelo funcional
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;

entity addBit is
  port(bitA, bitB, vem : in std_logic;    -- entradas A,B,vem-um
       bitC, vai       : out std_logic);  -- saída C,vai-um
end addBit;

architecture funcional of addBit is 
  signal notB : std_logic;
begin
    bitC <= bitA xor bitB xor vem after 1 ns;
    vai <= (bitA and bitB)or(bitA and vem)or(vem and bitB) after 1.3 ns;
end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta AND de 2 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;

entity and2 is
  generic (prop : time := 0.6 ns);
  port(A, B : in std_logic;  -- entradas A,B
       S    : out std_logic);  -- saída C
end and2;

architecture and2 of and2 is 
begin
    S <= A and B after prop;
end and2;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta OR de 3 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;

entity or3 is
  generic (prop : time := 1 ns);
  port(A, B, C : in std_logic;  -- entradas A,B,C
       S       : out std_logic); -- saída S 
end or3;

architecture or3 of or3 is 
begin
    S <= A or B or C after prop;
end or3;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta XOR de 3 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;

entity xor3 is
  generic (prop : time := 1 ns);
  port(A, B, C : in std_logic;  -- entradas A,B,C
       S       : out std_logic);  -- saída S 
end xor3;

architecture xor3 of xor3 is 
begin
    S <= A xor B xor C after prop;
end xor3;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador completo de um bit, modelo estrutural
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity addBit is
  port(bitA, bitB, vem : in std_logic;    -- entradas A,B,vem-um
       bitC, vai       : out std_logic);  -- saída C,vai-um
end addBit;

architecture estrutural of addBit is 

  component and2 is generic (prop:time);
                      port (A,B: in std_logic; S: out std_logic);
  end component and2;

  component or3 is generic (prop:time);
                      port (A,B,C: in std_logic; S: out std_logic);
  end component or3;

  component xor3 is generic (prop:time);
                      port (A,B,C: in std_logic; S: out std_logic);
  end component xor3;

  signal a1,a2,a3: std_logic;
begin
  U_xor:  xor3 generic map ( 1.0 ns ) port map ( bitA, bitB, vem, bitC );

  U_and1: and2 generic map ( 0.6 ns ) port map ( bitA, bitB, a1 );
  U_and2: and2 generic map ( 0.6 ns ) port map ( bitA, vem,  a2 );
  U_and3: and2 generic map ( 0.6 ns ) port map ( vem,  bitB, a3 );
  U_or:   or3  generic map ( 1.0 ns ) port map ( a1, a2, a3, vai );

end estrutural;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- adiantamento de vai-um de 4 bits, P&H,2ndEd,sec4.5
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity adianta4 is
  port(a,b : in reg4;           -- entradas A(i),B(i)
       vem : in std_logic;      -- vem-um
       c: out reg4              -- vai(i)
       );
end adianta4;

architecture adianta4 of adianta4 is 
  signal p,g : reg4;
begin

  g(0) <= a(0) and b(0) after 0.6 ns;
  g(1) <= a(1) and b(1) after 0.6 ns;
  g(2) <= a(2) and b(2) after 0.6 ns;
  g(3) <= a(3) and b(3) after 0.6 ns;

  p(0) <= a(0) or b(0) after 0.6 ns;
  p(1) <= a(1) or b(1) after 0.6 ns;
  p(2) <= a(2) or b(2) after 0.6 ns;
  p(3) <= a(3) or b(3) after 0.6 ns;

  c(0) <= g(0) or (p(0) and vem) after 1.2 ns;
  c(1) <= g(1) or (p(1) and g(0)) or (p(1) and p(0) and vem) after 2.0 ns;
  c(2) <= g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or
          (p(2) and p(1) and p(0) and vem) after 2.4 ns;
  c(3) <= g(3) or (p(3) and g(2)) or (p(3) and p(2) and g(1)) or
          (p(3) and p(2) and p(1) and g(0)) or
          (p(3) and p(2) and p(1) and p(0) and vem) after 3.0 ns;

end adianta4;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador de 16 bits, com adiantamento de vai-um, 4 a 4 bits
-- cfe. Seção 8.3.2 [Hexsel12]
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity adderAdianta4 is
  port(inpA, inpB : in reg16;
       outC : out reg16;
       vem  : in std_logic;
       vai  : out std_logic
       );
end adderAdianta4;

architecture adderAdianta4 of adderAdianta4 is 

  component addBit port(bitA, bitB, vem : in std_logic;
                        bitC, vai       : out std_logic);       
  end component addBit;

  component adianta4 port(a,b : in reg4;
                          vem : in std_logic;
                          c: out reg4);
  end component adianta4;
  
  signal v : reg16;                     -- cadeia de vai-um
  signal r : reg16;                     -- resultado parcial
  signal c : reg17;                     -- cadeia de adiantamento de vai-um

begin

  -- entrada vem deve estar ligada em '0' para somar, em '1' para subtrair

  U_a0_3:
    adianta4 port map (inpA(3 downto 0),inpB(3 downto 0),vem,c(3 downto 0)); 

  U_b0: addBit port map ( inpA(0),inpB(0),vem, r(0),v(0) );
  U_b1: addBit port map ( inpA(1),inpB(1),c(0),r(1),v(1) );
  U_b2: addBit port map ( inpA(2),inpB(2),c(1),r(2),v(2) );
  U_b3: addBit port map ( inpA(3),inpB(3),c(2),r(3),v(3) );

  U_a4_7:
    adianta4 port map (inpA(7 downto 4),inpB(7 downto 4),c(3),c(7 downto 4));

  U_b4: addBit port map ( inpA(4),inpB(4),c(3),r(4),v(4) );
  U_b5: addBit port map ( inpA(5),inpB(5),c(4),r(5),v(5) );
  U_b6: addBit port map ( inpA(6),inpB(6),c(5),r(6),v(6) );
  U_b7: addBit port map ( inpA(7),inpB(7),c(6),r(7),v(7) );

  U_a8_b:
    adianta4 port map
      (inpA(11 downto 8),inpB(11 downto 8),c(7),c(11 downto 8)); 

  U_b8: addBit port map ( inpA(8), inpB(8), c(7), r(8), v(8) );
  U_b9: addBit port map ( inpA(9), inpB(9), c(8), r(9), v(9) );
  U_ba: addBit port map ( inpA(10),inpB(10),c(9), r(10),v(10) );
  U_bb: addBit port map ( inpA(11),inpB(11),c(10),r(11),v(11) );

  U_a12_15:
    adianta4 port map
      (inpA(15 downto 12),inpB(15 downto 12),c(11),c(15 downto 12)); 

  U_bc: addBit port map ( inpA(12),inpB(12),c(11),r(12),v(12) );
  U_bd: addBit port map ( inpA(13),inpB(13),c(12),r(13),v(13) );
  U_be: addBit port map ( inpA(14),inpB(14),c(13),r(14),v(14) );
  U_bf: addBit port map ( inpA(15),inpB(15),c(14),r(15),v(15) );
  
  vai <= c(15);
  outC <= r;
  
end adderAdianta4;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador de 16 bits, sem adiantamento de vai-um
-- cfe. Seção 8.3.2 [Hexsel12]
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity adderCadeia is
  port(inpA, inpB : in reg16;
       outC : out reg16;
       vem  : in std_logic;
       vai  : out std_logic
       );
end adderCadeia;

architecture adderCadeia of adderCadeia is 

  component addBit port(bitA, bitB, vem : in std_logic;
                        bitC, vai       : out std_logic);       
  end component addBit;

  signal v : reg16;                     -- cadeia de vai-um
  signal r : reg16;                     -- resultado parcial
  
begin

  -- entrada vem deve estar ligada em '0' para somar, em '1' para subtrair
  U_b0: addBit port map ( inpA(0),inpB(0),vem, r(0),v(0) );
  U_b1: addBit port map ( inpA(1),inpB(1),v(0),r(1),v(1) );
  U_b2: addBit port map ( inpA(2),inpB(2),v(1),r(2),v(2) );
  U_b3: addBit port map ( inpA(3),inpB(3),v(2),r(3),v(3) );
  U_b4: addBit port map ( inpA(4),inpB(4),v(3),r(4),v(4) );
  U_b5: addBit port map ( inpA(5),inpB(5),v(4),r(5),v(5) );
  U_b6: addBit port map ( inpA(6),inpB(6),v(5),r(6),v(6) );
  U_b7: addBit port map ( inpA(7),inpB(7),v(6),r(7),v(7) );
  U_b8: addBit port map ( inpA(8),inpB(8),v(7),r(8),v(8) );
  U_b9: addBit port map ( inpA(9),inpB(9),v(8),r(9),v(9) );
  U_ba: addBit port map ( inpA(10),inpB(10), v(9),r(10),v(10) );
  U_bb: addBit port map ( inpA(11),inpB(11),v(10),r(11),v(11) );
  U_bc: addBit port map ( inpA(12),inpB(12),v(11),r(12),v(12) );
  U_bd: addBit port map ( inpA(13),inpB(13),v(12),r(13),v(13) );
  U_be: addBit port map ( inpA(14),inpB(14),v(13),r(14),v(14) );
  U_bf: addBit port map ( inpA(15),inpB(15),v(14),r(15),v(15) );
  
  vai <= v(15);
  outC <= r;
  
end adderCadeia;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.p_WIRES.all;
entity count12 is
  generic (CNT_LATENCY: time := 3 ns);
  port(rel, rst, ld, en: in  std_logic;
        D:               in  reg12;
        Q:               out reg12);
end count12;

architecture funcional of count12 is
  signal count: reg12;
begin

  process(rel, rst, ld)
  begin
    if rst = '0' then
      count <= x"000";
    elsif ld = '0' and rising_edge(rel) then
      count <= D;
    elsif en = '0' and rising_edge(rel) then
      count <= count + x"001";
    end if;
  end process;

  Q <= count after CNT_LATENCY;
end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
