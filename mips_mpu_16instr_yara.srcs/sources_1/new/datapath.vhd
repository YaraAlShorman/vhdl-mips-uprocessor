library ieee;
use work.my_work.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.math_real.all;

entity datapath is
  Port ( 
    clk, rst : in std_logic
  );
end datapath;

architecture Behavioral of datapath is

-- component declarations
-- there's gonna be a lot of these
-- pc
component pc is
    Port ( clk, rst : in  std_logic;
           pc_store : in  std_logic_vector (word_len - 1 downto 0);
           pc_addr  : out std_logic_vector (word_len - 1 downto 0));
end component pc;

-- i mem
component i_mem is
    -- let the program be a generic set in the datapath when this component is instantiated
--    generic ( program : i_mem_type);
    Port (    rst : in std_logic;
              read_addr : in std_logic_vector (word_len-1 downto 0);
              instr : out std_logic_vector (word_len-1 downto 0) );
end component i_mem;

-- register file
component reg_file is
    Port ( readaddr1 : in std_logic_vector (4 downto 0);
           readaddr2 : in std_logic_vector (4 downto 0);
           regwrite : in std_logic;
           writeaddr : in std_logic_vector (4 downto 0);
           writedata : in std_logic_vector (word_len-1 downto 0);
           clk : in std_logic;
           rst : in std_logic;
           readdata1 : out std_logic_vector (word_len-1 downto 0);
           readdata2 : out std_logic_vector (word_len-1 downto 0));
end component reg_file;

-- adder
component adder is
    Port ( add_in_1 : in std_logic_vector  (word_len - 1 downto 0);
           add_in_2 : in std_logic_vector  (word_len - 1 downto 0);
           sum      : out std_logic_vector (word_len - 1 downto 0));
end component adder;

-- control unit
component control_unit is
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
end component control_unit;

-- extender
-- can be used for sext or zext
component extender is
    Port ( mode : in std_logic; -- 1 for sext, 0 for zext
           unextended_in : in std_logic_vector (half_word_len - 1 downto 0);
           extended_out : out std_logic_vector (word_len - 1 downto 0));
end component extender;

-- d mem
component d_mem is
    Port ( mem_write : in std_logic;
           clk, rst : in std_logic;
           addr : in std_logic_vector (word_len-1 downto 0);
           write_data : in std_logic_vector (word_len-1 downto 0);
           read_data : out std_logic_vector (word_len-1 downto 0));
end component d_mem;

component alu is
    Port ( operand_1 : in std_logic_vector (word_len - 1 downto 0);
           operand_2 : in std_logic_vector (word_len - 1 downto 0);
           alu_ctrl : in std_logic_vector (3 downto 0);
           zero : out std_logic;
           alu_output : out std_logic_vector (word_len - 1 downto 0));
end component alu;

-- signals and constants declarations
constant four_int : integer := 4;

signal next_pc_addr, pc_addr, instruction, pc_plus_four, branch_addr, br_add_out : std_logic_vector(word_len - 1 downto 0);
signal rf_read_data_1, rf_read_data_2, rf_write_data, alu_operand_1, alu_operand_2 : std_logic_vector(word_len - 1 downto 0) := (others => '0');
signal sext_out, zext_out, alu_out, d_mem_out, jump_addr : std_logic_vector(word_len - 1 downto 0);
--signal opcode, funct : std_logic_vector(5 downto 0);
signal write_addr : std_logic_vector(4 downto 0);
signal alu_ctrl : std_logic_vector(3 downto 0);
signal alu_src : std_logic_vector(1 downto 0);
signal jr, j, jal, mem_write, mem_to_reg, beq, bne, reg_dst, reg_write : std_logic;
signal zero_sig, jump, bt : std_logic;

begin

-- instantiating components
pc_reg : pc
    port map   (     clk => clk,
                     rst => rst,
                     pc_store => next_pc_addr,
                     pc_addr  => pc_addr);

instr_mem : i_mem
--    generic map (    program => initial_i_mem)
    port map    (    rst => rst,
                     read_addr => pc_addr,
                     instr => instruction);
pc_adder : adder
    port map    (    add_in_1 => pc_addr,
                     add_in_2 => std_logic_vector(to_unsigned(four_int, word_len)),
                     sum      => pc_plus_four);

branch_adder : adder
    port map    (    add_in_1 => pc_plus_four,
                     add_in_2 => branch_addr,
                     sum      => br_add_out);
                     
control : control_unit
    port map    (   clk => clk,
                    rst => rst,
                    opcode => instruction(31 downto 26),
                    funct => instruction(5 downto 0),
                    alu_ctrl => alu_ctrl,
                    jr => jr,
                    j => j,
                    jal => jal,
                    mem_write => mem_write,
                    mem_to_reg => mem_to_reg, 
                    beq => beq,
                    bne => bne,
                    alu_src => alu_src,
                    reg_dst => reg_dst,
                    reg_write => reg_write);

register_file : reg_file
     port map   (  readaddr1 => instruction(25 downto 21),
                   readaddr2 => instruction(20 downto 16),
                   regwrite => reg_write,
                   writeaddr => write_addr,
                   writedata => rf_write_data,
                   clk => clk,
                   rst => rst,
                   readdata1 => rf_read_data_1,
                   readdata2 => rf_read_data_2);

sext : extender
    port map    (  mode => '1',
                   unextended_in => instruction(15 downto 0),
                   extended_out => sext_out);
           
zext : extender
    port map    ( mode => '0',
                  unextended_in => instruction(15 downto 0),
                  extended_out => zext_out);

alu_unit : alu
    port map    (  operand_1 => alu_operand_1,
                   operand_2 => alu_operand_2,
                   alu_ctrl => alu_ctrl,
                   zero => zero_sig,
                   alu_output => alu_out);

data_mem : d_mem
    port map    ( mem_write => mem_write,
                  clk => clk,
                  rst => rst,
                  addr => alu_out,
                  write_data => rf_read_data_2,
                  read_data => d_mem_out);          
                  
process(clk, rst, jr, j, jal, mem_write, mem_to_reg, beq, bne, reg_dst, reg_write, instruction, zero_sig,
        rf_read_data_1, rf_read_data_2, sext_out, zext_out, pc_plus_four, br_add_out, jump_addr, d_mem_out,
        alu_out)
begin
jump <= j or jal;
bt <= (beq and zero_sig) or (bne and (not zero_sig));
jump_addr <= (pc_plus_four(31 downto 28) & instruction(25 downto 0) & "00");

next_pc_addr <= rf_read_data_1 when (jr='1') else
                jump_addr when (jump='1') else                 
                br_add_out when (bt='1') else
                pc_plus_four;

alu_operand_1 <= rf_read_data_1;

alu_operand_2 <= rf_read_data_2 when (alu_src="00") else
                 sext_out       when (alu_src="01") else
                 zext_out; -- when alu_src="1x"

branch_addr <= sext_out(29 downto 0) & "00";                 
                    
write_addr <= "11111" when (jal='1') else
              instruction(15 downto 11) when (reg_dst='1' and jal='0') else -- when reg_dst='1' and jal='0'
              instruction(20 downto 16); -- when reg_dst='0'

rf_write_data <= pc_plus_four when (jal='1') else
                 d_mem_out when (mem_to_reg='1' and jal='0') else -- and jal='0'
                 alu_out; -- when mem_to_reg and jal ='0'
end process;

end Behavioral;
