SRCDIR=./src
CACHEDIR=$(SRCDIR)/Cache
CPUDIR=$(SRCDIR)/CPU
MISCDIR=$(SRCDIR)/misc
BUILDDIR=./build
TESTDIR=./test

processor: cache misc cpu

all: processor

cache: memory
	ghdl -a $(CACHEDIR)/cache.vhd
	ghdl -e -o $(BUILDDIR)/cache cache

memory: init
	ghdl -a $(CACHEDIR)/memory.vhd
	ghdl -e -o $(BUILDDIR)/memory memory

init:
	mkdir -p $(BUILDDIR)

test_init: 
	mkdir -p $(TESTDIR)

clean: 
	rm -rf $(BUILDDIR)
	rm -rf $(TESTDIR)
	rm *.o *.cf

memory_test: memory test_init
	ghdl -a $(CACHEDIR)/memory_tb.vhd
	ghdl -e -o $(TESTDIR)/memory_tb memory_tb
	cd $(TESTDIR) && ghdl -r memory_tb --vcd=memory_tb.vcd

cache_test: cache test_init
	ghdl -a $(CACHEDIR)/cache_tb.vhd
	ghdl -e -o $(TESTDIR)/cache_tb cache_tb
	cd $(TESTDIR) && ghdl -r cache_tb --vcd=cache_tb.vcd

cpu: register alu

register: init
	ghdl -a --ieee=synopsys $(CPUDIR)/registerfile.vhd
	ghdl -e --ieee=synopsys -o $(BUILDDIR)/registerfile registerfile

register_test: register test_init
	ghdl -a --ieee=synopsys $(CPUDIR)/registerfile_tb.vhd
	ghdl -e --ieee=synopsys -o $(TESTDIR)/registerfile_tb registerfile_tb
	cd $(TESTDIR) && ghdl -r registerfile_tb --vcd=registerfile_tb.vcd

alu: init
	ghdl -a --ieee=synopsys $(CPUDIR)/alu.vhd
	ghdl -e --ieee=synopsys -o $(BUILDDIR)/alu alu
	ghdl -a --ieee=synopsys $(CPUDIR)/alufunct_encoder.vhd
	ghdl -e --ieee=synopsys -o $(BUILDDIR)/alufunct_encoder alufunct_encoder
	
alu_test: alu test_init
	ghdl -a --ieee=synopsys $(CPUDIR)/alu_tb.vhd
	ghdl -e --ieee=synopsys -o $(TESTDIR)/alu_tb alu_tb
	cd $(TESTDIR) && ghdl -r alu_tb --vcd=alu_tb.vcd

misc: init
	ghdl -a $(MISCDIR)/busmux21.vhd
	ghdl -e -o $(BUILDDIR)/busmux21 busmux21
	ghdl -a $(MISCDIR)/busmux41.vhd
	ghdl -e -o $(BUILDDIR)/busmux41 busmux41

misc_test: misc test_init
	ghdl -a $(MISCDIR)/busmux41_tb.vhd
	ghdl -e -o $(TESTDIR)/busmux41_tb busmux41_tb
	cd $(TESTDIR) && ghdl -r busmux41_tb --vcd=busmux31_tb.vcd
