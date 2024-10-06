# open_wave_config {C:/Users/yaras/OneDrive/Desktop/23-24/Spring 2024/EECS 443/Lab/mips_mpu_16instr_yara/mips_mpu_16instr_yara.srcs/sources_1/imports/datapath_behav.wcfg}
add_force {/datapath/clk} -radix hex {0 0ns} {1 5000ps} -repeat_every 10000ps
add_force {/datapath/rst} -radix hex {1 0ns}
run 10 ns
run 10 ns
run 10 ns
run 10 ns
add_force {/datapath/rst} -radix hex {0 0ns}
run all