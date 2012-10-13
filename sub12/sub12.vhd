-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- subtrator completo de um bit, modelo funcional
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;

entity subBit is
  port(bitA, bitB, vem : in std_logic;    -- entradas A,B,vem-um
       bitC, vai       : out std_logic);  -- saída C,vai-um
end subBit;

architecture funcional of subBit is 
begin
    bitC <= bitA xor bitB xor vem after 1 ns;
    vai <= ( (not bitA) and bitB)or( (not bitA) and vem)or(vem and bitB) after 1.3 ns;
end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- subtrator completo de um bit, modelo estrutural
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity subBit is
  port(bitA, bitB, vem : in std_logic;    -- entradas A,B,vem-um
       bitC, vai       : out std_logic);  -- saída C,vai-um
end subBit;

architecture estrutural of subBit is 

  component and2 is generic (prop:time);
                      port (A,B: in std_logic; S: out std_logic);
  end component and2;

  component or3 is generic (prop:time);
                      port (A,B,C: in std_logic; S: out std_logic);
  end component or3;

  component xor3 is generic (prop:time);
                      port (A,B,C: in std_logic; S: out std_logic);
  end component xor3;

  signal a1,a2,a3, notA: std_logic;
begin
  U_xor:  xor3 generic map ( 1.0 ns ) port map ( bitA, bitB, vem, bitC );

  U_notA: notA <= not bitA;

  U_and1: and2 generic map ( 0.6 ns ) port map ( notA, bitB, a1 );
  U_and2: and2 generic map ( 0.6 ns ) port map ( notA, vem,  a2 );
  U_and3: and2 generic map ( 0.6 ns ) port map ( vem,  bitB, a3 );
  U_or:   or3  generic map ( 1.0 ns ) port map ( a1, a2, a3, vai );

end estrutural;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Subtrator completo de 12 bits, modelo estrutural
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity sub12 is
	port(inpA, inpB: in reg12;
		 outC: out reg12;
         vem : in std_logic; -- vem-um
         vai : out std_logic);  -- saída vai-um
end sub12;

architecture estrutural of sub12 is
	component subBit port(bitA, bitB, vem : in std_logic;
					      bitC, vai       : out std_logic);
	end component subBit;

	signal result, cin: reg12;
begin
   	b0: subBit port map (inpA(0), inpB(0), '0', result(0), cin(0));
	b1: subBit port map (inpA(1), inpB(1), cin(0), result(1), cin(1));
    b2: subBit port map (inpA(2), inpB(2), cin(1), result(2), cin(2));
    b3: subBit port map (inpA(3), inpB(3), cin(2), result(3), cin(3));
    b4: subBit port map (inpA(4), inpB(4), cin(3), result(4), cin(4));
    b5: subBit port map (inpA(5), inpB(5), cin(4), result(5), cin(5));
    b6: subBit port map (inpA(6), inpB(6), cin(5), result(6), cin(6));
    b7: subBit port map (inpA(7), inpB(7), cin(6), result(7), cin(7));
    b8: subBit port map (inpA(8), inpB(8), cin(7), result(8), cin(8));
    b9: subBit port map (inpA(9), inpB(9), cin(8), result(9), cin(9));
    bA: subBit port map (inpA(10), inpB(10), cin(9), result(10), cin(10));
    bB: subBit port map (inpA(11), inpB(11), cin(10), result(11), cin(11));

    vai <= cin(11);    
    outC <= result;
end estrutural;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


