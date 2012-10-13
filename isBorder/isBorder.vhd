-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Verificador de borda de 10 bits, estrutural e RTL
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity isBorder is
    generic (prop : time := 5 ns);
	port(ccol, clin, COL, LIN: in reg10;
		border				 : out std_logic
	);
end isBorder;

architecture funcional of isBorder is
	component compare10 is
		  port(A, B : in reg10;  -- entradas A,Bestrutural em 
		       S    : out std_logic);  -- saída S
	end component compare10;

	signal result: reg4;
	constant zero: reg10 := "0000000000";
begin
	ccol_0	: compare10 port map(ccol, zero, result(0));
	clin_0	: compare10 port map(clin, zero, result(1));
	ccol_COL: compare10 port map(ccol, COL,  result(2));
	clin_LIN: compare10 port map(clin, LIN,  result(3));

	border <= result(0) or result(1) or result(2) or result(3);
end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta OR de 4 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity or4 is
  generic (prop : time := 1.3 ns);
  port(A : in reg4;  -- entradas A,B,C
       S : out std_logic); -- saída S 
end or4;

architecture or4 of or4 is 
begin
    S <= A(0) or A(1) or A(2) or A(3) after prop;
end or4;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Verificador de borda de 10 bits, estrutural
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity isBorder is
	port(ccol, clin, COL, LIN: in reg10;
		border				 : out std_logic
	);
end isBorder;

architecture estrutural of isBorder is
	component compare10 is
		  port(A, B : in reg10;  -- entradas A,B
		       S    : out std_logic);  -- saída S
	end component compare10;

	component sub10 is
		port(inpA, inpB: in reg10;
			 outC: out reg10;
		     vem : in std_logic; -- vem-um
		     vai : out std_logic);  -- saída vai-um
	end component sub10;


	component or4 is generic (prop:time);
		port(A : in reg4;  -- entradas A,B,C
			 S : out std_logic); -- saída S 
	end component or4;	

	signal cout: reg2;
	signal result: reg4;
	signal s_tam_col, s_tam_lin: reg10;
	constant ZERO: reg10 := "0000000000";
	constant UM: reg10 := "0000000001";

begin
	-- Subtrai 1 de TAM_COL para acertar a entrada do isBorder
	U_sub_tam_col: sub10
		port map(COL, UM, s_tam_col, '0', cout(0));

	-- Subtrai 1 de TAM_COL para acertar a entrada do isBorder
	U_sub_tam_lin: sub10
		port map(LIN, UM, s_tam_lin, '0', cout(1));

	ccol_0	: compare10 port map(ccol, ZERO, result(0));
	clin_0	: compare10 port map(clin, ZERO, result(1));
	ccol_COL: compare10 port map(ccol, s_tam_col,  result(2));
	clin_LIN: compare10 port map(clin, s_tam_lin,  result(3));

	final   : or4 generic map(1.3 ns) port map(result, border);

end estrutural;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


