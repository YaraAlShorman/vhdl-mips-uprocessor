library IEEE;
use work.my_work.all;
use work.MATH_REAL.all;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL; 

entity l2pm is
    generic ( addr_bits : integer;
              starting_addr : integer);
    port (    logical_in : in STD_LOGIC_VECTOR (word_len-1 downto 0);
              physical_out : out STD_LOGIC_VECTOR (addr_bits-1 downto 0));
end l2pm;

architecture Behavioral of l2pm is  -- logical to physical address mapper

signal int_addr : std_logic_vector(word_len-1 downto 0);

begin

process(logical_in)
begin
    int_addr <= std_logic_vector(unsigned(logical_in) - to_unsigned(starting_addr, word_len));
end process;

physical_out <= int_addr(addr_bits+1 downto 2); -- implied division by 4

end Behavioral;
