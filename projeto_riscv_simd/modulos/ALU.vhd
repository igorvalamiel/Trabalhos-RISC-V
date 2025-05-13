
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity ALU is
    port(
    A, B      	: in std_logic_vector(31 downto 0);  -- Operandos A e B de 32 bits da ALU
    controle   : in std_logic_vector(3 downto 0);   -- Entrada responsável por determinar a operação da ALU
    resultado  : out std_logic_vector(31 downto 0); -- Resultado da operação feita pela ALU
    f_zero     : out std_logic);                    -- Flag indicadora de resultado igual a zero na operacão da ALU
end ALU;

architecture TypeArchitecture of ALU is

signal resultado_sig : std_logic_vector(31 downto 0);  -- Vetor auxiliar que armazena o resultado da operação

begin
	
    resultado_sig <= (A + B) when controle = "0010" else                  -- Operação de Soma
    			   	 (A - B) when controle = "0110" else                  -- Operação de Subtração
    			   	 (A XOR B) when controle = "0101" else                -- Operação XOR (Exclusive OR)
    			   	 (A OR B) when controle = "0001" else                 -- Operação OR 
    			   	 (A AND B) when controle = "0000" else                -- Operação AND 
    			   	 (std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))))) when controle = "0011" else   	-- Operação de Shift Left
    			   	 (std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))))) when controle = "0111";    		-- Operação de Shift Right 
        			
    resultado <= resultado_sig;                            			    			-- Atribuição do valor final à saída resultado
    f_zero <= '1' when resultado_sig = "00000000000000000000000000000000" else '0';	-- Sinalização se o resultado é zero 
    														    			-- (Se zero_sig(32) for '0', f_zero é '1', caso contrário, f_zero é '0')
end TypeArchitecture;
