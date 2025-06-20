library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity ULA is
	port(
		Entry1	:	in std_logic_vector(31 downto 0); -- entrada 1 da ULA
		Entry2	:	in std_logic_vector(31 downto 0); -- entrada 2 da ULA
		control	:	in  std_logic_vector(3 downto 0); -- controle da ULA
		result	:	out std_logic_vector(31 downto 0); -- saída da ULA
		zero_flag:	out std_logic -- flag se o resultado for zero
	);
end ULA;

architecture machine of ULA is
	signal res :  std_logic_vector(31 downto 0); -- sinal auxiliar para o resultado
	
	begin
		process(control)
		begin
			if (control = "0010") then -- soma
				res <= (Entry1 + Entry2);
			elsif (control = "0110") then -- subtração
				res <= (Entry1 - Entry2);
			elsif (control = "0101") then -- XOR
				res <= (Entry1 XOR Entry2);
			elsif (control = "0001") then -- OR
				res <= (Entry1 OR Entry2);
			elsif (control = "0000") then -- AND
				res <= (Entry1 AND Entry2);
			elsif (control = "0011") then -- shift left
				res <= (std_logic_vector(shift_left(unsigned(Entry1), to_integer(unsigned(Entry2)))));
			elsif (control = "0111") then -- shift right
				res <= (std_logic_vector(shift_right(unsigned(Entry1), to_integer(unsigned(Entry2)))));
			end if;
		end process;
	result <= res;
	zero_flag <= '1' when res = "00000000000000000000000000000000" else '0'; -- marcando a flag se o valor for zero

end machine;
