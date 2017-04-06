library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_test is
end entity;

architecture arch of mux_test is
  signal input1 : STD_LOGIC_VECTOR(3 downto 0);
  signal input2 : STD_LOGIC_VECTOR(3 downto 0);
  signal output : STD_LOGIC_VECTOR(3 downto 0);
  signal s : STD_LOGIC;
  component mux is
    generic(
		  DATA_LENGTH   : integer := 4
	       );
	  port(
		   input1 : in STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0);
		   input2 : in STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0);
		   selct : in STD_LOGIC := '0';
		   output : out STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0)
		);
	end component;
  begin
    m : mux port map(input1, input2, s, output);
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity triState_test is
end entity;

architecture arch of triState_test is
  signal input : STD_LOGIC_VECTOR(3 downto 0);
  signal output : STD_LOGIC_VECTOR(3 downto 0);
  signal e : STD_LOGIC;
  component triState is
    generic(
		  DATA_LENGTH   : integer := 4
	       );
	  port(
		   input : in STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0);
		   en : in STD_LOGIC := '0';
		   output : out STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0)
		);
	end component;
  begin
    ts : triState port map(input, e, output);
end architecture;
