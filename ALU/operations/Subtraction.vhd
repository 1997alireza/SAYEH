library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SUB is
port (
    Rs, Rd : in STD_LOGIC_VECTOR (15 downto 0);
    c : in STD_LOGIC;                             -- from Cout
    output : out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture SUB_ARCH of SUB is
  signal res : STD_LOGIC_VECTOR(16 downto 0);
begin
  res <= std_logic_vector( unsigned(Rd) - unsigned(Rs) - "000000000000000" & c );
  output <= res(15 downto 0);
end architecture;





