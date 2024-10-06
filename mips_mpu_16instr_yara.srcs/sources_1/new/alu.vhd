library ieee;
use ieee.std_logic_1164.all;
use work.my_work.all;
use ieee.numeric_std.all; 
use work.math_real.all;

entity alu is
    Port ( operand_1 : in std_logic_vector (word_len - 1 downto 0);
           operand_2 : in std_logic_vector (word_len - 1 downto 0);
           alu_ctrl : in std_logic_vector (3 downto 0);
           zero : out std_logic;
           alu_output : out std_logic_vector (word_len - 1 downto 0));
end alu;

architecture Behavioral of alu is

-- defining 1 and 0 as integers for compatability with changing word length
constant one_int : integer := 1; 
constant zero_int : integer := 0;
constant neg_one_int : integer := -1;

signal alu_out_sig : std_logic_vector(word_len - 1 downto 0);

begin

process (alu_ctrl, operand_1, operand_2)
begin 
    case alu_ctrl is
        when "0000" =>  -- and
            alu_out_sig <= operand_1 and operand_2;
        when "0001" =>  -- or
            alu_out_sig <= operand_1 or operand_2;
        when "0010" =>  -- add, no ovf handling
            alu_out_sig <= std_logic_vector(signed(operand_1) + signed(operand_2)); -- not handling overflow
        when "0110" =>  -- sub, no ovf handling
            alu_out_sig <= std_logic_vector(signed(operand_1) - signed(operand_2)); -- not handling overflow
        when "0111" =>  -- slt (set on less than)
            -- assign output to 1 when operand_1 < operand_2, 0 otherwise
            if (signed(operand_1) < signed(operand_2)) then
                alu_out_sig <= std_logic_vector(to_unsigned(one_int, word_len));
            else
                alu_out_sig <= std_logic_vector(to_unsigned(zero_int, word_len));
            end if;
        when "1100" =>  -- nor
            alu_out_sig <= operand_1 nor operand_2;
        when "1111" =>  -- shift left logical 16 bits
            alu_out_sig <= operand_2(half_word_len - 1 downto 0) & std_logic_vector(to_unsigned(zero_int, half_word_len));
        when others =>  -- undefined operations, this part of the code should never be executed, but it is here for the sake of having a wholistic design
            -- in the case an undefined operation ~somehow~ is called, the output shall be assigned to -1 (0xFFFF_FFFF)
            -- the hope is that this is easy to catch when debugging
            alu_out_sig <= std_logic_vector(to_signed(neg_one_int, word_len));
    end case;
end process;

zero <= '1' when (alu_out_sig=std_logic_vector(to_unsigned(zero_int, word_len))) 
        else '0';
        
alu_output <= alu_out_sig;

end Behavioral;
