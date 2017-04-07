library IEEE;
use IEEE.std_logic_1164.all;

entity xorGate is
port (
    Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture xorGate_ARCH of xorGate is 
begin
  bitLoop : for i in 15 downto 0 generate
    output(i) <= Rs(i) xor Rd(i);
  end generate;
end architecture;





