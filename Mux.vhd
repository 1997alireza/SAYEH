library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux is
	generic(
		DATA_LENGTH   : integer        -- size of inputs and output
	       );
	port(
		   input1 : in STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0);
		   input2 : in STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0);
		   selct : in STD_LOGIC := '0';
		   output : out STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0)
		);
end entity;

architecture MUX_ARCH of mux is
begin
	output <= input1 when selct = '0' else
	          input2;
end architecture;
