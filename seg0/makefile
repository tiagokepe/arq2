build:
	ghdl -a --ieee=synopsys packageWires.vhd
	ghdl -a --ieee=synopsys aux.vhd
	ghdl -a --ieee=synopsys add10.vhd
	ghdl -a --ieee=synopsys compare10.vhd
	ghdl -a --ieee=synopsys count10.vhd
	ghdl -a --ieee=synopsys isBorder.vhd
	ghdl -a --ieee=synopsys register10.vhd
	ghdl -a --ieee=synopsys sub10.vhd

	ghdl -a --ieee=synopsys seg0.vhd

	ghdl -a --ieee=synopsys test.vhd
	ghdl -e --ieee=synopsys test

run: build
	ghdl -r test --stop-time=300ns --vcd=trace.vcd
	gtkwave trace.vcd

clean:
	ghdl --clean

