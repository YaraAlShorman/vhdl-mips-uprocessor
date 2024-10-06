library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    Port ( clk, rst : std_logic;
           opcode : in std_logic_vector (5 downto 0);
           funct : in std_logic_vector (5 downto 0);
           alu_ctrl : out std_logic_vector (3 downto 0);
           jr : out std_logic;
           j : out std_logic;
           jal : out std_logic;
           mem_write : out std_logic;
           mem_to_reg : out std_logic;
           beq : out std_logic;
           bne : out std_logic;
           alu_src : out std_logic_vector(1 downto 0);
           reg_dst : out std_logic;
           reg_write : out std_logic);
end control_unit;

architecture Behavioral of control_unit is

begin
process(opcode, funct)
begin

--    if (rst='1') then
--        alu_ctrl <= "UUUU";
--        reg_dst <=   '0';
--        alu_src <=   "00";
--        mem_to_reg <= '0';
--        reg_write <= '0';
--        mem_write <= '0';
--        beq <=      '0';
--        j <=        '0';
--        bne <=      '0';
--        jal <=      '0';
--        jr <=       '0';
--    else
        if (opcode="000000") then -- r type instructions
            if (funct="001000") then -- if jump register instr
                alu_ctrl <= "0000";
                reg_dst <=   '0';
                alu_src <=   "00";
                mem_to_reg <= '0';
                reg_write <= '0';
                mem_write <= '0';
                beq <=      '0';
                j <=        '0';
                bne <=      '0';
                jal <=      '0';
                jr <=       '1';
            else
                case funct is
                    when "100100" => alu_ctrl <= "0000"; -- and
                    when "100101" => alu_ctrl <= "0001"; -- or
                    when "100000" => alu_ctrl <= "0010"; -- add
                    when "100010" => alu_ctrl <= "0110"; -- sub
                    when "101010" => alu_ctrl <= "0111"; -- slt
                    when "100111" => alu_ctrl <= "1100"; -- nor
                    when  others  => alu_ctrl <= "UUUU";  -- error state?
                end case;
                reg_dst <=   '1';
                alu_src <=   "00";
                mem_to_reg <= '0';
                reg_write <= '1';
                mem_write <= '0';
                beq <=      '0';
                j <=        '0';
                bne <=      '0';
                jal <=      '0';
                jr <=       '0';
            end if;
        elsif (opcode="100011") then -- lw
                alu_ctrl <= "0010";
                reg_dst <=   '0';
                alu_src <=   "01";
                mem_to_reg <= '1';
                reg_write <= '1';
                mem_write <= '0';
                beq <=      '0';
                j <=        '0';
                bne <=      '0';
                jal <=      '0';
                jr <=       '0';
        elsif (opcode="101011") then -- sw
                alu_ctrl <= "0010";
                reg_dst <=   '0';
                alu_src <=   "01";
                mem_to_reg <= '0';
                reg_write <= '0';
                mem_write <= '1';
                beq <=      '0';
                j <=        '0';
                bne <=      '0';
                jal <=      '0';
                jr <=       '0';
        elsif (opcode="000100") then -- beq
                alu_ctrl <= "0110";
                reg_dst <=   '0';
                alu_src <=   "00";
                mem_to_reg <= '0';
                reg_write <= '0';
                mem_write <= '0';
                beq <=      '1';
                j <=        '0';
                bne <=      '0';
                jal <=      '0';
                jr <=       '0';
        elsif (opcode="000010") then -- j
                alu_ctrl <= "0000";
                reg_dst <=   '0';
                alu_src <=   "00";
                mem_to_reg <= '0';
                reg_write <= '0';
                mem_write <= '0';
                beq <=      '0';
                j <=        '1';
                bne <=      '0';
                jal <=      '0';
                jr <=       '0';
        elsif (opcode="001000") then -- addi
                alu_ctrl <= "0010";
                reg_dst <=   '0';
                alu_src <=   "01";
                mem_to_reg <= '0';
                reg_write <= '1';
                mem_write <= '0';
                beq <=      '0';
                j <=        '0';
                bne <=      '0';
                jal <=      '0';
                jr <=       '0';
        elsif (opcode="000101") then -- bne
                alu_ctrl <= "0110";
                reg_dst <=   '0';
                alu_src <=   "00";
                mem_to_reg <= '0';
                reg_write <= '0';
                mem_write <= '0';
                beq <=      '0';
                j <=        '0';
                bne <=      '1';
                jal <=      '0';
                jr <=       '0';
        elsif (opcode="000011") then -- jal
                alu_ctrl <= "0000";
                reg_dst <=   '0';
                alu_src <=   "00";
                mem_to_reg <= '0';
                reg_write <= '1';
                mem_write <= '0';
                beq <=      '0';
                j <=        '0';
                bne <=      '0';
                jal <=      '1';
                jr <=       '0';
        elsif (opcode="001101") then -- ori
                alu_ctrl <= "0001";
                reg_dst <=   '0';
                alu_src <=   "11";
                mem_to_reg <= '0';
                reg_write <= '1';
                mem_write <= '0';
                beq <=      '0';
                j <=        '0';
                bne <=      '0';
                jal <=      '0';
                jr <=       '0';
        elsif (opcode="001111") then -- lui
                alu_ctrl <= "1111";
                reg_dst <=   '0';
                alu_src <=   "01";
                mem_to_reg <= '0';
                reg_write <= '1';
                mem_write <= '0';
                beq <=      '0';
                j <=        '0';
                bne <=      '0';
                jal <=      '0';
                jr <=       '0';
        else  -- error state ?
                alu_ctrl <= "UUUU";
                reg_dst <=   '0';
                alu_src <=   "00";
                mem_to_reg <= '0';
                reg_write <= '0';
                mem_write <= '0';
                beq <=      '0';
                j <=        '0';
                bne <=      '0';
                jal <=      '0';
                jr <=       '0';
        end if;
--    end if;
end process;
end Behavioral;