
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity alu_stage is
    port (

	   clk : in  std_logic;           -- Clock input
    	   reset : in  std_logic;           -- Reset input
	   enable : in  std_logic;          -- Enable input
	   d_e_bufffer_out : in std_logic_vector(61 downto 0); --rsrc1 & rscc2 & instruction & control signals 
	   e_m_bufffer_out : out std_logic_vector(64 downto 0)	
	   
);
end entity alu_stage;

architecture behavioral of alu_stage is

    -- signal lol : std_logic_vector(15 DOWNTO 0);
signal alu_result:  std_logic_vector(15 downto 0):=(others => '0');
-------------------------------
-- flags
	 signal   carry_flag, zero_flag,negative_flag : std_logic;
-------------------------------

signal e_m_bufffer_in :  std_logic_vector(64 downto 0); --alu result & flags & instruction & control signals 
begin

alu : ENTITY work.alu_16bit    port map( clk , reset,d_e_bufffer_out (29 downto 25)  ,d_e_bufffer_out (61 downto 46),d_e_bufffer_out (45 downto 30)
, alu_result ,carry_flag, zero_flag,negative_flag);

e_m_bufffer : ENTITY work.Generic_Register  generic map (65)  port map( clk , reset, enable , e_m_bufffer_in,e_m_bufffer_out);
e_m_bufffer_in <= d_e_bufffer_out (61 downto 46)&alu_result & carry_flag & zero_flag & negative_flag& d_e_bufffer_out (29 downto 0);

end architecture behavioral;
