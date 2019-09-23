transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Jerry/UIUC/ECE385/Final/project {C:/Jerry/UIUC/ECE385/Final/project/RNG.sv}
vlib nios_system
vmap nios_system nios_system

vlog -sv -work work +incdir+C:/Jerry/UIUC/ECE385/Final/project {C:/Jerry/UIUC/ECE385/Final/project/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L nios_system -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 100 us
