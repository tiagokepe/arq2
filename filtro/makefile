build:
	ghdl -a --ieee=synopsys packageWires.vhd
	ghdl -a --ieee=synopsys packageMatriz.vhd
	ghdl -a --ieee=synopsys aux.vhd
	ghdl -a --ieee=synopsys add10.vhd
	ghdl -a --ieee=synopsys add12.vhd
	ghdl -a --ieee=synopsys div8.vhd
	ghdl -a --ieee=synopsys div2.vhd
	ghdl -a --ieee=synopsys cast12to8.vhd
	ghdl -a --ieee=synopsys mux2X1.vhd
	ghdl -a --ieee=synopsys compare10.vhd
	ghdl -a --ieee=synopsys count10.vhd
	ghdl -a --ieee=synopsys isBorder.vhd
	ghdl -a --ieee=synopsys register10.vhd
	ghdl -a --ieee=synopsys sub10.vhd
	ghdl -a --ieee=synopsys rom.vhd
	ghdl -a --ieee=synopsys ram.vhd
	ghdl -a --ieee=synopsys ext8to12.vhd
	ghdl -a --ieee=synopsys register12.vhd
	ghdl -a --ieee=synopsys register8.vhd
	ghdl -a --ieee=synopsys seg0.vhd
	ghdl -a --ieee=synopsys seg1.vhd
	ghdl -a --ieee=synopsys seg2.vhd
	ghdl -a --ieee=synopsys seg3.vhd
	ghdl -a --ieee=synopsys test.vhd
	ghdl -e --ieee=synopsys test

run: build
	ghdl -r test --stop-time=8000ns --vcd=trace.vcd
	gtkwave trace.vcd

clean:
	ghdl --clean

