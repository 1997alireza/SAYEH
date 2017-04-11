library IEEE;
use IEEE.std_logic_1164.all;

entity RegisterFile_test is
end entity;

architecture arch of RegisterFile_test is
 
  component registerFile is
    port (
      clk, RFLwrite, RFHwrite : in STD_LOGIC;
      WP : in STD_LOGIC_VECTOR(5 downto 0);
      LA : in STD_LOGIC_VECTOR(3 downto 0); -- Local Address : [1,0]=Rs.Ad , [3,2]=Rd.Ad     -> take from IR
      inputData : in STD_LOGIC_VECTOR(15 downto 0); -- take from dataBus  -- load on Rd
      left, right : out STD_LOGIC_VECTOR(15 downto 0) -- left -> Rd, right -> Rs
    );
  end component;
  
  signal clk : STD_LOGIC := '0';
  signal Rs: STD_LOGIC_VECTOR(15 downto 0);
  signal Rd: STD_LOGIC_VECTOR(15 downto 0);
  signal RFLwrite, RFHwrite : STD_LOGIC;
  signal data : STD_LOGIC_VECTOR(15 downto 0);
  signal WP : STD_LOGIC_VECTOR(5 downto 0);
  signal selection : STD_LOGIC_VECTOR(3 downto 0);
 
	
  
  begin
    RF : registerFile port map (clk, RFLwrite, RFHwrite, WP, selection, data, Rd, Rs);
      
    clk <= not clk after 50 ns;
    data <= "1010101010101010";
    RFLwrite <= '0', '1' after 150 ns, '0' after 250 ns;
    RFHwrite <= '0', '1' after 150 ns, '0' after 250 ns;
    WP <= "000010", "000000" after 250 ns;
    selection <= "0001", "0010" after 250 ns;
end architecture;




