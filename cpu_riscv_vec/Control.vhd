library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control is
	port(
		instr	:	in std_logic_vector(31 downto 0); -- entrada de instruções
		stall	:	in std_logic; -- verifica se o hazard permitiu a continuação do processo/
		
		Branch	:	out std_logic; -- 
		MemRead	:	out std_logic; -- ativando a leitura de memória
		MemtoReg:	out std_logic; -- seleciona se o valor será da memória ou diretamente da ULA
		ALUop	:	out std_logic_vector(1 downto 0); -- operação a ser realizada pela ULA
		MemWrite:	out std_logic; -- habilita ou não a escrita na memória
		ALUsrc	:	out std_logic; -- decide a segunda entrada da ULA
		RegWrite:	out std_logic; -- habilita ou não a escrita nos registradores
		funct7	:	out std_logic_vector(6 downto 0); -- configura a memória de instrução da funct7
		funct3	:	out std_logic_vector(2 downto 0); -- configura a memória de instrução da funct3
		opcode	:	out std_logic_vector(6 downto 0); -- configura a memória de instrução do código de operação
		PC_shift_ctrl:	out std_logic; -- controlador que dirá se o endereço PC será shiftado ou não
		JumpReg	:	out std_logic -- controlador que dirá se o endereço no registrador será saltado ou não
	);
end Control;

architecture controler of Control is
	signal oc	:	std_logic_vector(6 downto 0); -- sinal auxiliar para opcode
	signal f7	:	std_logic_vector(6 downto 0); -- sinal auxiliar para funct7
	signal f3	:	std_logic_vector(2 downto 0); -- sinal auxiliar para funct3
	
	begin
		oc <= instr(6 downto 0); -- configurando a operação
		PC_shift_ctrl <= '0'; -- configurando valor inicial para PC_shift_ctrl
		JumpReg <= '0'; -- configurando valor inicial para JumpReg
		
		process(stall) -- verificando se o hazard bloqueou
		begin
			if (stall = '1') then
				Branch <= '0';
				MemRead <= '0';
				MemtoReg <= '0';
				MemWrite <= '0';
				ALUsrc <= '0';
				RegWrite <= '0';
				PC_shift_ctrl <= '0';
				JumpReg <= '0';
			end if;
		end process;
		
		process(oc)
		begin
			if (oc = "0000001") then -- instruções classificadas R-Type
				f7 <= instr(31 downto 25);
				f3 <= instr(14 downto 12);
				Branch <= '0';
				MemRead <= '0';
				MemtoReg <= '0';
				ALUop <= "10";
				MemWrite <= '0';
				ALUsrc <= '0';
				RegWrite <= '1';
			end if;
			if (oc = "0000010") then -- instruções classificadas I-Type
				f7 <= "0000000";
				f3 <= instr(14 downto 12);
				Branch <= '0';
				MemRead <= '0';
				MemtoReg <= '0';
				ALUop <= "10";
				MemWrite <= '0';
				ALUsrc <= '1';
				RegWrite <= '1';
			end if;
			if (oc = "0000011") then -- instrução sw (store word)
				f7 <= "0000000";
				f3 <= "000";
				Branch <= '0';
				MemRead <= '0';
				MemtoReg <= '0';
				ALUop <= "00";
				MemWrite <= '1';
				ALUsrc <= '1';
				RegWrite <= '0';
			end if;
			if (oc = "0000100") then -- instrução beq (branch equal)
				f7 <= instr(31 downto 25);
				f3 <= instr(14 downto 12);
				Branch <= '1';
				MemRead <= '0';
				MemtoReg <= '0';
				ALUop <= "01";
				MemWrite <= '0';
				ALUsrc <= '0';
				RegWrite <= '0';
			end if;
			if (oc = "0000101") then -- instrução bne (branch not equal)
				f7 <= instr(31 downto 25);
				f3 <= instr(14 downto 12);
				Branch <= '1';
				MemRead <= '0';
				MemtoReg <= '0';
				ALUop <= "01";
				MemWrite <= '0';
				ALUsrc <= '0';
				RegWrite <= '0';
			end if;
			if (oc = "0000110") then -- instrução jalr (jump and link rest)
				f7 <= instr(31 downto 25);
				f3 <= "000";
				Branch <= '0';
				MemRead <= '0';
				MemtoReg <= '0';
				ALUop <= "00";
				MemWrite <= '0';
				ALUsrc <= '1';
				RegWrite <= '1';
				JumpReg <= '1';
			end if;
			if (oc = "0000111") then -- instrução jal (jump and link)
				f7 <= "0000000";
				f3 <= "000";
				Branch <= '0';
				MemRead <= '0';
				MemtoReg <= '0';
				ALUop <= "00";
				MemWrite <= '0';
				ALUsrc <= '0';
				RegWrite <= '1';
				PC_shift_ctrl <= '1';
			end if;
			if (oc = "0001000") then -- instrução lw (load word)
				f7 <= "0000000";
				f3 <= "000";
				Branch <= '0';
				MemRead <= '1';
				MemtoReg <= '1';
				ALUop <= "00";
				MemWrite <= '0';
				ALUsrc <= '1';
				RegWrite <= '1';
			end if;
			if (oc = "0001001") then -- instrução lui
				f7 <= "0000000";
				f3 <= "000";
				Branch <= '0';
				MemRead <= '0';
				MemtoReg <= '0';
				ALUop <= "10";
				MemWrite <= '0';
				ALUsrc <= '1';
				RegWrite <= '1';
			end if;
			if (oc = "0001010") then -- instrução auipc
				f7 <= "0000000";
				f3 <= "000";
				Branch <= '0';
				MemRead <= '1';
				MemtoReg <= '1';
				ALUop <= "00";
				MemWrite <= '0';
				ALUsrc <= '1';
				RegWrite <= '1';
				PC_shift_ctrl <= '1';
			end if;
		end process;
		funct7 <= f7;
		funct3 <= f3;
		opcode <= oc;
end controler;
