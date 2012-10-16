build:
	ghdl -a --ieee=synopsys -fexplicit packageWires.vhd
	ghdl -a --ieee=synopsys -fexplicit packageMatriz.vhd
	ghdl -a --ieee=synopsys -fexplicit aux.vhd
	ghdl -a --ieee=synopsys -fexplicit add10.vhd
	ghdl -a --ieee=synopsys -fexplicit add12.vhd
	ghdl -a --ieee=synopsys -fexplicit div8.vhd
	ghdl -a --ieee=synopsys -fexplicit div2.vhd
	ghdl -a --ieee=synopsys -fexplicit cast12to8.vhd
	ghdl -a --ieee=synopsys -fexplicit mux2X1.vhd
	ghdl -a --ieee=synopsys -fexplicit compare10.vhd
	ghdl -a --ieee=synopsys -fexplicit count10.vhd
	ghdl -a --ieee=synopsys -fexplicit isBorder.vhd
	ghdl -a --ieee=synopsys -fexplicit register10.vhd
	ghdl -a --ieee=synopsys -fexplicit sub10.vhd
	ghdl -a --ieee=synopsys -fexplicit rom.vhd
	ghdl -a --ieee=synopsys -fexplicit ram.vhd
	ghdl -a --ieee=synopsys -fexplicit ext8to12.vhd
	ghdl -a --ieee=synopsys -fexplicit register12.vhd
	ghdl -a --ieee=synopsys -fexplicit register8.vhd
	ghdl -a --ieee=synopsys -fexplicit filtro.vhd
	ghdl -a --ieee=synopsys -fexplicit tb_filtro.vhd
	ghdl -e --ieee=synopsys -fexplicit tb_filtro

run: build
	ghdl -r tb_filtro --stop-time=8000ns --vcd=trace.vcd
	gtkwave trace.vcd

clean:
	ghdl --clean

