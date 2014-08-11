----------------------------------------------------------------------------------
-- Company: ENGS041 14X
-- Engineer: Vivian Hu and Daniel Chen
-- 
-- Create Date:    14:49:26 08/11/2014 
-- Design Name: Controller FSM
-- Module Name:    Controller - Behavioral 
-- Project Name: Octave Keyboard
-- Target Devices: Spartan 6
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( clk : in  STD_LOGIC;
           key_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  led_disable : in  STD_LOGIC;
           key_out : out  STD_LOGIC_VECTOR (7 downto 0);
           led_out : out  STD_LOGIC_VECTOR (7 downto 0));
end Controller;

architecture Behavioral of Controller is
	type statetype is (idle, low_c, d, e, f, g, a, b, high_c);
	signal curr_state, next_state : statetype := idle;
begin


end Behavioral;

