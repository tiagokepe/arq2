--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para add10
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity testBench is
end testBench;

architecture TB of testBench is
    component add10 is
      port(inpA, inpB : in reg10; --entradas A,B,
           outC : out reg10; -- saída sum
           vem : in std_logic; -- vem-um
    	   vai : out std_logic);  -- saída vai-um
    end component add10;

    signal A, B, C: reg10;
    signal cin, cout: std_logic;
begin
    U_add8: add10 port map(
        inpA => A,
        inpB => B,
        outC  => C,
        vem  => cin,
        vai => cout
    );

    test: process
    begin
		cin <= '0';
        A <= "0000000000";
        B <= "0000000001";
        wait for 10 ns;

        A <= "0000000001";
        B <= "0000000001";
        wait for 10 ns;

        A <= "0000001000";
        B <= "0000000001";
        wait for 10 ns;

        A <= "1111111100";
        B <= "0000000011";
        wait for 10 ns;


    end process;

end TB;
