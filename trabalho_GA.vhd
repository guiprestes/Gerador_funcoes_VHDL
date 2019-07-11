----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Guilherme Prestes
-- 
-- Create Date:    21:35:24 04/25/2019 
-- Design Name: 
-- Module Name:    trabalhoGA - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trabalhoGA is
	Port ( S: inout STD_LOGIC_VECTOR (3 downto 0);
			LED: out STD_LOGIC_VECTOR (7 downto 0);
			clk: in STD_LOGIC;
			SW: in STD_LOGIC_VECTOR (1 downto 0);
			rst: in STD_LOGIC;
			bt0: in STD_LOGIC;
			bt1: in STD_LOGIC);
end trabalhoGA;

architecture Behavioral of trabalhoGA is
	signal div_clk: STD_LOGIC;
	signal cont_divisor : INTEGER :=0;
	signal periodo : INTEGER := 1562500;
	signal b0 : STD_LOGIC := '0';
	signal b1 : STD_LOGIC := '0';
	signal conta_periodo: INTEGER := 5;
	signal fase_sen: INTEGER RANGE 0 TO 16 :=0;
	signal senoide: STD_LOGIC_VECTOR (3 downto 0) := "0000"; 
	signal fase_sqr: INTEGER RANGE 0 TO 16 :=0;
	signal square: STD_LOGIC_VECTOR (3 downto 0) := "0000";
	signal fase_ser: INTEGER RANGE 0 TO 16 :=0;
	signal serra: STD_LOGIC_VECTOR (3 downto 0) := "0000";
	signal led_out: STD_LOGIC_VECTOR (3 downto 0) := "0000";
	
begin
---DIVISOR DE CLOCK---
divisor_clk: process (clk,rst) 
begin
if (rst = '1') then
	cont_divisor <= 0;
	div_clk <= '0';

elsif (rising_edge(clk)) then
	cont_divisor <= cont_divisor +1;
	if (cont_divisor = periodo) then
		cont_divisor <= 0;
		div_clk <= not div_clk;
	end if;
end if;
end process divisor_clk;

---ALTERAR AMOSTRAS---
AMOSTRA: process (bt0,bt1,clk)begin
if rst = '1' then
	b0 <= '0';
	b1 <= '0';
	conta_periodo <= 5; --1s de periodo
	
elsif (rising_edge(clk)) then
	if bt0 = '1' and b0 = '0' then
	b0 <= '1';
	conta_periodo <= conta_periodo + 1;
	
if (conta_periodo <= 10) then
	conta_periodo <= 10;
end if;
	
elsif bt0 = '0' then
	b0 <= '0';
end if;

if bt1 = '1' and b1 = '0' then
	b1 <=  '1';
	conta_periodo <= conta_periodo +1;
	if (conta_periodo < 0) then
		conta_periodo <= 0;
	end if;
	
elsif bt1 = '0' then
b1 <= '0';
end if;
end if;

case conta_periodo is
	when 0  => periodo <= 48828;
	when 1  => periodo <= 97656;
	when 2  => periodo <= 195312;
	when 3  => periodo <= 390625;
	when 4  => periodo <= 781250;
	when 5  => periodo <= 1562500;
	when 6  => periodo <= 3125000;
	when 7  => periodo <= 6250000;
	when 8  => periodo <= 12500000;
	when 9  => periodo <= 25000000;
	when 10 => periodo <= 50000000;
	when others => end case;
end process AMOSTRA;

---Selecionar Saída---
process (sw,senoide,square,serra)begin	
	case sw is
	when "00" => S <= senoide;
	when "01" => S <= square;
	when "10" => S <= serra;
	when "11" => S <= "0111";
	when others => S <= "0000";
	end case;
end process;

---ONDA SENOIDE---
SENOIDAL: process (div_clk,rst)begin
if (rst ='1') then
	senoide <= "0000";

elsif (rising_edge(div_clk)) then
	fase_sen <= fase_sen +1;
	if (fase_sen = 15) then
		fase_sen <= 0;
	end if;
end if;

case fase_sen is
when 0  => senoide <= "1000";
when 1  => senoide <= "1010";
when 2  => senoide <= "1101";
when 3  => senoide <= "1110";
when 4  => senoide <= "1111";
when 5  => senoide <= "1110";
when 6  => senoide <= "1101";
when 7  => senoide <= "1010";
when 8  => senoide <= "1000";
when 9  => senoide <= "1001";
when 10 => senoide <= "0010";
when 11 => senoide <= "0001";
when 12 => senoide <= "0000";
when 13 => senoide <= "0001";
when 14 => senoide <= "0010";
when 15 => senoide <= "0101";
when others => end case;

end process SENOIDAL;

---ONDA QUADRADA---
QUADRADA: process (div_clk,rst)begin
if (rst = '1') then
	square <= "0000";
	elsif (rising_edge(div_clk)) then
		fase_sqr <= fase_sqr +1;
		if (fase_sqr = 8) then
			fase_sqr <= 1;
			square <= not square;
			end if;
		end if;
end process QUADRADA;

---ONDA SERRA---
DENTESERRA:  process (div_clk,rst)
begin
if (rst = '1') then
	serra <= "0000";
	elsif (rising_edge(div_clk)) then
		fase_ser <= fase_ser +1;
		if (fase_ser = 15) then
			fase_ser <= 0;
		end if;
end if;

case fase_ser is
when 0  => serra <= "0111";
when 1  => serra <= "1001"; 
when 2  => serra <= "1011"; 
when 3  => serra <= "1101"; 
when 4  => serra <= "1111"; 
when 5  => serra <= "1101"; 
when 6  => serra <= "1011"; 
when 7  => serra <= "1001"; 
when 8  => serra <= "0111"; 
when 9  => serra <= "0101"; 
when 10 => serra <= "0011"; 
when 11 => serra <= "0001"; 
when 12 => serra <= "0000"; 
when 13 => serra <= "0001"; 
when 14 => serra <= "0011"; 
when 15 => serra <= "0101"; 
when others => end case;

end process DENTESERRA;

---LED---
process (S) begin
case S (3 downto 1) is
when "000"  => LED <= "00000000";
when "001"  => LED <= "00000011";
when "010"  => LED <= "00000111";
when "011"  => LED <= "00001111";
when "100"  => LED <= "00011111";
when "101"  => LED <= "00111111";
when "110"  => LED <= "01111111";
when "111"  => LED <= "11111111";
when others => LED <= "00000000";
end case;
end process;
end Behavioral;

