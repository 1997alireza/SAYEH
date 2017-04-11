library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SUB is  
port (
    Rs, Rd : in STD_LOGIC_VECTOR (15 downto 0);
    c : in STD_LOGIC;                             -- from Cout
    output : out STD_LOGIC_VECTOR (15 downto 0);  -- to Rd
    carry : out STD_LOGIC;                        -- to Cin
    zero : out STD_LOGIC                          -- to Zin
  );
end entity;

architecture SUB_ARCH of SUB is
  signal res : STD_LOGIC_VECTOR(16 downto 0);
  signal cComp : STD_LOGIC_VECTOR(15 downto 0);
  signal RsComp : STD_LOGIC_VECTOR(15 downto 0);
  component twosComp is
    port (
      Rs: in STD_LOGIC_VECTOR (15 downto 0);
      output: out STD_LOGIC_VECTOR (15 downto 0)
    );
  end component;
begin
  RsComplement : twosComp port map (Rs, RsComp);
  with c select cComp <=
       (OTHERS => '1') when '1',
       (OTHERS => '0') when OTHERS;
  res <= std_logic_vector( unsigned("0" & Rd) + unsigned("0" & RsComp) + unsigned("0" & cComp) );
  output <= res(15 downto 0);
  with res(15 downto 0) select zero <=
       '1'  when (OTHERS => '0'),
       '0'  when OTHERS;
  carry <= res(16);
end architecture;
 




