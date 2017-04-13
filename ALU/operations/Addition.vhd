library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADD is
port (
    Rs, Rd : in STD_LOGIC_VECTOR (15 downto 0);
    c : in STD_LOGIC;                             -- from Cout
    output : out STD_LOGIC_VECTOR (15 downto 0);  -- to Rd
    carry : out STD_LOGIC;                        -- to Cin
    zero : out STD_LOGIC                          -- to Zin
  );
end entity;

architecture ADD_ARCH of ADD is 
signal res : STD_LOGIC_VECTOR (16 downto 0);
signal cVector : STD_LOGIC_VECTOR (15 downto 0);
begin
  cVector <= "000000000000000" & c;
  res <= std_logic_vector( unsigned(('0' & Rs)) + unsigned(('0' & Rd)) + unsigned(cVector) );
  carry <= res(16);
  output <= res(15 downto 0);
  with res(15 downto 0) select zero <=
       '1'  when (OTHERS => '0'),
       '0'  when OTHERS;
end architecture;




