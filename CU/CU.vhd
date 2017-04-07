library IEEE;
use IEEE.std_logic_1164.all;

entity CU is
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
		  shadow 
		        : out STD_LOGIC;
		            
		);

end entity;

architecture CU_ARCH of CU is 
begin
  
end architecture;




