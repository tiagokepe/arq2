-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador completo de um bit, modelo estrutural
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity add10 is
  port(inpA, inpB : in reg10; --entradas A,B,
       outC : out reg10; -- saída outC
       vem : in std_logic; -- vem-um
	   vai : out std_logic);  -- saída vai-um
end add10;

architecture estrutural of add10 is 
  component addBit port(bitA, bitB, vem : in std_logic;
                        bitC, vai       : out std_logic);       
  end component addBit;

  signal result, cin : reg10;
begin
	b0: addBit port map (inpA(0), inpB(0), '0', result(0), cin(0));
	b1: addBit port map (inpA(1), inpB(1), cin(0), result(1), cin(1));
	b2: addBit port map (inpA(2), inpB(2), cin(1), result(2), cin(2));
	b3: addBit port map (inpA(3), inpB(3), cin(2), result(3), cin(3));
	b4: addBit port map (inpA(4), inpB(4), cin(3), result(4), cin(4));
	b5: addBit port map (inpA(5), inpB(5), cin(4), result(5), cin(5));
	b6: addBit port map (inpA(6), inpB(6), cin(5), result(6), cin(6));
	b7: addBit port map (inpA(7), inpB(7), cin(6), result(7), cin(7));

	b8: addBit port map (inpA(8), inpB(8), cin(7), result(8), cin(8));
	b9: addBit port map (inpA(9), inpB(9), cin(8), result(9), cin(9));

    vai <= cin(9);    
    outC <= result;
end estrutural;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- somador completo de um bit, modelo estrutural
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity add10 is
  port(inpA, inpB : in reg10; --entradas A,B,
       outC : out reg10; -- saída outC
       vem : in std_logic; -- vem-um
	   vai : out std_logic);  -- saída vai-um
end add10;

architecture adder10adianta4 of add10 is 
  component addBit port(bitA, bitB, vem : in std_logic;
                        bitC, vai       : out std_logic);       
  end component addBit;

  component adianta4 port(a,b : in reg4;
                          vem : in std_logic;
                          c: out reg4);
  end component adianta4;

--  signal c: reg8;
  signal result, cin : reg10;
begin
    U_a0_3:
      adianta4 port map (inpA(3 downto 0),inpB(3 downto 0),vem,cin(3 downto 0)); 

	b0: addBit port map (inpA(0), inpB(0), '0', result(0), cin(0));
	b1: addBit port map (inpA(1), inpB(1), cin(0), result(1), cin(1));
	b2: addBit port map (inpA(2), inpB(2), cin(1), result(2), cin(2));
	b3: addBit port map (inpA(3), inpB(3), cin(2), result(3), cin(3));

    U_a4_7:
      adianta4 port map (inpA(7 downto 4),inpB(7 downto 4), cin(3), cin(7 downto 4));

	b4: addBit port map (inpA(4), inpB(4), cin(3), result(4), cin(4));
	b5: addBit port map (inpA(5), inpB(5), cin(4), result(5), cin(5));
	b6: addBit port map (inpA(6), inpB(6), cin(5), result(6), cin(6));
	b7: addBit port map (inpA(7), inpB(7), cin(6), result(7), cin(7));

	b8: addBit port map (inpA(8), inpB(8), cin(7), result(8), cin(8));
	b9: addBit port map (inpA(9), inpB(9), cin(8), result(9), cin(9));

    vai <= cin(9);    
    outC <= result;
end adder10adianta4;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
