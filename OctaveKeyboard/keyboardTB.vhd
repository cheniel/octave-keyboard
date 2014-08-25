--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:17:41 08/25/2014
-- Design Name:   
-- Module Name:   C:/Users/F000JW7/Desktop/octave-keyboard/OctaveKeyboard/keyboardTB.vhd
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
 
ENTITY keyboardTB IS
END keyboardTB;
 
ARCHITECTURE behavior OF keyboardTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT OctaveKeyboardTop
    PORT(
         clk : IN  std_logic;
         keys : IN  std_logic_vector(7 downto 0);
         led_disable : IN  std_logic;
         song_enable : IN  std_logic;
         tone : OUT  std_logic;
         shutdown : OUT  std_logic;
         led_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal keys : std_logic_vector(7 downto 0) := (others => '0');
   signal led_disable : std_logic := '0';
   signal song_enable : std_logic := '0';

     --Outputs
   signal tone : std_logic;
   signal shutdown : std_logic;
   signal led_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: OctaveKeyboardTop PORT MAP (
          clk => clk,
          keys => keys,
          led_disable => led_disable,
          song_enable => song_enable,
          tone => tone,
          shutdown => shutdown,
          led_out => led_out
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

      wait for clk_period*5;
        
        led_disable <= '0';
        song_enable <= '0';

      keys <= "10000000";
      wait for 250us;
      keys <= "10001000";
      wait for 50us;
      keys <= "00010000";
      wait for 200us;
      keys <= "00100010";
      wait for 300us;
      led_disable <= '1';
      wait for 200us;
      keys <= "00000010";
      wait for 200us;
      keys <= "00000100";
      wait for 200us;
      keys <= "00001000";
      wait for 200us;
      keys <= "00011111";
      led_disable <= '0';
      wait for 50us;
      keys <= "00000000";
      wait for 200us;
      keys <= "10111000";
      song_enable <= '1';
      wait;
   end process;

END;
