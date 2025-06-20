LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity exmem is
	port(
		-- entradas
		clk	:	in std_logic; -- clock
		Branch_in	:	in std_logic; -- control input
		MemRead_in	:	in std_logic; -- control input
		MemtoReg_in	:	in std_logic; -- control input
		MemWrite_in	:	in std_logic; -- control input
		RegWrite_in	:	in std_logic; -- control input
		PC2_in	:	in std_logic_vector(31 downto 0); -- novo valor para o PC input
		Db_in	:	in std_logic_vector(31 downto 0); -- registradores input
		RegAddrD_in	:	in std_logic_vector(4 downto 0); -- ifid input
		zero_flag_in:	in std_logic; -- Flag da ULA com resultado zero
		ALUres_in	:	in std_logic_vector(31 downto 0); -- Resultado da ULA
		jar_in		:	in std_logic; -- Entrada q indica a operação JALR ou JAL
		
		-- saídas
		Branch	:	out std_logic; -- control output
		MemRead	:	out std_logic; -- control output
		MemtoReg	:	out std_logic; -- control output
		MemWrite	:	out std_logic; -- control output
		RegWrite	:	out std_logic; -- control output
		PC2	:	out std_logic_vector(31 downto 0); -- novo valor para o PC output
		Db	:	out std_logic_vector(31 downto 0); -- registradores output
		RegAddrD	:	out std_logic_vector(4 downto 0); -- ifid input
		zero_flag:	out std_logic; -- Flag da ULA com resultado zero
		ALUres	:	out std_logic_vector(31 downto 0); -- Resultado da ULA
		jar		:	out std_logic -- Entrada q indica a operação JALR ou JAL
	);
end exmem;

architecture machine of exmem is
	signal aux_exmem : std_logic_vector(107 downto 0);
	
	begin
		process(clk)
		begin
			if (rising_edge(clk)) then
				aux_exmem(0) <= Branch_in;
				aux_exmem(1) <= MemWrite_in;
				aux_exmem(2) <= MemRead_in;
				aux_exmem(3) <= RegWrite_in;
				aux_exmem(4) <= MemtoReg_in;
				aux_exmem(36 downto 5) <= PC2_in;
				aux_exmem(37) <= zero_flag_in;
				aux_exmem(69 downto 38) <= ALUres_in;
				aux_exmem(101 downto 70) <= Db_in;
				aux_exmem(106 downto 102) <= RegAddrD_in;
				aux_exmem(107) <= jar_in;
			end if;
			if (falling_edge(clk)) then
				Branch    <= aux_exmem(0);       
				MemWrite  <= aux_exmem(1);     
				MemRead  <= aux_exmem(2);      
				RegWrite <= aux_exmem(3);    
				MemToReg <= aux_exmem(4);
				PC2 <= aux_exmem(36 downto 5);
				zero_flag <= aux_exmem(37);
				ALUres <= aux_exmem(69 downto 38);
				Db <= aux_exmem(101 downto 70);
				RegAddrD <= aux_exmem(106 downto 102);
				jar <= aux_exmem(107);
			end if;
		end process;
end machine;