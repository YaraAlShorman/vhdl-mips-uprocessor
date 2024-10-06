library ieee;
use work.my_work.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.math_real.all;

entity i_mem is
    -- let the program be a generic set in the datapath when this component is instantiated
--    generic ( program : i_mem_type);
    Port (    rst : in std_logic;
              read_addr : in std_logic_vector (word_len-1 downto 0);
              instr : out std_logic_vector (word_len-1 downto 0) );
end i_mem;

architecture Behavioral of i_mem is

-- instantiating i mem type
signal i_mem : i_mem_type;

-- i mem depth is defined (and can be controlled) in init_mem.vhd package file
signal phys_addr : std_logic_vector(i_addr_bits-1 downto 0); -- signal width dependant on number of addresses

component l2pm is
    generic ( addr_bits : integer;
              starting_addr : integer);
    port (    logical_in : in std_logic_vector (word_len-1 downto 0);
              physical_out : out std_logic_vector (addr_bits-1 downto 0));
end component l2pm;

begin

i_l2pm : l2pm
    generic map(  addr_bits => i_addr_bits,
                  starting_addr => i0)
    port map(     logical_in => read_addr,
                  physical_out => phys_addr);

process(rst, phys_addr)
begin
    if (rst='1') then
        i_mem <= my_program;
        instr <= (others => '0');
    else
        instr <= i_mem(to_integer(unsigned(phys_addr)));
    end if;    
end process;


end Behavioral;