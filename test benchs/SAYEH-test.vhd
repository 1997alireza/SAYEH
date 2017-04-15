library IEEE;
use IEEE.std_logic_1164.all;

entity SAYEH_test is
end entity;

architecture arch of SAYEH_test is
  signal res : STD_LOGIC := '0';
  signal clk : STD_LOGIC := '0';
  component SAYEH is
    port (
      externalReset, clk : in STD_LOGIC
    );
  end component;
  begin
    computer : SAYEH port map(res, clk);
      
    clk <= not clk after 50 ns;
    res <= '0', '1' after 10 ns, '0' after 110 ns;
end architecture;
