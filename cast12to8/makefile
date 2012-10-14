build:
	ghdl -a --ieee=synopsys packageWires.vhd
	ghdl -a --ieee=synopsys cast12to8.vhd
	ghdl -a --ieee=synopsys test.vhd
	ghdl -e --ieee=synopsys test

run: build
	ghdl -r test --stop-time=150ns --vcd=trace.vcd
	gtkwave trace.vcd

clean:
	ghdl --clean

