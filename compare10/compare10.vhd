-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta OR de 5 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity or5 is
  generic (prop : time := 2 ns);
  port(vector : in reg5;  -- entradas A,B,C
       		S : out std_logic);  -- saída S 
end or5;

architecture or5 of or5 is 
begin
    S <= vector(0) or vector(1) or vector(2) or vector(3) or vector(4) after prop;
end or5;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta AND de 5 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity and5 is
  generic (prop : time := 2 ns);
  port(vector : in reg5;  -- entradas A,B,C
       		S : out std_logic);  -- saída S 
end and5;

architecture and5 of and5 is 
begin
    S <= vector(0) and vector(1) and vector(2) and vector(3) and vector(4) after prop;
end and5;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta NOR de 2 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;

entity nor2 is
  generic (prop : time := 0.6 ns);
  port(A, B : in std_logic;  -- entradas A,B,C
       S    : out std_logic);  -- saída S 
end nor2;

architecture nor2 of nor2 is 
begin
    S <= A nor B after prop;
end nor2;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta NOR de 10 bits
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity nor10 is
  port(A : in reg10;  -- entradas A
       S : out std_logic);  -- saída S 
end nor10;

architecture nor10 of nor10 is 
	component nor2 is generic (prop:time); 
		port(A, B : in std_logic; 
			 S : out std_logic);
	end component nor2;

 	component and5 is generic (prop:time);
		port(vector : in reg5;
       		 	  S : out std_logic); 
	end component and5;

	signal aux: reg5;
begin
	U_b01: nor2 generic map(0.6 ns) port map(A(0), A(1), aux(0));
	U_b23: nor2 generic map(0.6 ns) port map(A(2), A(3), aux(1));
	U_b45: nor2 generic map(0.6 ns) port map(A(4), A(5), aux(2));
	U_b67: nor2 generic map(0.6 ns) port map(A(6), A(7), aux(3));
	U_b89: nor2 generic map(0.6 ns) port map(A(8), A(9), aux(4));
	result: and5 generic map(2 ns) port map(aux, S);
end nor10;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta XOR de 2 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;

entity xor2 is
  generic (prop : time := 0.5 ns);
  port(A, B : in std_logic;  -- entradas A,B,C
       S    : out std_logic);  -- saída S 
end xor2;

architecture xor2 of xor2 is 
begin
    S <= A xor B after prop;
end xor2;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta AND de 10 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity and10 is
  port(A : reg10;  
       S : out std_logic); 
end and10;

architecture and10 of and10 is 
	component and2 is generic (prop:time);
		port(A, B : in std_logic;  
	         S    : out std_logic);
	end component and2;

	component and5 is generic (prop:time);
		  port(vector : in reg5;
		   	   		S : out std_logic); 
	end component and5;

	signal aux: reg5;
begin
	U_b01: and2 generic map(0.6 ns) port map( A(0), A(1), aux(0) );
	U_b23: and2 generic map(0.6 ns) port map( A(2), A(3), aux(1) );
	U_b45: and2 generic map(0.6 ns) port map( A(4), A(5), aux(2) );
	U_b67: and2 generic map(0.6 ns) port map( A(6), A(7), aux(3) );
	U_b89: and2 generic map(0.6 ns) port map( A(8), A(9), aux(4) );
	result: and5 generic map(2 ns) port map(aux, S);
end and10;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta AND de 10 entradas FUNCIONAL
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity and10 is
  port(A : reg10;  
       S : out std_logic); 
end and10;

architecture funcional of and10 is 
	signal aux: reg5;
begin
	U_b01: aux(0) <= A(0) and A(1) after 0.6 ns;
	U_b23: aux(1) <= A(2) and A(3) after 0.6 ns;
	U_b45: aux(2) <= A(4) and A(5) after 0.6 ns;
	U_b67: aux(3) <= A(6) and A(7) after 0.6 ns;
	U_b89: aux(4) <= A(8) and A(8) after 0.6 ns;
	result: S <= aux(0) and aux(1) and aux(2) and aux(3) and aux(4) after 2 ns;
end funcional;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- comparador de 1 bit
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;

entity compareBit is
  port(bitA, bitB : in std_logic;  -- entradas A,B,C
       bitS    : out std_logic);  -- saída S 
end compareBit;

architecture compareBit of compareBit is 
	component xor2 is generic (prop:time);
		  port(A, B : in std_logic;  -- entradas A,B,C
			   S    : out std_logic);  -- saída S 
	end component xor2;
	signal aux: std_logic;
begin
	U_xor:	xor2 generic map ( 0.5 ns ) port map (bitA, bitB, aux);
	bitS <= not aux;
end compareBit;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- comparador de 10 bits
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity compare10 is
  port(A, B : in reg10;  -- entradas A,Bestrutural em 
       S    : out std_logic;
	   aux	: out reg10);  -- saída S 
end compare10;

architecture estrutural of compare10 is 
	component compareBit is
		  port(bitA, bitB : in std_logic;
			   bitS    : out std_logic);
	end component compareBit;

	component and10 is
		port(A : in reg10;
		   	 S : out std_logic);
	end component and10;

	signal v_out: reg10;
begin
	U_b0: compareBit port map(A(0), B(0), v_out(0));
	U_b1: compareBit port map(A(1), B(1), v_out(1));
	U_b2: compareBit port map(A(2), B(2), v_out(2));
	U_b3: compareBit port map(A(3), B(3), v_out(3));
	U_b4: compareBit port map(A(4), B(4), v_out(4));
	U_b5: compareBit port map(A(5), B(5), v_out(5));
	U_b6: compareBit port map(A(6), B(6), v_out(6));
	U_b7: compareBit port map(A(7), B(7), v_out(7));
	U_b8: compareBit port map(A(8), B(8), v_out(8));
	U_b9: compareBit port map(A(9), B(9), v_out(9));
	aux <= v_out;	
	result: and10 port map(v_out, S);
end estrutural;

