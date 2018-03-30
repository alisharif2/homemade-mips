library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity if_stage is
    PORT (
        new_addr:   IN STD_LOGIC_VECTOR(31 downto 0);   -- incoming pc address
        pc_en:      IN STD_LOGIC;                       -- enable line to increment pc (low when stalling)
        clock:      IN STD_LOGIC;
        q_new_addr: OUT STD_LOGIC_VECTOR(31 downto 0);  -- outputs pc + 4
        q_instr:    OUT STD_LOGIC_VECTOR(31 downto 0)   -- outputs instruction fetched from memory
    );
END if_stage;

ARCHITECTURE fetch OF if_stage IS
    -- INSTRUCTION MEMORY COMPONENT
    COMPONENT memory is 
		GENERIC(
		    ram_size : INTEGER := 32768;
		    mem_delay : time := 0 ns;
		    clock_period : time := 1 ns;
            init_file: string := "program.txt"
		);
		PORT (
		    clock: IN STD_LOGIC;
		    writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		    address: IN INTEGER RANGE 0 TO ram_size-1;
		    memwrite: IN STD_LOGIC;
		    memread: IN STD_LOGIC;
		    readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		    WAITrequest: OUT STD_LOGIC
		);
	END COMPONENT;

    -- SIGNALS
    SIGNAL pc: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    SIGNAL m_addr : integer range 0 to 2147483647 := 0;
	SIGNAL m_readdata : std_logic_vector (31 downto 0) := (others => '0'); 
    
BEGIN
    -- Initialized memory for reading only
    instr_mem : memory
    PORT MAP (
        clock => clock,
		writedata => x"0000_0000",
		address => m_addr,
		memwrite => '0',
		memread => '1',
		readdata => q_instr,
		WAITrequest => open
    );

    fetch_process : process(clock)
    BEGIN
        if(rising_edge(clock)) then
            if(pc_en = '1') then
                pc <= new_addr;
                q_new_addr <= std_logic_vector(unsigned(pc) + 4); -- increment pc by 4
            end if;
        end if;
        m_addr <= to_integer(unsigned(pc));
    END process;
END fetch;
