library IEEE;
use IEEE.std_logic_1164.all;

entity invert is
port (
    Rs : in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture invert_ARCH of invert is 
begin
  bitLoop : for i in 15 downto 0 generate
    output(i) <= not Rs(i);
  end generate;
end architecture;





