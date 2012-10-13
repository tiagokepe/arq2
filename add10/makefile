build:
	ghdl -a --ieee=synopsys packageWires.vhd
	ghdl -a --ieee=synopsys aux.vhd
	ghdl -a --ieee=synopsys add10.vhd
#	ghdl -a --ieee=synopsys 2test.vhd
#	ghdl -e --ieee=synopsys test
	ghdl -a --ieee=synopsys testBench.vhd
	ghdl -e --ieee=synopsys testBench

run: build
#	ghdl -r test --stop-time=40ns --vcd=trace.vcd
#	gtkwave trace.vcd
	ghdl -r testBench --stop-time=40ns --vcd=trace.vcd
	gtkwave trace.vcd

clean:
	ghdl --clean

