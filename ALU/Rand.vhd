library IEEE;
use IEEE.std_logic_1164.all;

entity Rand is
port (
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture Rand_ARCH of Rand is 
signal reg : STD_LOGIC_VECTOR (15 downto 0) := "1011010011000100";
signal inBit : STD_LOGIC := '0';
begin
  output <= reg;
  
  inBit <= reg(10) xor reg(12) xor reg(13) xor reg(15) after 10ns;
  reg <= reg(14 downto 0) & inBit after 10ns;   
    
end architecture;





