library IEEE;
use IEEE.std_logic_1164.all;

entity Rand_test is
end entity;

architecture arch of Rand_test is
  signal output : STD_LOGIC_VECTOR(15 downto 0);
  component Rand is
	  port (
    output: out STD_LOGIC_VECTOR (15 downto 0)
  );
	end component;
  begin
    randCom : Rand port map (output);
end architecture;

