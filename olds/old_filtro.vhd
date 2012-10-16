-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, ci312,ci702 2012-1 trabalho semestral, autor: Roberto Hexsel, 26set
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- definicao do modulo filtro
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library ieee; use ieee.std_logic_1164.all;
use work.p_WIRES.all;
use work.p_MATRIZ.all;
entity filtro is
  generic (CIRC_LATENCY: time := 20 ns);
  port(rel,rst,ld,en: in std_logic;
       --outros sinais
       lin,col: in integer);             -- dimensoes das matrizes
end filtro;

architecture estrutural of filtro is
begin
  --comandos e processos
end estrutural;
