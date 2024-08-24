
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ram is
    generic(
        addr_width: integer := 10;
        data_width: integer := 16
    );
port(
    clk: in std_logic;
    we: in std_logic;
    re: in std_logic;
    addr: in std_logic_vector(addr_width-1 downto 0);
    data_in: in std_logic_vector(data_width-1 downto 0);
    data_out: out std_logic_vector(data_width-1 downto 0)
);
end ram;
architecture rtl of ram is
    type ram_type is array(0 to 2**addr_width-1) of std_logic_vector(data_width-1 downto 0);
    signal clk_2: std_logic:= '0';
    signal ram: ram_type;
begin
    -- divide the clock by 2
    process(clk)
    begin
        if rising_edge(clk) then
            clk_2 <= not clk_2;
        else
            clk_2 <= clk_2;
        end if;
    end process;
    process(clk_2)
    begin
        if rising_edge(clk_2) then
            if we = '1' then --control unit set we or re inly not both of them --and re='0'
                ram(to_integer(unsigned(addr))) <= data_in;
else 

                null;
            end if;
        end if;
    end process;
data_out <= ram(to_integer(unsigned(addr)));
end rtl;