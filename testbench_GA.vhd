--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:29:46 04/27/2019
-- Design Name:   
-- Module Name:   C:/Users/Prestes/Documents/.Projetos VHDL/testbench_GA.vhd
-- Project Name:  Gerador_funcGerador_func.
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: trabalhoGA
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY testbench_GA IS
END testbench_GA;
 
ARCHITECTURE behavior OF testbench_GA IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT trabalhoGA
    PORT(
         S : INOUT  std_logic_vector(3 downto 0);
         LED : OUT  std_logic_vector(7 downto 0);
         clk : IN  std_logic;
         SW : IN  std_logic_vector(1 downto 0);
         rst : IN  std_logic;
         bt0 : IN  std_logic;
         bt1 : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal SW : std_logic_vector(1 downto 0) := (others => '0');
   signal rst : std_logic := '0';
   signal bt0 : std_logic := '0';
   signal bt1 : std_logic := '0';

	--BiDirs
   signal S : std_logic_vector(3 downto 0);

 	--Outputs
   signal LED : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: trabalhoGA PORT MAP (
          S => S,
          LED => LED,
          clk => clk,
          SW => SW,
          rst => rst,
          bt0 => bt0,
          bt1 => bt1
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '0'; 	
----------MODIFICA AMOSTRAS---------
wait for 100 ms;

---Diminuis taxa amostras
bt0 <= '1';
wait for 20ms;
bt0 <= '0';
wait for 100ms;
wait for 100ms;

--Aumenta taxa amostras
bt1 <= '1';
wait for 20 ms;
bt1 <= '0';
wait for 20 ms;
bt1 <= '1';
wait for 20 ms;
bt1 <= '0';
wait for 20 ms;

----------TESTE SELEÇAO DAS SAÍDAS----------
wait for 20 ms;
sw <= "00";
--Onda senoide
wait for 200 ms;
sw <= "01";
--Onda quadrada
wait for 200 ms;
sw <= "10";
--Onda serra
wait for 200 ms;
sw <= "11";

		-- wait for clk_period*10;

wait;
end process;
END;
