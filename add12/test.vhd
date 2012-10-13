--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para add8Bit
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity test is
end test;

architecture TB of test is
    component add12 is
    	port(inpA, inpB : in reg12;
	         outC : out reg12;
		     vem  : in std_logic;
		     vai  : out std_logic
		);
    end component add12;

    signal A, B, C: reg12;
    signal cin, cout: std_logic;
begin
    U_add8: add12 port map(
        inpA => A,
        inpB => B,
        outC  => C,
        vem  => cin,
        vai => cout
    );

    test: process
    begin
--		C <= "000000000000";
		cin <= '1';
        A <= "000000001000";
        B <= "000000000001";
--		cout <= '0';
        wait for 10 ns;

        A <= "000000000001";
        B <= "000000000001";
        wait for 10 ns;

        A <= "000000000100";
        B <= "000000000100";
        wait for 10 ns;

        A <= "000000000010";
        B <= "000000000001";
        wait for 10 ns;


--        A <= "00000010";
--        B <= "00000001";
--        wait for 10 ns;

--        A <= "11111111";
--        B <= "00000011";
--        wait for 3 ns;
    end process;
end TB;
