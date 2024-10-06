library ieee;
library work;
use work.my_work.all;
use work.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity shift_left_2 is
generic ( in_len : integer );
port (    unshifted_in : in std_logic_vector(in_len - 1 downto 0);
          shifted_out : out std_logic_vector(in_len + 1 downto 0));
end shift_left_2;

architecture Behavioral of shift_left_2 is

begin


end Behavioral;
