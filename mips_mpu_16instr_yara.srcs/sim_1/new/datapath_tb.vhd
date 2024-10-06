library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath_tb is
--  Port ( );
end datapath_tb;

architecture Behavioral of datapath_tb is

component datapath is
  Port ( 
    clk, rst : in std_logic
  );
end component datapath;
  
signal clk, rst : std_logic := '0';
begin

uut : datapath
port map (
clk => clk,
rst => rst
);

clk <= not clk after 10ns;

process
begin

rst <= '1';
wait for 30ns;
rst <= '0';
wait for 999999999ns;

end process;

end Behavioral;
