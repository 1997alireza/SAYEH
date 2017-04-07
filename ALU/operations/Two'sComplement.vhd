library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity twosComp is
port (
    Rs: in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture twosComp_ARCH of twosComp is 
component invert is 
  port (
    Rs : in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)
  );
end component;
signal RsInvert : STD_LOGIC_VECTOR(15 downto 0);
begin
  inverter : invert port map (Rs, RsInvert);
  output <= std_logic_vector( unsigned(RsInvert) + "0000000000000001" );
end architecture;




