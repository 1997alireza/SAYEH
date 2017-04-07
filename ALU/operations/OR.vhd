library IEEE;
use IEEE.std_logic_1164.all;

entity orGate is
port (
    Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture orGate_ARCH of orGate is 
begin
  bitLoop : for i in 15 downto 0 generate
    output(i) <= Rs(i) or Rd(i);
  end generate;
end architecture;




