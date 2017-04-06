library IEEE;
use IEEE.std_logic_1164.all;

entity CMP is
port (
    Rs, Rd: in std_logic_vector (15 downto 0);
    Cout, Zout: out STD_LOGIC
  );
end entity;

architecture CMP_ARCH of CMP is 
begin
  Zout <= '1' when Rs = Rd else '0';
  Cout <= '1' when Rd < Rs else '0';  
end architecture;





