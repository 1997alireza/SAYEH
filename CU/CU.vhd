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
  type state is (reset, fetch, baseExe, shadowExe, halt, PCInc);
	signal currentState : state := reset;
	signal nextState : state;
	
	-- 0000-P2 : 8bit
	constant nop_P2  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	constant hlt_P2  : STD_LOGIC_VECTOR(3 downto 0) := "0001";
	constant szf_P2  : STD_LOGIC_VECTOR(3 downto 0) := "0010";
	constant czf_P2  : STD_LOGIC_VECTOR(3 downto 0) := "0011";
	constant scf_P2  : STD_LOGIC_VECTOR(3 downto 0) := "0100";
	constant ccf_P2  : STD_LOGIC_VECTOR(3 downto 0) := "0101";
	constant cwp_P2  : STD_LOGIC_VECTOR(3 downto 0) := "0110";
	
	-- 0000-P2-I : 16bit
	constant jpr_P2  : STD_LOGIC_VECTOR(3 downto 0) := "0111";
	constant brz_P2  : STD_LOGIC_VECTOR(3 downto 0) := "1000";
	constant brc_P2  : STD_LOGIC_VECTOR(3 downto 0) := "1001";
	constant awp_P2  : STD_LOGIC_VECTOR(3 downto 0) := "1010";
	
	
	-- P1-D-S : 8bit
	constant mvr_P1  : STD_LOGIC_VECTOR(3 downto 0) := "0001";
	constant lda_P1  : STD_LOGIC_VECTOR(3 downto 0) := "0010";
	constant sta_P1  : STD_LOGIC_VECTOR(3 downto 0) := "0011";
	constant tcm_P1  : STD_LOGIC_VECTOR(3 downto 0) := "0100";
	constant rnd_P1  : STD_LOGIC_VECTOR(3 downto 0) := "0101";
	constant and_P1  : STD_LOGIC_VECTOR(3 downto 0) := "0110";
	constant orr_P1  : STD_LOGIC_VECTOR(3 downto 0) := "0111";
	constant not_P1  : STD_LOGIC_VECTOR(3 downto 0) := "1000";
	constant shl_P1  : STD_LOGIC_VECTOR(3 downto 0) := "1001";
	constant shr_P1  : STD_LOGIC_VECTOR(3 downto 0) := "1010";
	constant add_P1  : STD_LOGIC_VECTOR(3 downto 0) := "1011";
	constant sub_P1  : STD_LOGIC_VECTOR(3 downto 0) := "1100";
	constant mul_P1  :  STD_LOGIC_VECTOR(3 downto 0) := "1101";
	constant cmp_P1  :  STD_LOGIC_VECTOR(3 downto 0) := "1110";
	
	
	-- 1111-D-P22-I
	constant mil_P22 : STD_LOGIC_VECTOR(1 downto 0) := "00";
	constant mih_P22 : STD_LOGIC_VECTOR(1 downto 0) := "01";
	constant spc_P22 : STD_LOGIC_VECTOR(1 downto 0) := "10";
	constant jpa_P22 : STD_LOGIC_VECTOR(1 downto 0) := "11";
	
	
	
	
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
			  
			  case IRout(15 downto 12) is
			    when "0000" =>
			      case IRout(11 downto 8) is
			        when nop_P2 =>
			          nextState <= shadowExe;
			        when hlt_P2 =>
			          nextState <= halt;
			        when szf_P2 =>
			          ZSet <= '1';
			          nextState <= shadowExe;
			        when czf_P2 =>
			          ZReset <= '1';
			          nextState <= shadowExe;
			        when scf_P2 =>
			          CSet <= '1';
			          nextState <= shadowExe;
			        when ccf_P2 =>
			          CReset <= '1';
			          nextState <= shadowExe;
			        when cwp_P2 =>
			          WPreset <= '1';
			          nextState <= shadowExe;
			        when jpr_P2 =>  -- 16bit
			          PCplusI <= '1';
			          EnablePC <= '1';
			          nextState <= fetch;
			        when brz_P2 =>  -- 16bit
			          if(Zout = '1') then
			            PCplusI <= '1';
			            EnablePC <= '1';
			          else
			            PCplus1 <= '1';
			            EnablePC <= '1';
			          end if;
			          
			          nextState <= fetch;
			        when brc_P2 =>  -- 16bit
			          if(Cout = '1') then
			            PCplusI <= '1';
			            EnablePC <= '1';
			          else
			            PCplus1 <= '1';
			            EnablePC <= '1';
			          end if;
			          
			          nextState <= fetch;
			        when awp_P2 =>  -- 16bit
			          WPadd <= '1';
			          PCplus1 <= '1';
			          EnablePC <= '1';
			          nextState <= fetch;
			          
			        when OTHERS =>
			          nextState <= halt;
			      end case;
			      
			    when "1111" =>
			      case IRout(9 downto 8) is
			        when mil_P22 =>  -- 16bit
			          readMem <= '1';
			          RFLwrite <= '1';
			          nextState <= PCInc;
			        when mih_P22 =>  -- 16bit
			          readMem <= '1';
			          RFHwrite <= '1';
			          nextState <= PCInc;
			        when spc_P22 =>  -- 16bit
			          PCplusI <= '1';
			          Address_on_DataBus <= '1';
			          RFLwrite <= '1';
			          RFHwrite <= '1';
			          EnablePC <= '1';
			          nextState <= PCInc;
			        when jpa_P22 =>  -- 16bit
			          RplusI <= '1';
			          EnablePC <= '1';
			          Rd_on_AddressUnitRSide <= '1';
			          nextState <= fetch;
			          
			        when OTHERS =>
			          nextState <= halt;
			      end case;
			      
			    when mvr_P1 =>
			      B15to0 <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when lda_P1 =>
			      Rs_on_AddressUnitRSide <= '1';
			      Rplus0 <= '1';
			      readMem <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when sta_P1 =>
			      B15to0 <= '1';
			      ALUout_on_DataBus <= '1';
			      writeMem <= '1';
			      Rd_on_AddressUnitRSide <= '1';
			      Rplus0 <= '1';
			      nextState <= shadowExe;
			    when tcm_P1 =>
			      tcmpB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when rnd_P1 =>
			      rand <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when and_P1 =>
			      AandB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when orr_P1 =>
			      AorB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when not_P1 =>
			      notB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when shl_P1 =>
			      shlB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when shr_P1 =>
			      shrB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when add_P1 =>
			      AaddB <= '1';
			      SRload <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when sub_P1 =>
			      AsubB <= '1';
			      SRload <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when mul_P1 =>
			      AmulB <= '1';
			      SRload <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= shadowExe;
			    when cmp_P1 => 
			      AcmpB <= '1';
			      SRload <= '1';
			      nextState <= shadowExe;
			      
			    when OTHERS =>
			          nextState <= halt;
			  end case;
			when shadowExe =>
			  shadow <= '1';
			  
			  case IRout(7 downto 4) is
			    when "0000" =>
			      case IRout(3 downto 0) is
			        when nop_P2 =>
			          PCplus1 <= '1';
			          EnablePC <= '1';
			          nextState <= fetch;
			        when hlt_P2 =>
			          nextState <= halt;
			        when szf_P2 =>
			          ZSet <= '1';
			          PCplus1 <= '1';
			          EnablePC <= '1';
			          nextState <= fetch;
			        when czf_P2 =>
			          ZReset <= '1';
			          PCplus1 <= '1';
			          EnablePC <= '1';
			          nextState <= fetch;
			        when scf_P2 =>
			          CSet <= '1';
			          PCplus1 <= '1';
			          EnablePC <= '1';
			          nextState <= fetch;
			        when ccf_P2 =>
			          CReset <= '1';
			          PCplus1 <= '1';
			          EnablePC <= '1';
			          nextState <= fetch;
			        when cwp_P2 =>
			          WPreset <= '1';
			          PCplus1 <= '1';
			          EnablePC <= '1';
			          nextState <= fetch;
			          
			        when OTHERS =>
			          nextState <= halt;
			      end case;
			      
			        
			    when mvr_P1 =>
			      B15to0 <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when lda_P1 =>
			      Rs_on_AddressUnitRSide <= '1';
			      Rplus0 <= '1';
			      readMem <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      nextState <= PCInc;
			    when sta_P1 =>
			      B15to0 <= '1';
			      ALUout_on_DataBus <= '1';
			      writeMem <= '1';
			      Rd_on_AddressUnitRSide <= '1';
			      Rplus0 <= '1';
			      nextState <= PCInc;
			    when tcm_P1 =>
			      tcmpB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when rnd_P1 =>
			      rand <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when and_P1 =>
			      AandB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when orr_P1 =>
			      AorB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when not_P1 =>
			      notB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when shl_P1 =>
			      shlB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when shr_P1 =>
			      shrB <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when add_P1 =>
			      AaddB <= '1';
			      SRload <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when sub_P1 =>
			      AsubB <= '1';
			      SRload <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when mul_P1 =>
			      AmulB <= '1';
			      SRload <= '1';
			      ALUout_on_DataBus <= '1';
			      RFLwrite <= '1';
			      RFHwrite <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			    when cmp_P1 => 
			      AcmpB <= '1';
			      SRload <= '1';
			      PCplus1 <= '1';
			      EnablePC <= '1';
			      nextState <= fetch;
			      
			    when OTHERS =>
			          nextState <= halt;
			          
			          
			  end case;
			          
			          
			when PCInc =>
			  PCplus1 <= '1';
			  EnablePC <= '1';
			  nextState <= fetch;
			when OTHERS =>
			  nextState <= reset;
			  
		end case;
	end process;
  
end architecture;




