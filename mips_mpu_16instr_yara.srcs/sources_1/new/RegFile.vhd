library ieee;
use work.my_work.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.math_real.all;

entity reg_file is
    Port ( readaddr1 : in std_logic_vector (4 downto 0);
           readaddr2 : in std_logic_vector (4 downto 0);
           regwrite : in std_logic;
           writeaddr : in std_logic_vector (4 downto 0);
           writedata : in std_logic_vector (word_len-1 downto 0);
           clk : in std_logic;
           rst : in std_logic;
           readdata1 : out std_logic_vector (word_len-1 downto 0);
           readdata2 : out std_logic_vector (word_len-1 downto 0));
end reg_file;

architecture Behavioral of reg_file is

type reg_file_mem_type is array(0 to 31) of std_logic_vector(word_len-1 downto 0);
constant zero_register : std_logic_vector(word_len - 1 downto 0) := (others => '0');

-- adjust this to reset $sp correctly
-- $sp will be 0x1001 00FC if d mem depth is 64
-- logical address of top of dynamic memory
constant intitial_reg_file : reg_file_mem_type := (29 => std_logic_vector(to_unsigned(sp, word_len)),
                                                   others => zero_register); 

signal reg_file_mem : reg_file_mem_type;

begin

process(clk, rst, regwrite, readaddr1, readaddr2)
begin
    if (rst='1') then
        reg_file_mem <= intitial_reg_file;
    elsif (clk'event and clk='1') then
        if (regwrite='1') then
            reg_file_mem(to_integer(unsigned(writeaddr))) <= writedata;
        end if;
    end if;
    readdata1 <= reg_file_mem(to_integer(unsigned(readaddr1)));
    readdata2 <= reg_file_mem(to_integer(unsigned(readaddr2)));
end process;



end Behavioral;
