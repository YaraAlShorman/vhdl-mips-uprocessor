library ieee;
use work.my_work.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity adder is
    Port ( add_in_1 : in std_logic_vector  (word_len - 1 downto 0);
           add_in_2 : in std_logic_vector  (word_len - 1 downto 0);
           sum      : out std_logic_vector (word_len - 1 downto 0));
end adder;

architecture Behavioral of adder is

begin
sum <= std_logic_vector(unsigned(add_in_1) + unsigned(add_in_2));
end Behavioral;
