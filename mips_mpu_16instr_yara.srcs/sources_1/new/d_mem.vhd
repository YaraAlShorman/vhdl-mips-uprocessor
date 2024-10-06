library ieee;
use work.my_work.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.math_real.all;

entity d_mem is
    Port ( mem_write : in std_logic;
           clk, rst : in std_logic;
           addr : in std_logic_vector (word_len-1 downto 0);
           write_data : in std_logic_vector (word_len-1 downto 0);
           read_data : out std_logic_vector (word_len-1 downto 0));
end d_mem;

architecture Behavioral of d_mem is

-- instantiating d mem space
signal d_mem : d_mem_type;

-- d mem depth is defined (and can be controlled) in init_mem.vhd package file
signal phys_addr : std_logic_vector(d_addr_bits-1 downto 0); -- signal width dependant on number of addresses

component l2pm is
    generic ( addr_bits : integer;
              starting_addr : integer);
    port (    logical_in : in std_logic_vector (word_len-1 downto 0);
              physical_out : out std_logic_vector (addr_bits-1 downto 0));
end component l2pm;

begin

i_l2pm : l2pm
    generic map(  addr_bits => d_addr_bits,
                  starting_addr => d0)
    port map(     logical_in => addr,
                  physical_out => phys_addr);

process(clk, rst, mem_write)
begin
    if (rst='1') then
        d_mem <= initial_d_mem;
    elsif (clk'event and clk='1') then
        if (mem_write='1') then
            d_mem(to_integer(unsigned(phys_addr))) <= write_data;
        end if;
    end if;
read_data <= d_mem(to_integer(unsigned(phys_addr)));
end process;

end Behavioral;
