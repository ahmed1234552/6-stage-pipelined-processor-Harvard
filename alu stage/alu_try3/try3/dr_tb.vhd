library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu16_dr is
end entity tb_alu16_dr;

architecture test_dr of tb_alu16_dr is

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

        -- test INC instruction
        opc <= "00100";
		op1 <= x"FFFE";
        wait for 80 ps;
        assert res = x"FFFF" and cf = '0' and nf = '1' and zf = '0' report "INC failed"  ;

        -- test INC instruction
        opc <= "00100";
		op1 <= x"FFFF";
        wait for 80 ps;
        assert res = x"0000" and cf = '1' and nf = '0' and zf = '1' report "INC failed"  ;

        -- test INC instruction
        opc <= "00100";
		op1 <= x"0000";
        wait for 80 ps;
        assert res = x"0001" and cf = '0' and nf = '0' and zf = '0' report "INC failed"  ;

        -- -- test AND instruction
        -- opc <= "01100";
        -- op1 <= x"A5A5";
        -- op2 <= x"F0F0";
        -- wait for 80 ps;
        -- assert res = x"A0A0" and nf = '0' and zf = '0' report "AND failed"  ;

        report "End of test bench";

    end process stim_gen;

end architecture test_dr;
