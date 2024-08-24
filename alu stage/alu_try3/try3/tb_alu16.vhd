library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu16 is
end entity tb_alu16;

architecture test of tb_alu16 is

    component alu_16bit -- component declaration of the ALU
    Port ( clk : in std_logic;
           reset : in std_logic;
           opcode : in std_logic_vector(4 downto 0);
           operand1 : in std_logic_vector(15 downto 0);
           operand2 : in std_logic_vector(15 downto 0);
           result : out std_logic_vector(15 downto 0);
           carry_flag : out std_logic;
           zero_flag : out std_logic;
           negative_flag : out std_logic);
    end component alu_16bit;

    signal clk_tb : std_logic := '0'; -- clock signal
    signal rst : std_logic := '0'; -- reset signal
    signal opc : std_logic_vector(4 downto 0) := (others => '0'); -- operation code
    signal op1 : std_logic_vector(15 downto 0) := (others => '0'); -- first operand
    signal op2 : std_logic_vector(15 downto 0) := (others => '0'); -- second operand
    signal res : std_logic_vector(15 downto 0); -- output result
    signal cf : std_logic; -- carry flag
    signal zf : std_logic; -- zero flag
    signal nf : std_logic; -- negative flag

begin

    uut: alu_16bit port map (clk_tb, rst, opc, op1, op2, res, cf, zf, nf); -- instantiate the ALU

    clk_tb_gen: process -- clock generator process
    begin
        wait for 10 ps;
        clk_tb <= not clk_tb;
    end process clk_tb_gen;

    rst_gen: process -- reset generator process
    begin
        wait for 40 ps;
        rst <= '1';
        wait for 40 ps;
        rst <= '0';
        wait;
    end process rst_gen;

    stim_gen: process -- stimulus generator process
    begin
        wait for 80 ps; -- wait for reset to finish

        -- test NOP instruction
        opc <= "00000";
        wait for 40 ps;
        assert res = x"1234" report "NOP failed"  ;

        -- test SETC instruction
        opc <= "00001";
        wait for 80 ps;
        assert cf = '1' report "SETC failed"  ;

        -- test CLRC instruction
        opc <= "00010";
        wait for 80 ps;
        assert cf = '0' report "CLRC failed"  ;


        -- test NOT instruction
        opc <= "00011";
        op1 <= x"DEAD";
        wait for 80 ps;
        assert res = x"2152" and nf = '0' and zf = '0' report "NOT failed"  ;


        -- test INC instruction
        opc <= "00100";
		op1 <= x"BEEF";
        wait for 80 ps;
        assert res = x"BEF0" and cf = '0' and nf = '0' and zf = '0' report "INC failed"  ;


        -- test DEC instruction
        opc <= "00101";
        op1 <= x"0001";
        wait for 80 ps;
        assert res = x"0000" and cf = '0' and nf = '0' and zf = '1' report "DEC failed"  ;

        -- test OUT instruction
        opc <= "00110";
        op1 <= x"CAFE";
        wait for 80 ps;
        assert res = x"CAFE" report "OUT failed"  ;

        -- test MOV instruction
        opc <= "01000";
        op1 <= x"F00D";
        wait for 80 ps;
        assert res = x"F00D" report "MOV failed"  ;

        -- test ADD instruction
        opc <= "01001";
        op1 <= x"1234";
        op2 <= x"5678";
        wait for 80 ps;
        assert res = x"68AC" and cf = '0' and nf = '0' and zf = '0' report "ADD failed"  ;

        -- test IADD instruction
        opc <= "01010";
        op1 <= x"FFFF";
        op2 <= x"0001";
        wait for 80 ps;
        assert res = x"0000" and cf = '1' and nf = '0' and zf = '1' report "IADD failed"  ;

        -- test SUB instruction
        opc <= "01011";
        op1 <= x"A7C2";--ABCD
        op2 <= x"A4C9";--CDEF
        wait for 80 ps;
        -- assert res = x"E2DE" and cf = '1' and nf = '1' and zf = '0' report "SUB failed"  ;
        assert res = x"0307" and cf = '0' and nf = '1' and zf = '0' report "SUB failed"  ;


        -- test AND instruction
        opc <= "01100";
        op1 <= x"A5A5";
        op2 <= x"F0F0";
        wait for 80 ps;
        assert res = x"A0A0" and nf = '0' and zf = '0' report "AND failed"  ;


		-- test OR instruction
        opc <= "01101";
        op1 <= x"A5A5";
        op2 <= x"F0F0";
        wait for 80 ps;
        assert res = x"F5F5" report "OR failed"  ;

        -- LDM: load op2 with immediate value
        --opc <= "10000"; -- operation code for LDM
        --op1 <= x"F00D";
		--op2 <= x"ABCD"; -- some immediate value for op2
        --wait for 80 ps;
        --assert res = x"ABCD" report "LDM failed" severity error; -- check if the res is equal to op2
        --assert cf = '0' report "LDM set carry flag" severity error; -- check if the carry flag is cleared
        --assert nf = '1' report "LDM cleared negative flag" severity error; -- check if the negative flag is set (since op2 is negative)
        --assert zf = '0' report "LDM set zero flag" severity error; -- check if the zero flag is cleared

        -- LDD: load op2 with data from memory address in op1
        --opc <= "10001"; -- operation code for LDD
        --op1 <= x"000A"; -- some memory address for op1
        --wait until rising_edge(clk_tb); -- wait for a clock cycle to simulate memory access
        --op2 <= x"FEDC"; -- some data from memory for op2 (should be assigned by the memory module)
        --wait for 80 ps;
        --assert res = x"FEDC" report "LDD failed" severity error; -- check if the res is equal to op2
        --assert cf = '0' report "LDD set carry flag" severity error; -- check if the carry flag is cleared
        --assert nf = '1' report "LDD cleared negative flag" severity error; -- check if the negative flag is set (since op2 is negative)
        --assert zf = '0' report "LDD set zero flag" severity error; -- check if the zero flag is cleared

        -- STD: store data from op2 to memory address in op1
        -- opc <= "10010"; -- operation code for STD
        -- op1 <= x"000B"; -- some memory address for op1
        -- op2 <= x"CDEF"; -- some data to store in memory for op2
        -- wait until rising_edge(clk_tb); -- wait for a clock cycle to simulate memory access
        -- res <= x"CDEF"; -- some data from memory for res (should be assigned by the memory module)
        -- wait for 80 ps;
        -- assert res = x"CDEF" report "STD failed" severity error; -- check if the res is equal to op2 (or the data stored in memory)
        -- assert cf = '0' report "STD set carry flag" severity error; -- check if the carry flag is cleared
        -- assert nf = '1' report "STD cleared negative flag" severity error; -- check


        -- test invalid op_code
        opc <= "11001";
        wait for 80 ps;
        assert false report "Invalid operation code" ;

        report "End of test bench";

    end process stim_gen;

end architecture test;
