
library ieee;
use ieee.std_logic_1164.all;
entity wb_stage is
    port(
        clk: in std_logic;
        rst: in std_logic;
        buffer_in: in std_logic_vector(64 downto 0);
        data_in: in std_logic_vector(15 downto 0);
        data_out: out std_logic_vector(15 downto 0);
	WB: out std_logic;
        Rdst_out: out std_logic_vector(2 downto 0)
    );
end wb_stage ;
architecture Behavioral of wb_stage  is
begin
    -- create a mux that takes 
    data_out<=buffer_in(64 downto 49) when (buffer_in(12)='1' or buffer_in(9)='1')
    else  buffer_in(48 downto 33) when buffer_in(4)='1'
    else data_in when buffer_in(7)='1'
    else   (others => '0');

    WB<=buffer_in(13);
    Rdst_out<=buffer_in(24 downto 22);
end Behavioral;