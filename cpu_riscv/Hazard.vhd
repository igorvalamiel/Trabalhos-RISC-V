library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Hazerd is
	port(
		clk:	in std_logic; -- clock
		MemRead		:	in std_logic; -- sinal que decide se a memória será lida ou não
		RegAddr1	:	in std_logic_vector(4 downto 0); -- endereço do registrador 1
		RegAddr2	:	in std_logic_vector(4 downto 0); -- endereço do registrador 2
		RegAddrD	:	in std_logic_vector(4 downto 0); -- endereço de um registrador destino
		
		stall:	out std_logic -- retorno que controla as operações no pipeline
	);
end Hazerd;

architecture verify of Hazerd is
	signal aux_stall : std_logic := '0'; -- sinal auxiliar para o stall
	
	begin
		process(clk) -- verificando clock
		begin -- se algum endereço de leitura for igual ao de escrita retorna True para stall
			if((MemRead = '1') and ((RegAddrD = RegAddr1) or (RegAddrD = RegAddr2))) then 
				aux_stall <= '1';
			end if;
		end process;
	stall <= aux_stall;
end verify;
