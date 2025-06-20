LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity instr_fetch is
	port (
		-- entradas
		clk	:	in std_logic; -- clock
		PC_write	:	in std_logic; -- marcador para permitir ou não a escrita no PC
		PC_in	:	in std_logic_vector(31 downto 0); -- entrada de endereço
		PC_next_in	:	in std_logic_vector(31 downto 0); -- entrada de próximo endereço
		Inst_in	:	in std_logic_vector(31 downto 0); -- entrada de instruções
		--saídas
		PC_out	:	out std_logic_vector(31 downto 0); -- saída de endereço
		PC_next_out	:	out std_logic_vector(31 downto 0); -- saída de próximo endereço
		Inst_out	:	out std_logic_vector(31 downto 0); -- saída de instruções
		RegAddr1	:	out std_logic_vector(4 downto 0); -- endereço do registrador 1 para leitura
		RegAddr2	:	out std_logic_vector(4 downto 0); -- endereço do registrador 2 para leitura
		RegAddrW	:	out std_logic_vector(4 downto 0) -- endereço de um registrador para ser escrito
	);
end instr_fetch;

architecture instr_mem of instr_fetch is

	signal opcode	:	std_logic_vector(6 downto 0); -- sinal de operação
	signal rs1	:	std_logic_vector(4 downto 0); -- sinal auxiliar para RegAddr1
	signal rs2	:	std_logic_vector(4 downto 0); -- sinal auxiliar para RegAddr2
	signal rd	:	std_logic_vector(4 downto 0); -- sinal auxiliar para RegAddrW
	signal idif	:	std_logic_vector(117 downto 0); -- sinal usado como registrador de 118 bits
	
	begin
		opcode <= Inst_in(6 downto 0); -- selecionando a operação
		
		process(opcode)
			begin
			-- operações com formato R, I, U ou J possuem rd
				-- todas exceto: sw, beq, bne
			if not (opcode = "0100011" or opcode = "1100011") then
				rd <= Inst_in(11 downto 7); -- carregando rs1
			end if;
			
			-- operações com formato R, I, S ou B possuem rs1
				-- todas exceto: auipc, lui e jal
			if not (opcode = "1101111" or opcode = "0110111") then
				rs1 <= Inst_in(19 downto 15); -- carregando rs1
			end if;
			
			-- operações com formato R, S ou B possuem rs2
				-- add, sub, and, or, xor, sll, srl, sw, beq, bne
			if (opcode = "0110011" or opcode = "0100011" or opcode = "1100011") then
				rs2 <= Inst_in(24 downto 20); -- carregando rs1
			end if;
		end process;
		
		process(clk, PC_write)
			begin
			if (rising_edge(clk)) then -- quando o clock ativar
				if (PC_write = '1') then -- se a escrita estiver permitida, os valores são guardados em idif
					idif(31 DOWNTO 0) <= Inst_in;
					idif(63 DOWNTO 32) <= PC_in;
					idif(95 downto 64) <= PC_next_in;
					idif(102 downto 96) <= opcode;
					idif(107 downto 103) <= rs1;
					idif(112 downto 108) <= rs2;
					idif(117 downto 113) <= rd;
				end if;
			end if;
			if (falling_edge(clk)) then -- quando o clock destivar, retornar os valores adiante
				Inst_out <= idif(31 downto 0);
				PC_out <= idif(63 downto 32);
				PC_next_out <= idif(95 downto 64);
				RegAddr1 <= idif(107 downto 103);
				RegAddr2 <= idif(112 downto 108);
				RegAddrW <= idif(117 downto 113);
			end if;
		end process;	

end instr_mem;