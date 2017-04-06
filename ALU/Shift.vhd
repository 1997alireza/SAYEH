library IEEE;
use IEEE.std_logic_1164.all;

-- Shift right --
entity SHR is
port (
    Rs: in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture SHR_ARCH of SHR is 
begin
  output <= '0' & Rs(15 downto 1);
end architecture;


library IEEE;
use IEEE.std_logic_1164.all;

-- Shift left --
entity SHL is
port (
    Rs: in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture SHL_ARCH of SHL is 
begin
  output <= Rs(14 downto 0) & '0';
end architecture;






