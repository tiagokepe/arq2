build:
	ghdl -a --ieee=synopsys packageWires.vhd
	ghdl -a --ieee=synopsys aux.vhd
	ghdl -a --ieee=synopsys add12.vhd
	ghdl -a --ieee=synopsys div8.vhd
	ghdl -a --ieee=synopsys div2.vhd
	ghdl -a --ieee=synopsys seg2.vhd
	ghdl -a --ieee=synopsys test.vhd
	ghdl -e --ieee=synopsys test

run: build
	ghdl -r test --stop-time=300ns --vcd=trace.vcd
	gtkwave trace.vcd

clean:
	ghdl --clean

