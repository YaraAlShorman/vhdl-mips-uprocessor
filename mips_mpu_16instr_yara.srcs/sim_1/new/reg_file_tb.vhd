library ieee;
use work.my_work.all;
use ieee.std_logic_1164.all;

entity reg_file_tb is
--    Port ( );
end reg_file_tb;

architecture behavioral of reg_file_tb is

component reg_file is
    Port ( readaddr1 : in std_logic_vector (4 downto 0);
           readaddr2 : in std_logic_vector (4 downto 0);
           regwrite : in std_logic;
           writeaddr : in std_logic_vector (4 downto 0);
           writedata : in std_logic_vector (word_len-1 downto 0);
           clk : in std_logic;
           rst : in std_logic;
           readdata1 : out std_logic_vector (word_len-1 downto 0);
           readdata2 : out std_logic_vector (word_len-1 downto 0));
end component reg_file;

signal read1, read2, write : std_logic_vector (4 downto 0) := (others => '0');
signal rd1, rd2, wd : std_logic_vector (word_len-1 downto 0) := (others => '0');
signal clk, rst, rw : std_logic := '0';

begin

uut : reg_file
port map (
           readaddr1 => read1,
           readaddr2 => read2,
           regwrite => rw,
           writeaddr => write,
           writedata => wd,
           clk => clk,
           rst => rst,
           readdata1 => rd1,
           readdata2 => rd2
);

clk <= not clk after 10ns;

process
begin

rst <= '1';
wait for 50ns;

rst <= '0';
rw <= '1';
write <= "00011";
wd <= "00100000000001000000000000001111";
wait for 20ns;

rw <= '1';
write <= "00100";
wd <= "11111111111111111111111111111111";
wait for 20ns;

rw <= '0';
write <= "00000";
read1 <= "00011";
read2 <= "00100";
wd <= "00000000000000000000000000000000";
wait for 20ns;

end process;

end behavioral;