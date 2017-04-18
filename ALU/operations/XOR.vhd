library IEEE;
use IEEE.std_logic_1164.all;

entity xorGate is
port (
    Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
    output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
  );
end entity;

architecture xorGate_ARCH of xorGate is 
  component xorSingleGate is
  port(
    input1, input2 : in STD_LOGIC;
    output : out STD_LOGIC
  );
  end component;
begin
  bitLoop : for i in 15 downto 0 generate
    xorBitI : xorSingleGate port map (Rs(i), Rd(i), output(i));
  end generate;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;

entity xorSingleGate is
port(
  input1, input2 : in STD_LOGIC;
  output : out STD_LOGIC
);
end entity;

architecture xorSingleGate_ARCH of xorSingleGate is
begin
  output <= (input1 and not input2) or (not input1 and input2);
end architecture;
  




