
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity fetch_stage is
    port (

	   clk : in  std_logic;           -- Clock input
    	   reset : in  std_logic;           -- Reset input
	   enable : in  std_logic;          -- Enable input
	   f_d_bufffer_out : out std_logic_vector(15 downto 0)
	   
);
end entity fetch_stage;

architecture behavioral of fetch_stage is

    -- signal lol : std_logic_vector(15 DOWNTO 0);
signal initial_pc:  std_logic_vector(15 downto 0):=(others => '0');
signal pc_output :  std_logic_vector(15 downto 0):=(others => '0');
signal instruction :  std_logic_vector(15 downto 0);
signal f_d_bufffer_in :  std_logic_vector(15 downto 0);
begin
--fetch_inst : fetch port map( clk , reset, en , fetch_out);
pc : ENTITY work.Generic_Register  port map( clk , reset, enable , initial_pc,pc_output);
instruction_cashe:ENTITY work.instruction_mem port map(pc_output,instruction);
f_d_bufffer : ENTITY work.Generic_Register  generic map (16)  port map( clk , reset, enable , f_d_bufffer_in,f_d_bufffer_out);

 f_d_bufffer_in  <= instruction   ; -- concatentaion  of instruction and current pc 

process (pc_output,reset)
  begin
    if(reset = '1') then
   initial_pc <=(others => '0');
  else
    initial_pc <= std_logic_vector(unsigned(initial_pc) + 1);
end if;

  end process;

end architecture behavioral;
