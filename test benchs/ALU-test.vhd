library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_test is
end entity;

architecture arch of ALU_test is
  component flags is
    port(
      clk, Cin, Zin, CSet, CReset, ZSet, ZReset, SRload : in STD_LOGIC;
      Cout, Zout : out STD_LOGIC
    );
  end component;
  component ALU is
    port (
      Rs, Rd : in STD_LOGIC_VECTOR(15 downto 0);    -- Rd = A , Rs = B
      Cout, Zout : in STD_LOGIC;
      Cin, Zin : out STD_LOGIC;
      output : out STD_LOGIC_VECTOR(15 downto 0);   -- to Rd
      B15to0, AandB, AorB, AxorB, notB, AcmpB, shrB, shlB, AaddB, AsubB, AmulB, tcmpB, rand : in STD_LOGIC 
    );
  end component;
  
  signal clk : STD_LOGIC := '0';
  signal Rs: STD_LOGIC_VECTOR(15 downto 0) := "0000011001011000";
  signal Rd: STD_LOGIC_VECTOR(15 downto 0) := "1000011001011000";
  signal Cin, Zin, Cout, Zout : STD_LOGIC;
  signal CReset : STD_LOGIC;
  signal output : STD_LOGIC_VECTOR(15 downto 0);
  signal ONE : STD_LOGIC := '1';
  signal ZERO : STD_LOGIC := '0';
	
  
  begin
    clk <= not clk after 50 ns;
    CReset <= '1' after 10 ns, '0' after 110 ns;
    CZFlags : flags port map(clk, Cin, Zin, ZERO, CReset, ZERO, ZERO, ZERO, Cout, Zout);
    aluComp : ALU port map (Rs, Rd, Cout, Zout, Cin, Zin, output, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ONE, ZERO, ZERO);
end architecture;



