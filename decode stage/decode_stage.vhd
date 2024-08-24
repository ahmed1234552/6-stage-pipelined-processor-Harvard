

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity decode_stage is
    port (

	   clk : in  std_logic;           -- Clock input
    	   reset : in  std_logic;           -- Reset the stage
	   enable : in  std_logic;          -- Enable the stage
           data_in: in std_logic_vector(15 downto 0); -- from write back stage 
	   write_address: in std_logic_vector(2 downto 0); -- Rdst from write back stage 
	   wb_in : in  std_logic;          -- WB control signal from write back stage 
	   f_d_bufffer_out: in std_logic_vector(15 downto 0); -- The input from the fetch stage  
	   d_e_bufffer_out : out std_logic_vector(61 downto 0)
	   
);
end entity decode_stage;

architecture behavioral of decode_stage is

 signal rsrc1, rsrc2:  std_logic_vector(15 downto 0) ;
-----------------------------------------------------------------------------------------------------------

-- control signals from the controller
signal  wb,mem_rd,mem_wr,stck_wr,stck_rd ,pc_to_stck,port_wr,port_rd,
ldm,alu_op,rtrn_pc_signal,rti,alu_src,branch :  std_logic ;

-----------------------------------------------------------------------------------------------------------     
signal d_e_bufffer_in :  std_logic_vector(61 downto 0); --rsrc1 & rscc2 & instruction & control signals 
begin
--fetch_inst : fetch port map( clk , reset, en , fetch_out);

controller: ENTITY work.controller port map(f_d_bufffer_out (15 downto 11),wb,mem_rd,mem_wr,stck_wr,stck_rd ,
pc_to_stck,port_wr,port_rd,
ldm,alu_op,rtrn_pc_signal,rti,alu_src,branch);


registers_mem:ENTITY work.register_file port map(clk,wb_in,'0',f_d_bufffer_out(7 downto 5)
,f_d_bufffer_out(4 downto 2),write_address ,  data_in, rsrc1, rsrc2 ); -- registers memory



d_e_bufffer : ENTITY work.Generic_Register  generic map (62)  port map( clk , reset, enable , d_e_bufffer_in,d_e_bufffer_out);

d_e_bufffer_in <= rsrc1 & rsrc2 & f_d_bufffer_out & wb & mem_rd & mem_wr & stck_wr & 
stck_rd & pc_to_stck & port_wr & port_rd &
ldm & alu_op & rtrn_pc_signal & rti & alu_src& branch; 
end architecture behavioral;