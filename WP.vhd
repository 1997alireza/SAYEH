library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--- a 6 bit register
entity WP is
  port(
    clk, WPadd, WPreset : in STD_LOGIC;
    input : in STD_LOGIC_VECTOR (5 downto 0);
    output : out STD_LOGIC_VECTOR (5 downto 0)
  );
end entity;
architecture behavioral of WP is
  signal s : STD_LOGIC_VECTOR(5 downto 0) := "000000" ;
begin
  output <= s;
  process(clk)
  begin
    if(clk = '1') then
      if(WPreset = '1') then
        s <= "000000";
      elsif (WPadd = '1') then
        s <= std_logic_vector(unsigned(s) + unsigned(input));
      end if;
    end if;
  end process;
  
end architecture;

