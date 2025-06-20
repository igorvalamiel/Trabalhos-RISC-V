library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Forward is
	port(
		clk	:	in std_logic; -- clock
		WBregWrite	:	in std_logic; -- verifica se está liberada a escrita em WB
		MEMregWrite	:	in std_logic; -- verifica se está liberada a escrita em MEM
		RegAddr1	:	in std_logic_vector(4 downto 0); -- Registrador 1
		RegAddr2	:	in std_logic_vector(4 downto 0); -- Registrador 2
		WBregD		:	in std_logic_vector(4 downto 0); -- Registrador alvo de WB
		MEMregD		:	in std_logic_vector(4 downto 0); -- Registrador alvo de MEM
		Forward1	:	out std_logic_vector(1 downto 0); -- Saída com foward para reg1
		Forward2	:	out std_logic_vector(1 downto 0) -- Saída com forward para reg2
	);
end Forward;

architecture operation of Forward is
	signal fwrd1 :	std_logic_vector(1 downto 0) := "00"; -- sinal auxiliar para Forward1
	signal fwrd2 :	std_logic_vector(1 downto 0) := "00"; -- sinal auxiliar para Forward2
	
	begin
		process(clk)
		begin
			if ((MEMregWrite = '1') and (not(MEMregD = "0000"))) then
				if (MEMregD = RegAddr1) then
					fwrd1 <= "10";
				end if;
				if (MEMregD = RegAddr2) then
					fwrd2 <= "10";
				end if;
			end if;
			if ((WBregWrite = '1') and (not(WBregD = "0000"))) then
				if (WBregD = RegAddr1) then
					fwrd1 <= "01";
				end if;
				if (WBregD = RegAddr2) then
					fwrd2 <= "01";
				end if;
			end if;
		end process;
	Forward1 <= fwrd1;
	Forward2 <= fwrd2;
end operation;
