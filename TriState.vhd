library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity triState is
	generic(
		DATA_LENGTH   : integer        -- size of input and output
	       );
	port(
		   input : in STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0);
		   en : in STD_LOGIC := '0';
		   output : out STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0)
		);
end entity;

architecture triState_ARCH of triState is
begin
	output <= input when en = '1' else
	          (OTHERS => 'Z');
end architecture;


