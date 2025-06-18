library ieee;
use ieee.std_logic_1164.all;

entity somador_avx is
	port (
		A_i	: IN std_logic_vector(31 downto 0); -- Entrada 1
		B_i	: IN  std_logic_vector(31 downto 0); -- Entrada 2
		mode_i	: IN std_logic; -- Operacao
		vecSize_i : IN std_logic_vector(1 downto 0); -- Particao do vetor

		S_o : OUT std_logic_vector(31 downto 0) -- Saida
	);
end somador_avx;

architecture calculator of somador_avx is
	signal criate  : std_logic_vector(31 downto 0); -- 1+1 (cria carry)
	signal passing : std_logic_vector(31 downto 0); -- carry + 1 + 0 (passa carry pra frente)
	signal carry   : std_logic_vector(31 downto 0); -- carry
	signal B_adj   : std_logic_vector(31 downto 0); -- entrada B ajustada
begin

	process(all)
		variable x : std_logic;
	begin
		-- se for subtracao faz complemento de dois
		if mode_i = '1' then
			B_adj <= not B_i; -- inverte
			carry(0) <= '1'; -- soma 1
			x := '1';
		else
			B_adj <= B_i;
			carry(0) <= '0';
			x := '0';
		end if;

		---------------------------------------------------------------
		-- ajustando o carry e os auxiliares
		for item in 0 to 31 loop
			criate(item)  <= (A_i(item) and B_adj(item));
			passing(item) <= (A_i(item) or B_adj(item));
		end loop;
		---------------------------------------------------------------
		-- mudando bits de 1 a 3
		for i in 1 to 3 loop
			carry(i) <= (criate(i-1) or (passing(i-1) and carry(i-1))); 
		end loop;
		---------------------------------------------------------------
		-- mudando bit 4
		if vecSize_i = "00" then
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
		if vecSize_i = "00" or vecSize_i = "01" then
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
		if vecSize_i = "00" then
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
		if vecSize_i = "00" or vecSize_i = "01" or vecSize_i = "10" then
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
		if vecSize_i = "00" then
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
		if vecSize_i = "00" or vecSize_i = "01" then
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
		if vecSize_i = "00" then
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
	end process;

	-- soma final
	soma: for j in 0 to 31 generate
		S_o(j) <= (A_i(j) xor B_adj(j) xor carry(j));
	end generate soma;

end calculator;
