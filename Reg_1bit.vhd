library IEEE;
use IEEE.std_logic_1164.all;

---- Reg 1bit
entity reg is
  port(clk, load, set, reset : in STD_LOGIC;
    input : in STD_LOGIC;
    output : out STD_LOGIC := '0'
  );
end entity;
architecture behavioral of reg is
begin
  process(clk)
  begin
    if(clk = '1') then
      if(reset = '1') then
        output <= '0';
      elsif(set = '1') then
        output <= '1';
      elsif(load = '1') then
        output <= input;  
        
      end if;
    end if;
  end process;
end architecture;