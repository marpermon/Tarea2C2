tarea: testbench.v ondas.gtkw rtlii_sint.ys
	yosys -s rtlii_sint.ys
	iverilog -o salida testbench.v
	vvp salida #Corre la simulación
	gtkwave ondas.gtkw
