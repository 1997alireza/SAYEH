library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity TagValidArray is
    port (
        clk : in std_logic;
        reset : in std_logic;
        index : in std_logic_vector(5 downto 0);
        writeEnable : in std_logic;
        invalidate : in std_logic; -- it's working when writeEnable = '1'
        tagIn : in std_logic_vector(3 downto 0);
        tagValidOut : out std_logic_vector(4 downto 0)
    );
end entity;

architecture TagValidArray_ARCH of TagValidArray is
    type reg5_64 is array (0 to 63) of std_logic_vector(4 downto 0); 
    signal tag_valid : reg5_64 := (others => (others => '0')); -- for each index : valid(1) + tag(4) = 5bit

begin
    process(clk)
    begin
        if(reset = '1') then
            tag_valid <= (others => (others => '0'));
        elsif(clk'event and clk = '1') then
            tagValidOut <= tag_valid(to_integer(unsigned(index)));
            if(writeEnable = '1') then
                tag_valid(to_integer(unsigned(index)))(3 downto 0) <= tagIn;
                if(invalidate = '0') then
                    tag_valid(to_integer(unsigned(index)))(4) <= '1';
                elsif(invalidate = '1') then
                    tag_valid(to_integer(unsigned(index)))(4) <= '0';
                end if;
            end if;
        end if;
    end process;
end architecture;