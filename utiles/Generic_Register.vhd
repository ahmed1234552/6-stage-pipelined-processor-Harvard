library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity Generic_Register is
  generic(
    n     : integer := 16  -- Width of the register
      );
  port (
    clk        : in  std_logic;           -- Clock input
    reset      : in  std_logic;           -- Reset input
    enable     : in  std_logic;           -- Enable input
    data_in    : in  std_logic_vector(n-1 downto 0); -- Data input
    data_out   : out std_logic_vector(n-1 downto 0)  -- Data output
  );
end Generic_Register;

architecture Behavioral of Generic_Register is

begin
  process (clk, reset)
  begin
    if reset = '1' then
      data_out <= (others => '0') ;  -- Reset the register to the initial value
    elsif rising_edge(clk) then
      if enable = '1' then
        data_out <= data_in; -- Update the register with the input data
      end if;
    end if;
  end process;
end Behavioral;

