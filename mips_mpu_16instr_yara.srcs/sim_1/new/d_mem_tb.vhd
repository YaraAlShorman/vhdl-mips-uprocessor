library ieee;
use work.my_work.all;
use ieee.std_logic_1164.all;

entity d_mem_tb is
--    Port ( );
end d_mem_tb;

architecture behavioral of d_mem_tb is

component d_mem is
    Port ( mem_write : in std_logic;
           clk, rst : in std_logic;
           addr : in std_logic_vector (word_len-1 downto 0);
           write_data : in std_logic_vector (word_len-1 downto 0);
           read_data : out std_logic_vector (word_len-1 downto 0));
end component d_mem;

signal read, write : std_logic_vector (word_len-1 downto 0) := (others => '0');
signal addr : std_logic_vector (word_len-1 downto 0) := (others => '0');
signal clk, rst, mw : std_logic := '0';

begin

uut : d_mem
port map (
           read_data => read,
           mem_write => mw,
           addr => addr,
           write_data => write,
           clk => clk,
           rst => rst
);

clk <= not clk after 10ns;

process
begin

rst <= '1';
wait for 50ns;

rst <= '0';
mw <= '1';
addr  <= "00010000000000010000000000000100";
write <= "11111111111111111111111111111111";
wait for 20ns;

mw <= '0';
addr  <= "00010000000000010000000000000100";
write <= "00000000000000000000000000000000";
wait for 20ns;

end process;

end behavioral;