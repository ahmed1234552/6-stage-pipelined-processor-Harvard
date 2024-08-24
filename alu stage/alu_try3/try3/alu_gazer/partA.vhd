Library ieee;
use ieee.std_logic_1164.all;

--This is Part A

entity partA is
generic (n : integer := 8);
port(
   a,b: in std_logic_vector(n-1 downto 0);
   cin: in std_logic;
   s: in std_logic_vector(1 downto 0);
   f: out std_logic_vector(n-1 downto 0);
   cout: out std_logic
);
end entity;

architecture dataflow of partA is

  	component my_nadder IS
		generic (n : integer := 16);
		PORT   (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
                cin : IN std_logic;
                s : OUT std_logic_vector(n-1 DOWNTO 0);
                cout : OUT std_logic);

	end component ;
signal tempB , tempF:  std_logic_vector(n-1 downto 0); 


begin

	with s select
		tempB <=
			(Others => '0') when "00", b when "01", not b  when "10", (Others => '1') when others;

	u0: my_nadder GENERIC MAP (n) PORT MAP (a,tempB,cin,tempF,cout);

	f <= b  when s(1)='1' and s(0)='1' and cin ='1'
	else tempF ;

end dataflow ;
