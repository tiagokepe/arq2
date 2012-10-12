build:
	ghdl -a --ieee=synopsys packageWires.vhd
	ghdl -a --ieee=synopsys aux.vhd
	ghdl -a --ieee=synopsys count10.vhd
	ghdl -a --ieee=synopsys test.vhd
	ghdl -e --ieee=synopsys test

run: build
	ghdl -r test --stop-time=40ns --vcd=trace.vcd
	gtkwave trace.vcd

clean:
	ghdl --clean

