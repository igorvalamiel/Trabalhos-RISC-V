LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity idex is
	port (
	-- entradas
		clk	:	in std_logic; -- clock
		Branch_in	:	in std_logic; -- control input
		MemRead_in	:	in std_logic; -- control input
		MemtoReg_in	:	in std_logic; -- control input
		ALUop_in	:	in std_logic_vector(1 downto 0); -- control input
		MemWrite_in	:	in std_logic; -- control input
		ALUscr_in	:	in std_logic; -- control input
		RegWrite_in	:	in std_logic; -- control input
		funct7_in	:	in std_logic_vector(6 downto 0); -- control input
		funct3_in	:	in std_logic_vector(2 downto 0); -- control input
		opcode_in	:	in std_logic_vector(6 downto 0); -- control input
		PC_shift_ctrl_in	:	in std_logic; -- control input
		JumpReg_in	:	in  std_logic; -- control input
		PC_in	:	in std_logic_vector(31 downto 0); -- ifid input
		Da_in	:	in std_logic_vector(31 downto 0); -- registradores input
		Db_in	:	in std_logic_vector(31 downto 0); -- registradores input
		imm_in	:	in std_logic_vector(31 downto 0); -- immaginate input
		RegAddr1_in	:	in std_logic_vector(4 downto 0); -- ifid input
		RegAddr2_in	:	in std_logic_vector(4 downto 0); -- ifid input
		RegAddrD_in	:	in std_logic_vector(4 downto 0); -- ifid input
		
	--saídas
		Branch	:	out std_logic; -- control input
		MemRead	:	out std_logic; -- control input
		MemtoReg	:	out std_logic; -- control input
		ALUop	:	out std_logic_vector(1 downto 0); -- control input
		MemWrite	:	out std_logic; -- control input
		ALUscr	:	out std_logic; -- control input
		RegWrite	:	out std_logic; -- control input
		funct7	:	out std_logic_vector(6 downto 0); -- control input
		funct3	:	out std_logic_vector(2 downto 0); -- control input
		opcode	:	out std_logic_vector(6 downto 0); -- control input
		PC_shift_ctrl	:	out std_logic; -- control input
		JumpReg	:	out std_logic; -- control input
		PC	:	out std_logic_vector(31 downto 0); -- ifid input
		Da	:	out std_logic_vector(31 downto 0); -- registradores input
		Db	:	out std_logic_vector(31 downto 0); -- registradores input
		imm	:	out std_logic_vector(31 downto 0); -- immaginate input
		RegAddr1	:	out std_logic_vector(4 downto 0); -- ifid input
		RegAddr2	:	out std_logic_vector(4 downto 0); -- ifid input
		RegAddrD	:	out std_logic_vector(4 downto 0) -- ifid input
	);
end idex;

architecture machine of idex is
	signal aux_idex : std_logic_vector(170 downto 0); -- sinal auxiliar para idex
	begin
		process(clk)
		begin
			if (rising_edge(clk)) then -- verificando subida de clock
				aux_idex(0) <= ALUscr_in;
				aux_idex(2 downto 1) <= ALUOp_in;
				aux_idex(5 DOWNTO 3) <= funct3_in;
				aux_idex(12 DOWNTO 6) <= funct7_in;
				aux_idex(44 DOWNTO 13) <= PC_in ;
				aux_idex(45) <= PC_shift_ctrl_in;
				aux_idex(46) <= Branch_in;
				aux_idex(47) <= MemWrite_in;
				aux_idex(48) <= MemRead_in;
				aux_idex(49) <= RegWrite_in;
				aux_idex(50) <= MemToReg_in;
				aux_idex(82 DOWNTO 51) <= Da_in;
				aux_idex(114 DOWNTO 83) <= Db_in;
				aux_idex(146 DOWNTO 115) <= imm_in;
				aux_idex(151 DOWNTO 147) <= RegAddrD_in;
				aux_idex(159 downto 153) <= opcode_in;
				aux_idex(160) <= JumpReg_in;
				aux_idex(165 downto 161) <= RegAddr1_in;
				aux_idex(170 downto 166) <= RegAddr2_in;
			end if;
			if (falling_edge(clk)) then -- verificando descida de clock
				ALUscr <= aux_idex(0);       
				ALUOp  <= aux_idex(2 downto 1);     
				funct3 <= aux_idex(5 DOWNTO 3);      
				funct7 <= aux_idex(12 DOWNTO 6);    
				PC <= aux_idex(44 DOWNTO 13);
				PC_shift_ctrl <= aux_idex(45);
				Branch <= aux_idex(46);
				MemWrite <= aux_idex(47);
				MemRead <= aux_idex(48);
				RegWrite <= aux_idex(49);
				MemToReg <= aux_idex(50);
				Da <= aux_idex(82 DOWNTO 51);
				Db <= aux_idex(114 DOWNTO 83);
				imm <= aux_idex(146 DOWNTO 115);
				RegAddrD <= aux_idex(151 DOWNTO 147);
				opcode <= aux_idex(159 downto 153);
				JumpReg <= aux_idex(160);
				RegAddr1 <= aux_idex(165 downto 161);
				RegAddr2 <= aux_idex(170 downto 166);
			end if;
		end process;
end machine;
