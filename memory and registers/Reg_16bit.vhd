library IEEE;
use IEEE.std_logic_1164.all;

entity reg16b is
  port(clk, load, reset : in STD_LOGIC;
    input : in STD_LOGIC_VECTOR (15 downto 0);
    output : out STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000"
  );
end entity;
architecture reg16b_ARCH of reg16b is
begin
  process(clk)
  begin
    if(clk = '1') then
      if(reset = '1') then
        output <= "0000000000000000";
      elsif(load = '1') then
        output <= input;  
        
      end if;
    end if;
  end process;
end architecture;
