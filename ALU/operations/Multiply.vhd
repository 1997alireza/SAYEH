library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUL is
port (
    Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
    output: inout STD_LOGIC_VECTOR (15 downto 0); -- to Rd
    carry : out STD_LOGIC;                        -- to Cin
    zero : out STD_LOGIC                          -- to Zin
  );
end entity;

architecture MUL_ARCH of MUL is 
signal Rs8, Rd8 : STD_LOGIC_VECTOR(7 downto 0);

begin
  Rs8 <= Rs(7 downto 0);
  Rd8 <= Rd(7 downto 0);
  
  -- output <= std_logic_vector( unsigned(Rs(7 downto 0)) * unsigned(Rd(7 downto 0)) );
  process (Rs8, Rd8)
    variable temp : UNSIGNED(15 downto 0) := (OTHERS => '0');
  begin
    temp := (OTHERS => '0');
    for i in 1 to to_integer(unsigned(Rs8)) loop
        temp := temp + unsigned(Rd8);
    end loop;
    
    output <= std_logic_vector(temp);
  end process;
    
    carry <= output(15);
    with output select zero <=
         '1' when (OTHERS => '0'),
         '0' when OTHERS;
end architecture;






