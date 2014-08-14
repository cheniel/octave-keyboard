--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:40:46 08/13/2014
-- Design Name:   
-- Module Name:   C:/Users/F000JW7/Desktop/octave-keyboard/OctaveKeyboard/KeyBoardTB.vhd
-- Project Name:  OctaveKeyboard
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: OctaveKeyboardTop
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
--USE ieee.numeric_std.ALL;
 
ENTITY KeyBoardTB IS
END KeyBoardTB;
 
ARCHITECTURE behavior OF KeyBoardTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT OctaveKeyboardTop
    PORT(
         keys : IN  std_logic_vector(7 downto 0);
         clk : IN  std_logic;
         led_disable : IN  std_logic;
         tone : OUT  std_logic;
         key_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal keys : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal led_disable : std_logic := '0';

 	--Outputs
   signal tone : std_logic;
   signal key_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: OctaveKeyboardTop PORT MAP (
          keys => keys,
          clk => clk,
          led_disable => led_disable,
          tone => tone,
          key_out => key_out
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		keys <= "10000000";
		
		wait for clk_period*10;
		keys <= "00001000";

      wait;
   end process;

END;
