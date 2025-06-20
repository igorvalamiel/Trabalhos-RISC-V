LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL; 

entity adder is
	port(
		Entry1	:	in std_logic_vector(31 downto 0); -- entrada 1 (32 bits)
		Entry2	:	in std_logic_vector(31 downto 0); -- entrada 2 (32 bits)
		Sum	:	out std_logic_vector(31 downto 0) -- resultado da soma (32 bits)
	);
end adder;

architecture calculator of adder is
	begin
		Sum <= Entry1 + Entry2;
end calculator;
