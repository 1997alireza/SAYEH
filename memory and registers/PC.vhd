library IEEE;
use IEEE.std_logic_1164.all;

entity PC is
port (
    EnablePC : in std_logic;
    input: in std_logic_vector (15 downto 0);
    clk : in std_logic;
    output: out std_logic_vector (15 downto 0)
  );
end entity;

architecture PC_ARCH of PC is begin
  process (clk) begin
    if(clk = '1' and EnablePC = '1') then
      output <= input;
    end if;
  end process;
end architecture;


