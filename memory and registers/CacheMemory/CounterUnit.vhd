library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity CounterUnit is
    port (
        clk : in std_logic;
        resetAll : in std_logic;
        index : in std_logic_vector(5 downto 0);
        reset : in std_logic;
        increment : in std_logic;
        counterOut : out std_logic_vector(7 downto 0)
    );
end entity;

architecture CounterUnit_ARCH of CounterUnit is
    type reg8_64 is array (0 to 63) of std_logic_vector(7 downto 0);
    signal counter : reg8_64 := (others => (others => '0'));
begin
    process (clk)
        begin
        counterOut <= counter(to_integer(unsigned (index)));
        if(clk'event and clk = '1') then
            if(resetAll = '1') then
                counter <=  (others => (others => '0'));
            elsif(reset = '1') then
                counter(to_integer(unsigned (index))) <= (OTHERS => '0');
            elsif(increment = '1') then
                counter(to_integer(unsigned (index))) <= std_logic_vector(unsigned(counter(to_integer(unsigned (index)))) + 1);
            end if;
        end if;
    end process;
end architecture;