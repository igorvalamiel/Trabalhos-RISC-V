LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity memwb is
	port(
		-- entradas
		clk	:	in std_logic; -- clock
		RegWrite_in	:	in std_logic; -- Permite ou não a escrita no registrador
		MemtoReg_in	:	in std_logic; -- Indica o dado que será guardado no registrador
		MemData_in	:	in std_logic_vector(31 downto 0); -- Valor lido na memória
		ALUres_in	:	in std_logic_vector(31 downto 0); -- Resultado da ULA
		RegAddrD_in	:	in std_logic_vector(4 downto 0); -- Endereço de instrução alvo
		
		-- saídas
		RegWrite	:	out std_logic; -- Permite ou não a escrita no registrador 
		MemtoReg	:	out std_logic; -- Indica o dado que será guardado no registrador
		MemData		:	out std_logic_vector(31 downto 0); -- Valor lido na memória
		ALUres		:	out std_logic_vector(31 downto 0); -- Resultado da ULA
		RegAddrD	:	out std_logic_vector(4 downto 0) --
	);
end memwb;

architecture machine of memwb is
	signal aux_memwb : std_logic_vector(70 DOWNTO 0); -- sinal auxiliar para memwb
	begin
		process(clk)
		begin
			if (rising_edge(clk)) then -- verifica subida de clock
				aux_memwb(0)   <= RegWrite_in;
				aux_memwb(1)   <= MemToReg_in;  
				aux_memwb(33 downto 2)  <= MemData_in ;       
				aux_memwb(65 downto 34)  <= ALUres_in;   
				aux_memwb(70 downto 66)  <= RegAddrD_in; 
			end if;
			if (falling_edge(clk)) then -- verifica descida de clock
				RegWrite <= aux_memwb(0);    
				MemToReg <= aux_memwb(1);
				MemData <= aux_memwb(33 downto 2);
				ALUres <= aux_memwb(65 downto 34);
				RegAddrD <= aux_memwb(70 downto 66);
			end if;
		end process;
end machine;
