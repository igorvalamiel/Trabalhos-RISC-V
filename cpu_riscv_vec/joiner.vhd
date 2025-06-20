library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity joiner is
	port(
		data_in1 :	in std_logic_vector(15 downto 0); -- entrada de dados 1
		data_in2 :	in std_logic_vector(15 downto 0); -- entrada de dados 2
		data_out	:	out std_logic_vector(31 downto 0) -- saída de dados
	);
end joiner;

architecture div of joiner is
	begin
		data_out(31 downto 16) <= data_in1;
		data_out(15 downto 0) <= data_in2;
end div;