library IEEE;
use IEEE.std_logic_1164.all;

entity CU is
		port (
		  clk, ExternalReset, 
		  Cout, Zout,                                              -- flags
		  MemDataReady                                             -- memory
		        : in STD_LOGIC;
		        
		  IRout : in STD_LOGIC_VECTOR(15 downto 0);                -- IR 
		  
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

end entity;

architecture CU_ARCH of CU is 
  type state is (reset, fetch, baseExe, shadowExe, halt);
	signal currentState : state := reset;
	signal nextState : state;
begin
  
  -- state changer
  process (clk, ExternalReset)
	begin
		if ExternalReset = '1' then
			currentState <= reset;
		elsif clk'event and clk = '1' then
			currentState <= nextState;
		end if;
	end process;
	
	-- control signals base on state
 	process (currentState)
	begin
	  
	  -- set defaults
	  CSet <= '0';
    CReset <= '0';
    ZSet <= '0';
    ZReset <= '0';
    SRload <= '0';
    B15to0 <= '0';
    AandB <= '0';
    AorB <= '0';
    AxorB <= '0';
    notB <= '0';
    AcmpB <= '0';
    shrB <= '0';
    shlB <= '0';
    AaddB <= '0';
    AsubB <= '0';
    AmulB <= '0';
    tcmpB <= '0';
    rand <= '0';
    Rs_on_AddressUnitRSide <= '0';
    Rd_on_AddressUnitRSide <= '0';
    ALUout_on_Databus <= '0';
    Address_on_Databus <= '0';
    WPadd <= '0';
    WPreset <= '0';
    IRload <= '0';
    ResetPC <= '0';
    EnablePC <= '0';
    PCplusI <= '0';
    PCplus1 <= '0';
    RplusI <= '0';
    Rplus0 <= '0';
    RFLwrite <= '0';
    RFHwrite <= '0';
    readMem <= '0';
    writeMem <= '0';
    shadow <= '0';
    
    
		case currentState is
		  when halt =>
		    nextState <= halt;
			when reset =>
			  CReset <= '1';
			  ZReset <= '1';
			  WPreset <= '1';
			  ResetPC <= '1';
			  EnablePC <= '1';
			  
  
			  nextState <= fetch;
			  
			when fetch =>
			  readMem <= '1';
			  
			  if(memDataReady = '1') then
			    IRload <= '1';
			    nextState <= baseExe;
			  else
			    nextState <= fetch;
			  end if;
			when baseExe =>
			  
			  
			when shadowExe =>
			  
			when OTHERS =>
			  nextState <= reset;
			  
		end case;
	end process;
  
end architecture;




