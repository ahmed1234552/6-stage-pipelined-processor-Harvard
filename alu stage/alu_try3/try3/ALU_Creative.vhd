library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_16bit is
    Port ( clk : in std_logic;
           reset : in std_logic;
           opcode : in std_logic_vector(4 downto 0);
           operand1 : in std_logic_vector(15 downto 0);
           operand2 : in std_logic_vector(15 downto 0);
           result : out std_logic_vector(15 downto 0);
           carry_flag : out std_logic;
           zero_flag : out std_logic;
           negative_flag : out std_logic);
end alu_16bit;

architecture Behavioral of alu_16bit is

    --alu part a signals
    signal alu_selector : std_logic_vector(1 downto 0);
    signal alu_result : std_logic_vector(15 downto 0);
    signal alu_a : std_logic_vector(15 downto 0);
    signal alu_b : std_logic_vector(15 downto 0);
    signal alu_carry : std_logic;
    signal alu_cin : std_logic;

    begin

    x:entity work.partA generic map (16) port map (alu_a, alu_b, alu_cin, alu_selector, alu_result, alu_carry);

    process ( reset, opcode, operand1, operand2, alu_result, alu_carry)

        variable temp_result : std_logic_vector(16 downto 0);

    begin

        if reset = '1' then
            result <= (others => '0');
			carry_flag <= '0';
			zero_flag <= '0';
			negative_flag <= '0';

        else
        --operand 1 rsrc1,operand 2 rsrc2 or immediate or offset
		case opcode is---------------please note that signal changes their value in the end of the process

                when "00000" => -- NOP
                    null;

                when "00001" => -- SETC
                    carry_flag <= '1';

                when "00010" => -- CLRC
                   carry_flag <= '0';

                when "00011" => -- NOT
                    temp_result(15 downto 0) := not operand1;
                    if temp_result(15 downto 0) = x"0000" then
                        zero_flag <= '1';
                    else
                        zero_flag <= '0';
                    end if ;
                    if signed(temp_result(15 downto 0)) < 0 then
                        negative_flag <= '1';
                    else
                        negative_flag <= '0';
                    end if ;

                when "00100" => -- INC
                    alu_a <= operand1;
                    alu_b <= operand2;--remove this line
                    alu_selector <= "00";
                    alu_cin <= '1';
                    temp_result(15 downto 0) := alu_result;--x"1266";
                    if temp_result(15 downto 0) = x"0000" then
                        zero_flag <= '1';
                    else
                        zero_flag <= '0';
                    end if ;
                    if signed(temp_result(15 downto 0)) < 0 then
                        negative_flag <= '1';
                    else
                        negative_flag <= '0';
                    end if ;
                    carry_flag <= alu_carry;
                when "00101" => -- DEC
                    alu_a <= operand1;
                    alu_b <= operand2;--remove this line
                    alu_selector <= "11";
                    alu_cin <= '0';
                    temp_result(15 downto 0) := alu_result;
                    temp_result(15 downto 0) := alu_result;--x"1266";
                    if temp_result(15 downto 0) = x"0000" then
                        zero_flag <= '1';
                    else
                        zero_flag <= '0';
                    end if ;
                    if signed(temp_result(15 downto 0)) < 0 then
                        negative_flag <= '1';
                    else
                        negative_flag <= '0';
                    end if ;
                    carry_flag <= alu_carry;

                when "00110" => -- OUT
                    temp_result(15 downto 0) := operand1;

                when "00111" => -- IN
                    temp_result(15 downto 0) := operand1;

                when "01000" => -- MOV
                    temp_result(15 downto 0) := operand1;

                when "01001" => -- ADD
                    alu_a <= operand1;
                    alu_b <= operand2;
                    alu_selector <= "01";
                    alu_cin <= '0';
                    temp_result(15 downto 0) := alu_result;

                    carry_flag <= alu_carry;
                    if signed(temp_result(15 downto 0)) = 0 then
                        zero_flag <= '1';
                    else
                        zero_flag <= '0';
                    end if ;
					if signed(temp_result(15 downto 0)) < 0 then
                        negative_flag <= '0';
                        else
                        negative_flag <= '1';
                    end if ;

                when "01010" => -- IADD
                    alu_a <= operand1;
                    alu_b <= operand2;
                    alu_selector <= "01";
                    alu_cin <= '0';
                    temp_result(15 downto 0) := alu_result;

                    carry_flag <= alu_carry;
                    if signed(temp_result(15 downto 0)) = 0 then
                        zero_flag <= '1';
                    else
                        zero_flag <= '0';
                    end if ;
					if signed(temp_result(15 downto 0)) < 0 then
                         negative_flag <= '0';
                        else
                            negative_flag <= '1';
                    end if ;

				when "01011" => -- SUB
                    alu_a <= operand1;
                    alu_b <= operand2;
                    alu_selector <= "10";
                    alu_cin <= '1';
                    temp_result(15 downto 0) := alu_result;

                    carry_flag <= alu_carry;
                    if signed(temp_result(15 downto 0)) = 0 then
                        zero_flag <= '1';
                    else
                        zero_flag <= '0';
                    end if ;
					if signed(temp_result(15 downto 0)) < 0 then
                         negative_flag <= '0';
                        else
                            negative_flag <= '1';
                    end if ;

				when "01100" => -- AND
                    temp_result(15 downto 0) := operand1 and operand2;
                    if signed(temp_result(15 downto 0)) = 0 then
                        zero_flag <= '1';
                    else
                        zero_flag <= '0';
                    end if ;
					if signed(temp_result(15 downto 0)) < 0 then
                         negative_flag <= '0';
                        else
                            negative_flag <= '1';
                    end if ;

                when "01101" => -- OR
                    temp_result(15 downto 0) := operand1 or operand2;
                    if signed(temp_result(15 downto 0)) = 0 then
                        zero_flag <= '1';
                    else
                        zero_flag <= '0';
                    end if ;
					if signed(temp_result(15 downto 0)) < 0 then
                         negative_flag <= '0';
                        else
                            negative_flag <= '1';
                    end if ;

                when "10000" => -- LDM
                    temp_result(15 downto 0) := operand2;--immediate value is operand2

                when "10001" => -- LDD
                    temp_result(15 downto 0) := operand1;

                when "10010" => -- STD
                    temp_result(15 downto 0) := operand1;

                when others =>
                    null;

            end case;
		result <= temp_result(15 downto 0);
        end if;
    end process;

end Behavioral;