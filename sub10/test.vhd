-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- subtrator completo de um bit, modelo funcional
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component subBit is
		port(bitA, bitB, vem : in std_logic;    -- entradas A,B,vem-um
			 bitC, vai       : out std_logic);  -- saída C,vai-um
	end component subBit;
	
	component sub10 is 	port(inpA, inpB: in reg10;
				 			 outC: out reg10;
					         vem : in std_logic; -- vem-um
					         vai : out std_logic);  -- saída vai-um
	end component sub10;

	signal A, B, C: reg10;
	signal bitA, bitB, bitC, cin, cout, cinBit, coutBit: std_logic;
begin
	mapSubBit: subBit port map(bitA, bitB, cinBit, bitC, coutBit);
	map12: sub10 port map(
		inpA => A,
		inpB => B,
		vem  => cin,
		outC => C,
		vai => cout
	);

	testsub10: process
	begin
		cin	<= '0';
		A	<= "0100000000";
		B	<= "0011111111";
		wait for 30 ns;
		A	<= "0111111111";
		B	<= "0011111111";
		wait for 30 ns;
		A	<= "0000000001";
		B	<= "0000000011";
		wait for 30 ns;
		A	<= "0000000111";
		B	<= "0000000100";
		wait for 30 ns;
		A	<= "0000001000";
		B	<= "0000000001";
		wait for 30 ns;

	end process;

	test: process
	begin
		cinBit <= '0';
		bitA <= '0';
		bitB <= '0';
		wait for 2 ns;
		bitA <= '0';
		bitB <= '1';
		wait for 2 ns;
		bitA <= '1';
		bitB <= '0';
		wait for 2 ns;
		bitA <= '1';
		bitB <= '1';
		wait for 2 ns;
	end process;
	
end TB;
