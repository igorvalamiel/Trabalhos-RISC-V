library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity PC is
	port (
		clk	:	in std_logic; -- clock
		reset	:	in std_logic; -- reset
		PC_in	:	in std_logic_vector(31 downto 0); -- entrada de endereço
		PC_write	:	in std_logic; -- marcador para permitir ou não a escrita no PC
		PC_out	:	out std_logic_vector(31 downto 0) -- saída de endereço
	);
end PC;

architecture computer of PC is
	begin
	process(clk, reset, PC_write)
		variable aux0 : std_logic := '0'; -- variavel auxiliar
	begin
		if (reset = '1') then -- verificando se o reset está ativo
			PC_out <= (others => '0');
		end if;
		if (rising_edge(clk)) then -- quando o clock ativar
			if (PC_in = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") then -- se todos os bits estiverem undefined
				PC_out <= (others => '0'); -- zerando o contador
			else
				if (PC_write = '1') then aux0 := '1'; end if; -- mudando aux0
				PC_out <= PC_in + aux0; -- alteração ou manutenção do endereço
			end if;
		end if;
	end process;
end computer;
