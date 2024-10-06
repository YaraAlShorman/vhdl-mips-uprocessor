library ieee;
use work.my_work.all;
use ieee.std_logic_1164.all;

entity alu_tb is
--    Port ( );
end alu_tb;

architecture behavioral of alu_tb is

component alu is
    Port ( operand_1 : in std_logic_vector (word_len - 1 downto 0);
           operand_2 : in std_logic_vector (word_len - 1 downto 0);
           alu_ctrl : in std_logic_vector (3 downto 0);
           zero : out std_logic;
           alu_output : out std_logic_vector (word_len - 1 downto 0));
end component alu;

signal op1, op2, output : std_logic_vector(word_len-1 downto 0);
signal z : std_logic;
signal ctrl : std_logic_vector(3 downto 0);

begin

uut : alu
port map (
    operand_1 => op1,
    operand_2 => op2,
    alu_ctrl => ctrl,
    zero => z,
    alu_output => output);
    
process
begin

wait for 10ns;
op1 <= "00000000000000000000111111111111";
op2 <= "00000000000000000000000000000010";
ctrl <= "1111";
wait for 10ns;

end process;
end behavioral;