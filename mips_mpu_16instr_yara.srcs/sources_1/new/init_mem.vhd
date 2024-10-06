library ieee;
use work.math_real.all;
use ieee.std_logic_1164.all;

-- package declaration to use array as generic in i-mem
package my_work is
    -- these can be changed
     constant word_len : integer := integer(32);
     constant i_mem_depth : integer := integer(36);
     constant d_mem_depth : integer := integer(128);
     constant i0 : integer := integer(16#0040_0000#); -- i mem logical starting addr
     constant d0 : integer := integer(16#1001_0000#); -- d mem logical starting addr
          
     -- do NOT change these
     constant half_word_len : integer := integer(word_len / 2);
     constant sp : integer := d0 + (4*d_mem_depth - 1);
     constant i_addr_bits : integer := integer(ceil(log2(real(i_mem_depth))));
     constant d_addr_bits : integer := integer(ceil(log2(real(d_mem_depth))));
     type i_mem_type is array(0 to i_mem_depth-1) of std_logic_vector(word_len-1 downto 0);
     type d_mem_type is array(0 to d_mem_depth-1) of std_logic_vector(word_len-1 downto 0);

    -- reset memory space
    constant reset_addr : std_logic_vector(word_len-1 downto 0) := (others => '0');
    constant initial_d_mem : d_mem_type := (others => reset_addr);
    constant initial_i_mem : i_mem_type := (others => reset_addr);

-- change this as needed
-- commented array below is the non recursive fib seq mips code
constant my_program : i_mem_type :=
(
"00100000000001000000000000001111",
"00111100000001010001000000000001",
"00110100101001010000000000001100",
"00001100000100000000000000000101",
"00001000000100000000000000000100",
"00100011101111011111111111101000",
"10101111101111110000000000010100",
"10101111101001010000000000010000",
"10101111101001000000000000001100",
"10101111101010000000000000001000",
"10101111101010010000000000000100",
"10101111101010100000000000000000",
"00100000000010100000000000000000",
"10101100101010100000000000000000",
"00100000101001010000000000000100",
"00010000100000000000000000001100",
"00100000000010010000000000000001",
"10101100101010010000000000000000",
"00100000101001010000000000000100",
"00100000100001001111111111111111",
"00010000100000000000000000000111",
"00000001001010100100000000100000",
"00000001001000000101000000100000",
"00000001000000000100100000100000",
"10101100101010000000000000000000",
"00100000101001010000000000000100",
"00100000100001001111111111111111",
"00010100100000001111111111111001",
"10001111101010100000000000000000",
"10001111101010010000000000000100",
"10001111101010000000000000001000",
"10001111101001000000000000001100",
"10001111101001010000000000010000",
"10001111101111110000000000010100",
"00100011101111010000000000011000",
"00000011111000000000000000001000"
);



end package my_work;