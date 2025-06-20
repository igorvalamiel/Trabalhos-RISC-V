library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ImmGen is
	port(
		instr:	in std_logic_vector(31 downto 0); -- entrada de instrução
		imm	:	out std_logic_vector(31 downto 0) -- saída de número com valor imediato
	);
end ImmGen;

architecture generator of ImmGen is
	signal oc	:	std_logic_vector(6 downto 0); -- código da operação
	signal imm_aux:	std_logic_vector(31 downto 0) := "00000000000000000000000000000000"; -- definição do imm
	
	begin 
		oc <= instr(6 downto 0); -- configurando operação
		process(oc)
		begin
			if (oc="0010011" or oc="1100110" or oc="0000011") then -- I-Type
				imm_aux(11 downto 0) <= instr(31 downto 20);
				imm_aux(31 downto 12) <= (others => instr(31));
			elsif (oc="0100011") then -- S-Type
				imm_aux(11 downto 5) <= instr(31 downto 25);
				imm_aux(4 downto 0) <= instr(11 downto 7);
				imm_aux(31 downto 12) <= (others => instr(31));
			elsif (oc="1100111" or oc="1100011") then -- B-Type
				imm_aux(12) <= instr(31);
				imm_aux(11) <= instr(7);
				imm_aux(10 downto 5) <= instr(30 downto 25);
				imm_aux(4 downto 1) <= instr(11 downto 8);
				imm_aux(31 downto 13) <= (others => instr(31));
			elsif (oc="0110111" or oc="1110111") then -- U-Type
				imm_aux(31 downto 12) <= instr(31 downto 12);
			elsif (oc="1101111") then -- J-Type
				imm_aux(20) <= instr(31);
				imm_aux(10 downto 1) <= instr(30 downto 21);
				imm_aux(11) <= instr(20);
				imm_aux(19 downto 12) <= instr(19 downto 12);
				imm_aux(31 downto 21) <= (others => instr(31));
			end if;
		end process;
	imm <= imm_aux;
end generator;
