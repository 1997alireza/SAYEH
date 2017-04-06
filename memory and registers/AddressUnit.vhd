library IEEE;
use IEEE.std_logic_1164.all;

entity addressUnit is
  port (
    Rside : in std_logic_vector (15 downto 0);
    Iside : in std_logic_vector (7 downto 0);
    Address : out std_logic_vector (15 downto 0);
    clk, ResetPC, PCplusI, PCplus1 : in std_logic;
    RplusI, Rplus0, EnablePC : in std_logic
  );
end entity;

architecture addressUnit_ARCH of addressUnit is
  component PC is 
    port (
      EnablePC : in std_logic;
      input: in std_logic_vector (15 downto 0);
      clk : in std_logic;
      output: out std_logic_vector (15 downto 0)
    );
  end component;
  component AddressLogic is
    port (
      PCside, Rside : in std_logic_vector (15 downto 0);
      Iside : in std_logic_vector (7 downto 0);
      ALout : out std_logic_vector (15 downto 0);
      ResetPC, PCplusI, PCplus1, RplusI, Rplus0 : in std_logic
    );
  end component;

  signal pcout : std_logic_vector (15 downto 0);
  signal AddressSignal : std_logic_vector (15 downto 0);
  begin
    Address <= AddressSignal;
    pcC : PC port map (EnablePC, AddressSignal, clk, pcout);
    adLogic : AddressLogic port map (pcout, Rside, Iside, AddressSignal,
       ResetPC, PCplusI, PCplus1, RplusI, Rplus0);
  end architecture;
