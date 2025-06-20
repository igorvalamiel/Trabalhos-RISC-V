library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ULA_control is
	port(
		funct7	:	in std_logic_vector(6 downto 0); -- entrada funct7
		funct3	:	in std_logic_vector(2 downto 0); -- entrada funct3
		opcode	:	in std_logic_vector(6 downto 0); -- entrada opcode
		ALUop	:	in std_logic_vector(1 downto 0); -- entrada operação da ULA
		ALU_ctrl:	out std_logic_vector(3 downto 0); -- saída controle da ULA
		beq_ben	:	out std_logic; -- saída de verificação equal or not equal
		VecSize : 	out std_logic_vector(1 downto 0) -- tamanho da partição
	);
end ULA_control;

architecture controler of ULA_control is
	begin
		process(all)
		begin
			if (ALUop = "00") then -- operação de load
				ALU_ctrl <= "0010";
			elsif (ALUop = "01") then -- operação de Branch
				ALU_ctrl <= "0110";
			else
				if (funct7 = "0100000" and funct3 = "000") then -- subtração
					ALU_ctrl <= "0110";
				elsif (funct3 = "000") then -- soma
					ALU_ctrl <= "0010";
				elsif (funct3 = "001") then -- shift left
					ALU_ctrl <= "0110";
				elsif (funct3 = "100") then -- XOR
					ALU_ctrl <= "0011";
				elsif (funct3 = "101") then -- shift right
					ALU_ctrl <= "0101";
				elsif (funct3 = "110") then -- OR
					ALU_ctrl <= "0111";
				elsif (funct3 = "111") then -- AND
					ALU_ctrl <= "0001";
				end if;
			end if;
			if (opcode="1100011" and funct3="000") then -- marcando beq ou bne
				beq_ben <= '1';
			end if;
			
			-- verifiying VecSize
			VecSize <= opcode(6 downto 5);
			
		end process;
end controler;
