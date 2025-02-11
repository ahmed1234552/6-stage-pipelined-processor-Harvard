


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity processor is
    port (

	   clk : in  std_logic;           -- Clock input
    	   reset : in  std_logic;           -- Reset the stage
	   enable : in  std_logic ;         -- Enable the stage
           data_in: in std_logic_vector(15 downto 0) -- data from in port
	   	   
);
end entity processor;

architecture behavioral of  processor is

 signal f_d_bufffer_out1 :  std_logic_vector(15 downto 0); -- input to decode stage
-----------------------------------------------------------------------------------------------------------
 signal  d_e_bufffer_out1 :  std_logic_vector(61 downto 0); -- input to excute  stage
-----------------------------------------------------------------------------------------------------------  
 signal e_m_bufffer_out1 :  std_logic_vector(64 downto 0) ; -- input to memory stage
----------------------------------------------------------------------------------------------------------- 	   
 signal   m_wb_buffer_out1:  std_logic_vector(64 downto 0) ;-- input to wb stage 
----------------------------------------------------------------------------------------------------------- 	
signal flags_out:  std_logic_vector(2 downto 0);

signal data_out:  std_logic_vector(15 downto 0); -- wb stage outputs
signal  WB:  std_logic;
signal Rdst_out:  std_logic_vector(2 downto 0);
begin

fetch_stage  : ENTITY work.fetch_stage    port map( clk , reset, enable , f_d_bufffer_out1);
decode_stage  : ENTITY work.decode_stage   port map( clk , reset, enable , data_out,Rdst_out,WB, f_d_bufffer_out1, d_e_bufffer_out1);
alu_stage :ENTITY work.alu_stage    port map( clk , reset, enable , d_e_bufffer_out1,e_m_bufffer_out1);

memory_stage :ENTITY work.memory_stage    port map( clk , reset, enable , e_m_bufffer_out1,flags_out,m_wb_buffer_out1);

wb_stage :ENTITY work.wb_stage   port map( clk , reset , m_wb_buffer_out1, data_in ,data_out,WB,Rdst_out);
end architecture behavioral;
