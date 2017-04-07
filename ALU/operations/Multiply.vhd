library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUL is
port (
    Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture MUL_ARCH of MUL is 

begin
  output <= std_logic_vector( unsigned(Rs(7 downto 0)) * unsigned(Rd(7 downto 0)) );
end architecture;






