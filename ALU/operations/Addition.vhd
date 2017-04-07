library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADD is
port (
    Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0);   -- to Rd
    c: out STD_LOGIC                              -- to Cin
  );
end entity;

architecture ADD_ARCH of ADD is 
signal res : STD_LOGIC_VECTOR (16 downto 0);
begin
  res <= std_logic_vector( unsigned(('0' & Rs)) + unsigned(('0' & Rd)) );
  c <= res(16);
  output <= res(15 downto 0);
end architecture;




