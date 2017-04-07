library IEEE;
use IEEE.std_logic_1164.all;

entity andGate is
port (
    Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture andGate_ARCH of andGate is 
begin
  bitLoop : for i in 15 downto 0 generate
    output(i) <= Rs(i) and Rd(i);
  end generate;
end architecture;



