library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
port (
    Rs, Rd : in STD_LOGIC_VECTOR(15 downto 0);    -- Rd = A , Rs = B
    Cout, Zout : in STD_LOGIC;
    Cin, Zin : out STD_LOGIC;
    output : out STD_LOGIC_VECTOR(15 downto 0);   -- to Rd
    B15to0, AandB, AorB, AxorB, notB, AcmpB, shrB, shlB, AaddB, AsubB, AmulB, tcmpB, rand : in STD_LOGIC   -- number = 12 + 1 (AcmpB haven't access to output)
  );
end entity;

architecture ALU_ARCH of ALU is 
	component andGate is
	port (
		Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
		output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;

	component orGate is
	port (
		Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
		output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;

	component xorGate is
	port (
		Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
		output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;

	component invert is
	port (
		Rs : in STD_LOGIC_VECTOR (15 downto 0);
		output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;

	component CMP is
	port (
    Rs, Rd: in std_logic_vector (15 downto 0);
    c, z: out STD_LOGIC                          -- to cIn and zIn
  );
	end component;

	component SHR is
	port (
		Rs: in STD_LOGIC_VECTOR (15 downto 0);
		output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;

	component SHL is
	port (
		Rs: in STD_LOGIC_VECTOR (15 downto 0);
		output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;


	component ADD is
	port (
		Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
		output: out STD_LOGIC_VECTOR (15 downto 0);   -- to Rd
		c: out STD_LOGIC                              -- to Cin
	  );
	end component;

	component SUB is
	port (
		Rs, Rd : in STD_LOGIC_VECTOR (15 downto 0);
		c : in STD_LOGIC;                             -- from Cout
		output : out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;

	component MUL is
	port (
		Rs, Rd: in STD_LOGIC_VECTOR (15 downto 0);
		output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;

	component twosComp is
	port (
		Rs: in STD_LOGIC_VECTOR (15 downto 0);
		output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;

	component randGen is
	port (
		output: out STD_LOGIC_VECTOR (15 downto 0)   -- to Rd
	  );
	end component;


  signal and_OUT, or_OUT, xor_OUT, invert_OUT, shr_OUT, shl_OUT, add_OUT, sub_OUT,
             mul_OUT, tcmp_OUT, rand_OUT : STD_LOGIC_VECTOR(15 downto 0);             -- to output
             
  signal add_CARRY, cmp_CARRY, cmp_ZERO : STD_LOGIC;                                  -- to cIn and zIn
  
  signal selection : STD_LOGIC_VECTOR(11 downto 0);
  
begin
  
  selection <= B15to0 & AandB & AorB & AxorB & notB & shrB & shlB & AaddB & AsubB & AmulB & tcmpB & rand;
  
  and_Gate : andGate port map (Rs, Rd, and_OUT);
  or_Gate : orGate port map (Rs, Rd, or_OUT);
  xor_Gate : xorGate port map (Rs, Rd, xor_OUT);
  inverter : invert port map (Rs, invert_OUT);
  comparator : CMP port map (Rs, Rd, cmp_CARRY, cmp_ZERO);
  shiftRight : SHR port map (Rs, shr_OUT);
  shiftLeft : SHL port map (Rs, shl_OUT);
  addition : ADD port map (Rs, Rd, add_OUT, add_CARRY);
  subtraction : SUB port map (Rs, Rd, Cout, sub_OUT);
  multiply : MUL port map (Rs, Rd, mul_OUT);
  twosComplement : twosComp port map (Rs, tcmp_OUT);
  randomNumber : randGen port map (rand_OUT);
    
    
  cIn <= add_CARRY when AaddB = '1' else
         cmp_CARRY when AcmpB = '1' else
         '0';   -- in this state SRload is zero
         
  zIn <= cmp_ZERO when AcmpB = '1' else
         '0';   -- in this state SRload is zero 
  
  with selection select output <= 
       Rs                when "100000000000",
       and_OUT           when "010000000000",
       or_OUT            when "001000000000",
       xor_OUT           when "000100000000",
       invert_OUT        when "000010000000",
       shr_OUT           when "000001000000",
       shl_OUT           when "000000100000",
       add_OUT           when "000000010000",
       sub_OUT           when "000000001000",
       mul_OUT           when "000000000100",
       tcmp_OUT          when "000000000010",
       rand_OUT          when "000000000001",
       (OTHERS => '1')   when OTHERS;   -- shouldn't happen this
         
  
  
  
  
end architecture;




