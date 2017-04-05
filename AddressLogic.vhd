library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AddressLogic is
   port (
    PCside, Rside : in std_logic_vector (15 downto 0);
    Iside : in std_logic_vector (7 downto 0);
    ALout : out std_logic_vector (15 downto 0);
    ResetPC, PCplusI, PCplus1, RplusI, Rplus0 : in std_logic
);
end entity;

architecture dataflow of AddressLogic is
  constant one : std_logic_vector (4 downto 0) := "10000";
  constant two : std_logic_vector (4 downto 0) := "01000";
  constant three : std_logic_vector (4 downto 0) := "00100";
  constant four : std_logic_vector (4 downto 0) := "00010";
  constant five : std_logic_vector (4 downto 0) := "00001";
  begin
  process (PCside, Rside, Iside, ResetPC,
    PCplusI, PCplus1, RplusI, Rplus0)
    variable temp : std_logic_vector (4 downto 0);
    begin
      temp := (ResetPC & PCplusI & PCplus1 & RplusI & Rplus0);
      case temp is
        when one => ALout <= (OTHERS => '0');
        when two => ALout <= std_logic_vector(unsigned(PCside) + unsigned(Iside));
        when three => ALout <= std_logic_vector(unsigned(PCside) + 1);
        when four => ALout <= std_logic_vector(unsigned(Rside) + unsigned(Iside));
        when five => ALout <= Rside;
        when OTHERS => ALout <= PCside;
      end case;
  end process;
end architecture;