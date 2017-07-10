library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DataArray is -- for each ways in cache
    port (
        clk : in std_logic;
        index : in std_logic_vector(5 downto 0);
        writeEnable : in std_logic;
        dataIn : in std_logic_vector(15 downto 0);
        dataOut : out std_logic_vector(15 downto 0)
    );
end entity;

architecture DataArray_ARCH of DataArray is
    type reg16_64 is array (0 to 63) of std_logic_vector(15 downto 0);
    signal data : reg16_64 := (others => (others => '0'));

begin   
    process (clk)
    begin
        if(clk'event and clk = '1') then
            dataOut <= data(to_integer(unsigned (index)));
            if(writeEnable = '1') then
            data(to_integer(unsigned (index))) <= dataIn;
            end if;
        end if;
    end process;
end architecture;