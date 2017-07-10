library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ReplacementLogic is
    port (
        valid0 : in std_logic;
        valid1 : in std_logic;
        counter0 : in std_logic_vector(7 downto 0);
        counter1 : in std_logic_vector(7 downto 0);
        replace0_notReplace1 : out std_logic
    );
end entity;

architecture ReplacementLogic_ARCH of ReplacementLogic is

begin
    process(valid0, valid1, counter0, counter1) begin
        if(valid0 = '0') then
            replace0_notReplace1 <= '1';
        elsif(valid1 = '0') then
            replace0_notReplace1 <= '0';
        else
            if(to_integer(unsigned(counter0)) >= to_integer(unsigned(counter1))) then
                replace0_notReplace1 <= '1';
            else
                replace0_notReplace1 <= '0';
            end if;
        end if;
    end process;
end architecture;