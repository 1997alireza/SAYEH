library IEEE;
use IEEE.std_logic_1164.all;

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


library IEEE;
use IEEE.std_logic_1164.all;

entity SHL_test is
end entity;

architecture arch of SHL_test is
  signal input : STD_LOGIC_VECTOR(15 downto 0);
  signal output : STD_LOGIC_VECTOR(15 downto 0);
  component SHL is
	  port(
		   Rs : in STD_LOGIC_VECTOR (15 downto 0);
		   output : out STD_LOGIC_VECTOR (15 downto 0)
		);
	end component;
  begin
    shiftL : SHL port map(input, output);
end architecture;


library IEEE;
use IEEE.std_logic_1164.all;

entity reg1_test is
end entity;

architecture arch of reg1_test is
  signal set, output : STD_LOGIC;
  signal clk : STD_LOGIC := '0';
  component reg is
    port(clk, load, set, reset : in STD_LOGIC;
      input : in STD_LOGIC;
      output : out STD_LOGIC := '0'
    );
  end component;
  begin
    regOne : reg port map(clk, '0', set, '0', '0', output);
    clk <= not clk after 50 ns;
    set <= '0', '1' after 10 ns, '0' after 110 ns;
end architecture;


