--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador de 12 bits, com adiantamento de vai-um, 4 a 4 bits
-- cfe. Seção 8.3.2 [Hexsel12]
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity add12 is
  port(inpA, inpB : in reg12;
       outC : out reg12;
       vem  : in std_logic;
       vai  : out std_logic
       );
end add12;

architecture adder12Adianta4 of add12 is 

  component addBit port(bitA, bitB, vem : in std_logic;
                        bitC, vai       : out std_logic);       
  end component addBit;

  component adianta4 port(a,b : in reg4;
                          vem : in std_logic;
                          c: out reg4);
  end component adianta4;
  
  signal v : reg12;                     -- cadeia de vai-um
  signal r : reg12;                     -- resultado parcial
  signal c : reg12;                     -- cadeia de adiantamento de vai-um

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

  vai <= c(11);
  outC <= r;
  
end adder12Adianta4;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador completo de um bit, modelo estrutural
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--library IEEE; use IEEE.std_logic_1164.all;
--use work.p_wires.all;

--entity add12 is
--  port(inpA, inpB : in reg12; --entradas A,B,
--       outC : out reg12; -- saída sum
--       vem : in std_logic; -- vem-um
--           vai : out std_logic);  -- saída vai-um
--end add12;

--architecture estrutural of add12 is 
--  component addBit port(bitA, bitB, vem : in std_logic;
--                        bitC, vai       : out std_logic);       
--  end component addBit;

--  signal result, cin : reg12;
--begin
--    b0: addBit port map (inpA(0), inpB(0), '0', result(0), cin(0));
--    b1: addBit port map (inpA(1), inpB(1), cin(0), result(1), cin(1));
--    b2: addBit port map (inpA(2), inpB(2), cin(1), result(2), cin(2));
--    b3: addBit port map (inpA(3), inpB(3), cin(2), result(3), cin(3));
--    b4: addBit port map (inpA(4), inpB(4), cin(3), result(4), cin(4));
--    b5: addBit port map (inpA(5), inpB(5), cin(4), result(5), cin(5));
--    b6: addBit port map (inpA(6), inpB(6), cin(5), result(6), cin(6));
--    b7: addBit port map (inpA(7), inpB(7), cin(6), result(7), cin(7));
--    b8: addBit port map (inpA(8), inpB(8), cin(7), result(8), cin(8));
--    b9: addBit port map (inpA(9), inpB(9), cin(8), result(9), cin(9));
--    bA: addBit port map (inpA(10), inpB(10), cin(9), result(10), cin(10));
--    bB: addBit port map (inpA(11), inpB(11), cin(10), result(11), cin(11));

--    vai <= cin(11);    
--    outC <= result;
--end estrutural;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

