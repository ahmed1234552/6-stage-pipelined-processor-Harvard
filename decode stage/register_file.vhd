library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity register_file is
    port (
        clk: in std_logic;
 	write_en, reset: in std_logic;
	read_address_0, read_address_1 : in std_logic_vector(2 downto 0);
      	 write_address: in std_logic_vector(2 downto 0);
        data_in: in std_logic_vector(15 downto 0);
        data_out_0, data_out_1: out std_logic_vector(15 downto 0) );
end entity register_file;

architecture behavioral of register_file is
    type register_array is array (0 to 7) of std_logic_vector(15 downto 0);
     signal registers: register_array;
     --signal lol : std_logic_vector(7 DOWNTO 0);

begin

       process (clk, reset)
    begin
        if (reset = '1') then
            for i in 0 to 7 loop
                registers(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            if (write_en = '1') then
                registers(to_integer(unsigned(write_address))) <= data_in;
            end if;
        end if;
    end process;
    
    data_out_0 <= registers(to_integer(unsigned(read_address_0)));
    data_out_1 <= registers(to_integer(unsigned(read_address_1)));
    	
    
end architecture behavioral;

