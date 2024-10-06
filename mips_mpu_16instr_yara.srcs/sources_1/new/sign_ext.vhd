library ieee;
use work.my_work.all;
use ieee.std_logic_1164.all;

entity extender is
    Port ( mode : in std_logic; -- 1 for sext, 0 for zext
           unextended_in : in std_logic_vector (half_word_len - 1 downto 0);
           extended_out : out std_logic_vector (word_len - 1 downto 0));
end extender;

architecture Behavioral of extender is

signal ext : std_logic_vector(half_word_len - 1 downto 0);

begin

process(mode, unextended_in)
begin
    if (mode='1') then
        ext(half_word_len - 1 downto 0) <= (others => unextended_in(half_word_len - 1));
    else
        ext(half_word_len - 1 downto 0) <= (others => '0');
    end if;
end process;

extended_out <= ext & unextended_in;

end Behavioral;