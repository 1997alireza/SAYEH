library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity MissHitLogic is
    port (
        tag : in std_logic_vector(3 downto 0);
        validTag0 : in std_logic_vector(4 downto 0);
        validTag1 : in std_logic_vector(4 downto 0);
        hit : out std_logic;
        match1_notMatch0 : out std_logic
    );
end entity;

architecture MissHitLogic_ARCH of MissHitLogic is

begin
    process(tag, validTag0, validTag1) begin
        if(validTag0(3 downto 0) = tag and validTag0(4) = '1') then
            hit <= '1';
            match1_notMatch0 <= '0';
        elsif(validTag1(3 downto 0) = tag and validTag1(4) = '1') then
            hit <= '1';
            match1_notMatch0 <= '1';
        else
            hit <= '0';
        end if;
    end process;
end architecture;