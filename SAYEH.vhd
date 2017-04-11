library IEEE;
use IEEE.std_logic_1164.all;

entity SAYEH is
port (
    externalReset, clk : in STD_LOGIC
  );
end entity;

architecture SAYEH_ARCH of SAYEH is 
	component memory is
		generic (blocksize : integer := 1024);

		port (clk, readmem, writemem : in std_logic;
			addressbus: in std_logic_vector (15 downto 0);
			databus : inout std_logic_vector (15 downto 0);
			memdataready : out std_logic);
	end component;
	
	
	component addressUnit is
	  port (
		  Rside : in std_logic_vector (15 downto 0);
		  Iside : in std_logic_vector (7 downto 0);
		  Address : out std_logic_vector (15 downto 0);
		  clk, ResetPC, PCplusI, PCplus1 : in std_logic;
		  RplusI, Rplus0, EnablePC : in std_logic
	  );
	end component;
	
	component reg16b is
	  port(clk, load, reset : in STD_LOGIC;
		  input : in STD_LOGIC_VECTOR (15 downto 0);
		  output : out STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000"
	  );
	end component;
	
	component mux is
		generic(
			DATA_LENGTH   : integer := 1       -- size of inputs and output
			   );
		port(
			   input1 : in STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0);
			   input2 : in STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0);
			   selct : in STD_LOGIC := '0';
			   output : out STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0)
			);
	end component;
	
	component WP is
	  port(
		  clk, WPadd, WPreset : in STD_LOGIC;
		  input : in STD_LOGIC_VECTOR (5 downto 0);
		  output : out STD_LOGIC_VECTOR (5 downto 0)
	  );
	end component;
	
	component registerFile is
	  port (
		  clk, RFLwrite, RFHwrite : in STD_LOGIC;
		  WP : in STD_LOGIC_VECTOR(5 downto 0);
		  LA : in STD_LOGIC_VECTOR(3 downto 0); -- Local Address : [1,0]=Rs.Ad , [3,2]=Rd.Ad     -> take from IR
		  inputData : in STD_LOGIC_VECTOR(15 downto 0); -- take from dataBus  -- load on Rd
		  left, right : out STD_LOGIC_VECTOR(15 downto 0) -- left -> Rd, right -> Rs
	  );
	end component;
	
	
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
		  B15to0, AandB, AorB, AxorB, notB, AcmpB, shrB, shlB, AaddB, AsubB, 
				AmulB, tcmpB, rand : in STD_LOGIC
	  );
	end component;
	
  component triState is
		generic(
			DATA_LENGTH   : integer := 1       -- size of input and output
			   );
		port(
			   input : in STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0);
			   en : in STD_LOGIC := '0';
			   output : out STD_LOGIC_VECTOR (DATA_LENGTH - 1 downto 0)
			);
	end component;
	
	component CU is
		port (
		  clk, ExternalReset, 
		  Cout, Zout,                                              -- flags
		  MemDataReady                                             -- memory
		        : in STD_LOGIC;
		        
		  IRout : out STD_LOGIC_VECTOR(15 downto 0);               -- IR 
		  
		  CSet, CReset, ZSet, ZReset, SRload,                      -- flags
		  B15to0, AandB, AorB, AxorB, notB, AcmpB, shrB,
		      shlB, AaddB, AsubB, AmulB, tcmpB, rand,              -- ALU  
		  Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide,          -- Address Unit RSide Bus
		  ALUout_on_Databus, Address_on_Databus,                   -- Data Bus
		  WPadd, WPreset,                                          -- WP
		  IRload,                                                  -- IR
		  ResetPC, EnablePC, PCplusI, PCplus1, RplusI, Rplus0,     -- Address Unit
		  RFLwrite, RFHwrite,                                      -- register file
		  readMem, writeMem,                                       -- memory
		  shadow 
		        : out STD_LOGIC
		            
		);

  end component;
	
	signal readMem, writeMem, memDataReady : STD_LOGIC;
	signal dataBus, addressBus, addressUnitRSideBus : STD_LOGIC_VECTOR(15 downto 0);
	
	signal resetPC, PCplusI, PCplus1, RplusI, Rplus0, enablePC : STD_LOGIC;
	signal IRout : STD_LOGIC_VECTOR(15 downto 0);
	signal IRload : STD_LOGIC;
	
	signal shadow : STD_LOGIC;
	
	signal registerSelection : STD_LOGIC_VECTOR(3 downto 0);
	
	signal WPadd, WPreset : STD_LOGIC;
	signal WPout : STD_LOGIC_VECTOR (5 downto 0);
	
	signal RFLwrite, RFHwrite : STD_LOGIC;
	signal Rs, Rd : STD_LOGIC_VECTOR(15 downto 0);
	
	signal Cin, Zin, CSet, CReset, ZSet, ZReset, SRload, Cout, Zout : STD_LOGIC;
	
	signal B15to0, AandB, AorB, AxorB, notB, AcmpB, shrB, shlB, AaddB, AsubB, 
            AmulB, tcmpB, rand : STD_LOGIC;
  signal ALUout : STD_LOGIC_VECTOR(15 downto 0);
  
  signal ALUout_on_DataBus, Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, Address_on_DataBus : STD_LOGIC;
	
	
begin
  M : memory port map (clk, readMem, writeMem, addressBus, dataBus, memDataReady);
  AU : addressUnit port map (addressUnitRSideBus, IRout(7 downto 0), addressBus, clk, 
                        resetPC, PCplusI, PCplus1, RplusI, Rplus0, enablePC);
  IR : reg16b port map(clk, IRload, '0',  dataBus, IRout);
  addreessSelection : mux generic map(4)
                          port map(IRout(11 downto 8), IRout(3 downto 0), shadow, registerSelection);
  WPComp : WP port map (clk, WPadd, WPreset, IRout(5 downto 0), WPout);
	RF : registerFile port map (clk, RFLwrite, RFHwrite, WPout, registerSelection, dataBus, Rd, Rs);
	F : flags port map (clk, Cin, Zin, CSet, CReset, ZSet, ZReset, SRload, Cout, Zout);
	ALUComp : ALU port map(Rs, Rd, Cout, Zout, Cin, Zin, ALUout, B15to0, AandB, AorB, AxorB, notB, AcmpB, shrB, shlB, AaddB, AsubB, 
				AmulB, tcmpB, rand); 
	
	ALUoutOnDataBusTriState : triState generic map(16)
	                                   port map(ALUout, ALUout_on_DataBus, dataBus);
	                           
	RsOnAddressUnitRSideTriState : triState generic map(16)
	                                        port map(Rs, Rs_on_AddressUnitRSide, addressUnitRSideBus);
	RdOnAddressUnitRSideTriState : triState generic map(16)
	                                        port map(Rd, Rd_on_AddressUnitRSide, addressUnitRSideBus);
				
  AddressOnDataBusTriState : triState generic map(16)
                                      port map(addressBus, Address_on_DataBus, dataBus);
                                        
                                        
  CUComp : CU port map ( 
              clk, externalReset, Cout, Zout, 
              memDataReady, IRout, 
              Cset, CReset, ZSet, ZReset, SRload,
              B15to0, AandB, AorB, AxorB, notB, AcmpB, shrB, shlB, AaddB, AsubB, 
				      AmulB, tcmpB, rand,
				      Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide,
				      ALUout_on_DataBus, Address_on_DataBus,
				      WPadd, WPreset,
				      IRload,
				      resetPC, enablePC, PCplusI, PCplus1, RplusI, Rplus0, 
				      RFLwrite, RFHwrite,
				      readMem, writeMem,
				      shadow 
				      );
  
  
  
  
  
    
  
  
end architecture;




