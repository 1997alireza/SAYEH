library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Testbench is
end entity;

architecture Testbench_ARCH of Testbench is
    component CacheMem is
        port (
            clk : in std_logic;
            address : in std_logic_vector(9 downto 0);
            data : inout std_logic_vector(15 downto 0);
            write : in std_logic;
            read : in std_logic;
            dataReady : out  std_logic
        );
    end component;

    signal clk, read, write, dataReady : std_logic := '0';
    signal address : std_logic_vector(9 downto 0);
    signal data : std_logic_vector(15 downto 0);

begin
    CMinstance : CacheMem port map (clk, address, data, write, read, dataReady);
    clk <= not clk after 20 ns;
    data <= "0000000000111111", "0101010101010101" after 200 ns, (OTHERS => 'Z') after 420 ns;
    address <= (OTHERS => '0'), "0000000001" after 210 ns, "0000000000" after 410 ns;
    write <= '0', '1' after 10 ns, '0' after 110 ns, '1' after 210 ns, '0' after 410 ns;
    read <= '0', '1' after 420 ns;
end architecture;