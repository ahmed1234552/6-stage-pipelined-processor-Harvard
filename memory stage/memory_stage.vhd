library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity memory_stage is

port (
    clk: in std_logic;
    rst : in std_logic;
    en: in std_logic;
    Buffer_3: in std_logic_vector(64 downto 0);
    flags: out std_logic_vector(2 downto 0);
    Buffer_4: out std_logic_vector(64 downto 0)
);
end memory_stage;

architecture arch of memory_stage is 

signal address: std_logic_vector(9 downto 0);
signal Buffer_3_Reg :  std_logic_vector(48 downto 0); 
signal Buffer_Reg :  std_logic_vector(64 downto 0); 
signal data_buffer: std_logic_vector(15 downto 0);
signal data_out: std_logic_vector(15 downto 0);
signal re,we: std_logic;
signal clk_2:  std_logic:= '0';
-- create a stack pointer with inital value 1022
signal SP: std_logic_vector(9 downto 0) := "1111111110";
begin
   
    re<= Buffer_3(9) or Buffer_3(12) or Buffer_3_Reg(9) or Buffer_3_Reg(12);  -- 16 ALU_reslut 3 flags 16 inst 14 contorls 
    -- make the write enable stored for one cycle
   -- process(clk)
   -- begin
      --  if rising_edge(clk) then
--we <= Buffer_3(10) or Buffer_3(11);
--end if;
   -- end process;
   process(clk)
    begin
         if rising_edge(clk) then
              clk_2 <= not clk_2;
         end if;
    end process;
   data_in_Buffer: ENTITY work.Generic_Register  generic map (16)  port map(clk_2 , rst, en ,   Buffer_3(64 downto 49), data_buffer);
    we<= Buffer_3(10) or Buffer_3(11) or Buffer_3_Reg(11) or Buffer_3_Reg(10);
    ram_inst: entity work.ram port map(
        clk => clk,
        we => we,
        re => re,
        addr => address,
        data_in => data_buffer,
        data_out => data_out
    );
m_m_buffer : ENTITY work.Generic_Register  generic map (49)  port map
( clk , rst, en , Buffer_3(48 downto 0), Buffer_3_Reg);

Buffer_Reg <=  data_out & Buffer_3_Reg;

m_wb_buffer : ENTITY work.Generic_Register  generic map (65)  port map
( clk , rst, en ,Buffer_Reg,  Buffer_4);
    flags <= Buffer_3(32 downto 30);
    address <= Buffer_3(42 downto 33) when (Buffer_3(10) = '0' or Buffer_3_Reg(10)='0') else SP; 
    SP <= std_logic_vector(unsigned(SP) + 1) when (Buffer_3(9) = '1' or Buffer_3_Reg(9)='0') and unsigned(SP) < 1022 else
        std_logic_vector(unsigned(SP) - 1) when (Buffer_3(10) = '1' or Buffer_3_Reg(10)='1') and unsigned(SP) > 922 else SP;

end arch;