library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux is
  port (
    in0  : in  std_logic;
    in1  : in  std_logic;
    sel  : in  std_logic;
    out0 : out std_logic);
end entity mux;

architecture rtl of mux is
begin
  out0 <= in0 when (sel = '0') else in1;
end architecture rtl;