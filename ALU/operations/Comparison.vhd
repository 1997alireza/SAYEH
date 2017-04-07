library IEEE;
use IEEE.std_logic_1164.all;

entity CMP is
port (
    Rs, Rd: in std_logic_vector (15 downto 0);
    c, z: out STD_LOGIC   -- to cIn and zIn
  );
end entity;

architecture CMP_ARCH of CMP is 
begin
  z <= '1' when Rs = Rd else '0';
  c <= '1' when Rd < Rs else '0';  
end architecture;





