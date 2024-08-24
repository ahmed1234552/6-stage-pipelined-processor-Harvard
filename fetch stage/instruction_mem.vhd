
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity instruction_mem is
    port (

	  read_address_1 : in std_logic_vector(15 downto 0);
          data_out_1: out std_logic_vector(15 downto 0) );
end entity instruction_mem;

architecture behavioral of instruction_mem is

    type register_array is array (0 to 255) of std_logic_vector(15 downto 0);
     signal registers: register_array;
    -- signal lol : std_logic_vector(15 DOWNTO 0);

begin
  process (read_address_1)
  begin
    data_out_1 <= registers(to_integer(unsigned(read_address_1)));
  end process;
    
      
end architecture behavioral;
