library IEEE;
use IEEE.std_logic_1164.all;

entity randGen_test is
end entity;

architecture arch of randGen_test is
  signal output : STD_LOGIC_VECTOR(15 downto 0);
  component randGen is
	  port (
    output: out STD_LOGIC_VECTOR (15 downto 0)
  );
	end component;
  begin
    randCom : randGen port map (output);
end architecture;

