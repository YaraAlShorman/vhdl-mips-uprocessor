library ieee;
use work.my_work.all;
use ieee.numeric_std.all; 
use ieee.std_logic_1164.all;

entity pc is
    Port ( clk, rst : in  std_logic;
           pc_store : in  std_logic_vector (word_len - 1 downto 0);
           pc_addr  : out std_logic_vector (word_len - 1 downto 0));
end pc;

architecture Behavioral of pc is

signal pc : std_logic_vector(word_len - 1 downto 0);

begin

process(clk, rst)
begin
    if (rst='1') then
        pc <= std_logic_vector(to_unsigned(i0, word_len));
    elsif (clk'event and clk='1') then
        pc <= pc_store;
    end if;    
end process;

pc_addr <= pc;

end Behavioral;
