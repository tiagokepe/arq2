--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para compador de 1 bit e 10 bits
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
	component compareBit is
	  port(bitA, bitB : in std_logic;  -- entradas A,B
	   		bitS    : out std_logic);  -- saída S 
	end component compareBit;

	component compare10 is
		port(A, B : in reg10;
			 S    : out std_logic);
	end component compare10;

	component and10 is
	  port(A : in reg10;  -- entradas A
	       S : out std_logic);  -- saída S 
	end component and10;


	signal A, B, outBit, out10, outAnd10: std_logic;
	signal A10, B10, aux10, inAnd10: reg10;

begin
	mapAnd10: and10 port map(inAnd10, outAnd10);
	testAnd10: process
	begin
		inAnd10 <= "1111111111";
		wait for 10 ns;

		inAnd10 <= "0000000010";
		wait for 10 ns;
	end process;

	map10: compare10 port map(A10, B10, out10);
	test0: process
	begin
		A10 <= "0000000000";
		B10 <= "0000000000";
		wait for 10 ns;
		assert (out10 = '1') report "Error in compare 10." severity failure;

		A10 <= "0000000001";
		B10 <= "0000000000";
		wait for 10 ns;
		assert (out10 = '0') report "Error in compare 10." severity failure;

		A10 <= "1000000000";
		B10 <= "1000000000";
		wait for 10 ns;
		assert (out10 = '1') report "Error in compare 10." severity failure;

		A10 <= "1111111111";
		B10 <= "1111111111";
		wait for 10 ns;
		assert (out10 = '1') report "Error in compare 10." severity failure;

		A10 <= "1111111111";
		B10 <= "1111111110";
		wait for 10 ns;
		assert (out10 = '0') report "Error in compare 10." severity failure;
	end process;

	mapBit: compareBit port map(
		bitA => A,
		bitB => B,
		bitS => outBit
	);
	test1: process
	begin
		A <= '0';
		B <= '0';
		wait for 1 ns;
		A <= '0';
		B <= '1';
		wait for 1 ns;
		A <= '1';
		B <= '0';
		wait for 1 ns;
		A <= '1';
		B <= '1';
		wait for 1 ns;
	end process;
end TB;
