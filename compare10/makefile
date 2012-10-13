build:
	ghdl -a --ieee=synopsys packageWires.vhd
	ghdl -a --ieee=synopsys compare10.vhd

compare10: build test
	ghdl -r test --stop-time=60ns --vcd=trace.vcd
	gtkwave trace.vcd

test:
	ghdl -a --ieee=synopsys test.vhd
	ghdl -e --ieee=synopsys test

nor: build nortest
	ghdl -r nortest --stop-time=20ns --vcd=trace.vcd
	gtkwave trace.vcd

nortest:
	ghdl -a --ieee=synopsys nortest.vhd
	ghdl -e --ieee=synopsys nortest
	

clean:
	ghdl --clean

