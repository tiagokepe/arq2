--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para compador de 1 bit
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity nortest is
end nortest;

architecture TB of nortest is
	component nor2 is generic (prop:time);
	  port(A, B : in std_logic;  -- entradas A,B,C
       	   S    : out std_logic);  -- saída S 
	end component nor2;

	component and5 is generic (prop:time);
		port(vector : in reg5;
        		  S : out std_logic);
	end component and5;

	component nor10 is
	  port(A : in reg10;  -- entradas A
	   	   S : out std_logic);  -- saída S 
	end component nor10;

	signal s_A: reg10;
	signal outNor10, outNor2, outAnd5, bitA, bitB: std_logic;
	signal ands: reg5;
begin

--	mapAnd5: and5 generic map(2 ns) port map(
--	);
	mapNor2: nor2 generic map(0.5 ns) port map(
		A => bitA,
		B => bitB,
		S => outNor2
	);

	test1: process
	begin
		bitA <= '0';
		bitB <= '0';
		wait for 1 ns;
		bitA <= '0';
		bitB <= '1';
		wait for 1 ns;
		bitA <= '1';
		bitB <= '0';
		wait for 1 ns;
		bitA <= '1';
		bitB <= '1';
		wait for 1 ns;
	end process;

	mapNor10: nor10 port map(
		A => s_A,
		S => outNor10
	);

	test2: process
	begin
		s_A <= "0000000001";
		wait for 3 ns;
		s_A <= "0000000000";
		wait for 3 ns;
		s_A <= "0010000000";
		wait for 3 ns;
		s_A <= "1000000000";
		wait for 3 ns;
		s_A <= "0000000000";
		wait for 3 ns;
	end process;
end TB;



