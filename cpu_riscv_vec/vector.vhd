library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity vector is
	port(
		-- entradas
		Entry1	:	in std_logic_vector(31 downto 0); -- entrada 1 do vector
		Entry2	:	in std_logic_vector(31 downto 0); -- entrada 2 do vector
		control	:	in std_logic_vector(3 downto 0); -- controle do vector
		VecSize	:	in std_logic_vector(1 downto 0); -- em quantas partes serão repartidos os controlerandos
		-- saídas
		Entry1_out	:	out std_logic_vector(31 downto 0); -- entrada 1 da ULA
		Entry2_out	:	out std_logic_vector(31 downto 0); -- entrada 2 da ULA
		control_out	:	out std_logic_vector(3 downto 0); -- controle da ULA
		result	:	out std_logic_vector(31 downto 0); -- saída da ULA
		zero_flag:	out std_logic; -- flag se o resultado for zero
		is32	:	out std_logic -- flag que indica se a partição é de 32 bits
	);
end vector;

architecture calculator of vector is
	signal criate  : std_logic_vector(31 downto 0); -- 1+1 (cria carry)
	signal passing : std_logic_vector(31 downto 0); -- carry + 1 + 0 (passa carry pra frente)
	signal carry   : std_logic_vector(31 downto 0); -- carry
	signal B_adj   : std_logic_vector(31 downto 0); -- entrada Entry2 ajustada
	signal res_ret : std_logic_vector(31 downto 0); -- resultado de retorno

	begin
		process(all)
			variable x : std_logic;
			variable piece : integer; -- variável para guardar pedaço do operando
			variable shifting : integer; -- variável auxiliar para o shift
			variable res  : std_logic_vector(31 downto 0); -- resultado

		begin
			if (control="0010" or control="0110") then
				-- se for subtracao faz complemento de dois
				if control = "0110" then
					B_adj <= not Entry2; -- inverte
					carry(0) <= '1'; -- soma 1
					x := '1';
				else
					B_adj <= Entry2;
					carry(0) <= '0';
					x := '0';
				end if;

				---------------------------------------------------------------
				-- ajustando o carry e os auxiliares
				for item in 0 to 31 loop
					criate(item)  <= (Entry1(item) and B_adj(item));
					passing(item) <= (Entry1(item) or B_adj(item));
				end loop;
				---------------------------------------------------------------
				-- mudando bits de 1 a 3
				for i in 1 to 3 loop
					carry(i) <= (criate(i-1) or (passing(i-1) and carry(i-1))); 
				end loop;
				---------------------------------------------------------------
				-- mudando bit 4
				if VecSize = "00" then
					carry(4) <= x;
				else
					carry(4) <= (criate(3) or (passing(3) and carry(3)));
				end if;
				---------------------------------------------------------------
				-- mudando bits de 5 a 7
				for i in 5 to 7 loop
					carry(i) <= (criate(i-1) or (passing(i-1) and carry(i-1))); 
				end loop;
				---------------------------------------------------------------
				-- mudando bit 8
				if VecSize = "00" or VecSize = "01" then
					carry(8) <= x;
				else
					carry(8) <= (criate(7) or (passing(7) and carry(7)));
				end if;
				---------------------------------------------------------------
				-- mudando bits de 9 a 11
				for i in 9 to 11 loop
					carry(i) <= (criate(i-1) or (passing(i-1) and carry(i-1))); 
				end loop;
				---------------------------------------------------------------
				-- mudando bit 12
				if VecSize = "00" then
					carry(12) <= x;
				else
					carry(12) <= (criate(11) or (passing(11) and carry(11)));
				end if;
				---------------------------------------------------------------7
				-- mudando bits de 13 a 15
				for i in 13 to 15 loop
					carry(i) <= (criate(i-1) or (passing(i-1) and carry(i-1))); 
				end loop;
				---------------------------------------------------------------
				-- mudando bit 16
				if VecSize = "00" or VecSize = "01" or VecSize = "10" then
					carry(16) <= x;
				else
					carry(16) <= (criate(15) or (passing(15) and carry(15)));
				end if;
				---------------------------------------------------------------
				-- mudando bits de 17 a 19
				for i in 17 to 19 loop
					carry(i) <= (criate(i-1) or (passing(i-1) and carry(i-1))); 
				end loop;
				---------------------------------------------------------------
				-- mudando bit 20
				if VecSize = "00" then
					carry(20) <= x;
				else
					carry(20) <= (criate(19) or (passing(19) and carry(19)));
				end if;
				---------------------------------------------------------------
				-- mudando bits de 21 a 23
				for i in 21 to 23 loop
					carry(i) <= (criate(i-1) or (passing(i-1) and carry(i-1))); 
				end loop;
				---------------------------------------------------------------
				-- mudando bit 24
				if VecSize = "00" or VecSize = "01" then
					carry(24) <= x;
				else
					carry(24) <= (criate(23) or (passing(23) and carry(23)));
				end if;
				---------------------------------------------------------------
				-- mudando bits de 25 a 27
				for i in 25 to 27 loop
					carry(i) <= (criate(i-1) or (passing(i-1) and carry(i-1))); 
				end loop;
				---------------------------------------------------------------
				-- mudando bit 28
				if VecSize = "00" then
					carry(28) <= x;
				else
					carry(28) <= (criate(27) or (passing(27) and carry(27)));
				end if;
				---------------------------------------------------------------
				-- mudando bits de 29 a 31
				for i in 29 to 31 loop
					carry(i) <= (criate(i-1) or (passing(i-1) and carry(i-1)));
				end loop;
				---------------------------------------------------------------
			else
				if (control = "0011") then
					if (VecSize = "11") then -- 8 somas de 4 bits
						for i in 0 to 7 loop
							piece := to_integer(unsigned(Entry2(i*4+3 downto i*4)));
							res(i*4+3 downto i*4) := std_logic_vector(shift_left(unsigned(Entry1(i*4+3 downto i*4)), piece));
						end loop;
					elsif (VecSize = "10") then -- 4 somas de 8 bits
						for i in 0 to 3 loop
							piece := to_integer(unsigned(Entry2(i*8+7 downto i*8)));
							res(i*8+7 downto i*8) := std_logic_vector(shift_left(unsigned(Entry1(i*8+7 downto i*8)), piece));
						end loop;
					elsif (VecSize = "01") then -- 2 somas de 16 bits
						for i in 0 to 1 loop
							piece := to_integer(unsigned(Entry2(i*16+15 downto i*16)));
							res(i*16+15 downto i*16) := std_logic_vector(shift_left(unsigned(Entry1(i*16+15 downto i*16)), piece));
						end loop;
					end if;
				elsif (control = "0111") then
					if (VecSize = "11") then -- 8 somas de 4 bits
						for i in 0 to 7 loop
							piece := to_integer(unsigned(Entry2(i*4+3 downto i*4)));
							res(i*4+3 downto i*4) := std_logic_vector(shift_right(unsigned(Entry1(i*4+3 downto i*4)), piece));
						end loop;
					elsif (VecSize = "10") then -- 4 somas de 8 bits
						for i in 0 to 3 loop
							piece := to_integer(unsigned(Entry2(i*8+7 downto i*8)));
							res(i*8+7 downto i*8) := std_logic_vector(shift_right(unsigned(Entry1(i*8+7 downto i*8)), piece));
						end loop;
					elsif (VecSize = "01") then -- 2 somas de 16 bits
						for i in 0 to 1 loop
							piece := to_integer(unsigned(Entry2(i*16+15 downto i*16)));
							res(i*16+15 downto i*16) := std_logic_vector(shift_right(unsigned(Entry1(i*16+15 downto i*16)), piece));
						end loop;
					end if;
				end if;
			end if;
			res_ret <= res;
		end process;
		
		process(all)
		begin
			if (control="0010" or control="0110") then
				-- soma final
				soma: for j in 0 to 31 loop
					result(j) <= (Entry1(j) xor B_adj(j) xor carry(j));
				end loop soma;
			else
				result <= res_ret;
			end if;
			
			if (res_ret = "00000000000000000000000000000000") then
				zero_flag <= '1';
			else zero_flag <= '0'; end if; -- ativando flag zero
			if (VecSize = "00") then
				is32 <= '1'; 
			else is32 <= '0';
			end if; -- ativando is32 pois não existe partição
			
			-- repassando valores para a ULA
			Entry1_out <= Entry1;
			Entry2_out <= Entry2;
			control_out <= control;
		end process;

end calculator;