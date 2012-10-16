-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Seguimento armazena valores do NORTE, SUL, LESTE e ATUAL em registradores
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
use work.p_wires.all;

entity seg1 is
    port(clk, rst, ld : in  std_logic;
         v_norte      : in  reg8;
         v_sul        : in  reg8;
         v_leste      : in  reg8;
         v_atual      : in  reg8;
         reg_norte12  : out reg12;
         reg_sul12    : out reg12;
         reg_leste12  : out reg12;
         reg_atual12  : out reg12);
end seg1;

architecture estrutural of seg1 is
    component ext8to12 is
		port(input  : in  reg8;
			 output : out reg12);
    end component ext8to12;

	component register12 is
		generic (CNT_LATENCY:time);
		port(rel, rst, ld: in  std_logic;
			 D:           in  reg12;
			 Q:           out reg12);
	end component register12;

	signal aux_norte, out_norte : reg12;
	signal aux_sul, out_sul : reg12;
	signal aux_leste, out_leste : reg12;
	signal aux_atual, out_atual : reg12;

begin

	U_ext_norte	: ext8to12 port map(v_norte, aux_norte);
	U_ext_sul	: ext8to12 port map(v_sul, 	 aux_sul);
	U_ext_leste	: ext8to12 port map(v_leste, aux_leste);
	U_ext_atual	: ext8to12 port map(v_atual, aux_atual);

	U_reg_norte : register12 generic map(3 ns)
  		   					 port map(clk, rst, ld, aux_norte, reg_norte12);

	U_reg_sul : register12 generic map(3 ns) 
						   port map(clk, rst, ld, aux_sul, reg_sul12);

	U_reg_leste : register12 generic map(3 ns)
							 port map(clk, rst, ld, aux_leste, reg_leste12);

	U_reg_atual : register12 generic map(3 ns)
							 port map(clk, rst, ld, aux_atual, reg_atual12);

end estrutural;
