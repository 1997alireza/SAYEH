
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registerFile is
  port (
    clk, RFLwrite, RFHwrite : in STD_LOGIC;
    WP : in STD_LOGIC_VECTOR(5 downto 0);
    LA : in STD_LOGIC_VECTOR(3 downto 0); -- Local Address : [1,0]=Rs.Ad , [3,2]=Rd.Ad     -> take from IR
    inputData : in STD_LOGIC_VECTOR(15 downto 0); -- take from dataBus
    left, right : out STD_LOGIC_VECTOR(15 downto 0) -- left -> Rd, right -> Rs
  );
end entity;
architecture behavioral of registerFile is
  type reg_64n16b is array (0 to 63) of STD_LOGIC_VECTOR(15 downto 0);
  signal data : reg_64n16b;
begin
  right <= data(to_integer(unsigned(WP) + unsigned(LA(1 downto 0))));
  left <= data(to_integer(unsigned(WP) + unsigned(LA(3 downto 2))));
  
  process(clk)
  begin
    if(clk = '1') then
      if(RFLwrite = '1') then
        data(to_integer(unsigned(WP) + unsigned(LA(3 downto 2)))) (7 downto 0) <= inputData (7 downto 0);
      end if;
      if(RFHwrite = '1') then
        data(to_integer(unsigned(WP) + unsigned(LA(3 downto 2)))) (15 downto 8) <= inputData (15 downto 8);
      end if;
  
    end if;
    
  end process;  
  
end architecture;
    
 
