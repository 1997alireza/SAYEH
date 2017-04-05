library IEEE;
use IEEE.std_logic_1164.all;

entity flags is
  port(
    clk, Cin, Zin, CSet, CReset, ZSet, ZReset, SRload : in STD_LOGIC;
    Cout, Zout : out STD_LOGIC
  );
end entity;
architecture behavioral of flags is
  component reg is
    port(
      clk, load, set, reset : in STD_LOGIC;
      input : in STD_LOGIC;
      output : out STD_LOGIC := '0'
    );
  end component;
begin
  c : component reg port map (clk, SRload, CSet, CReset, Cin, Cout);
  z : component reg port map (clk, SRload, ZSet, ZReset, Zin, Zout);
end architecture;
