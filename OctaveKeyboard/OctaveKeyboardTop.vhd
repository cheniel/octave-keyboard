----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:58:26 08/12/2014 
-- Design Name: 
-- Module Name:    OctaveKeyboardTop - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity OctaveKeyboardTop is
    Port ( keys : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           led_disable : in  STD_LOGIC;
			  tone : out STD_LOGIC;
           key_out : out  STD_LOGIC_VECTOR (7 downto 0));
end OctaveKeyboardTop;

architecture Behavioral of OctaveKeyboardTop is


	COMPONENT Controller
		PORT (
				clk : in  STD_LOGIC;
				key_in : in  STD_LOGIC_VECTOR (7 downto 0);
				led_disable : in  STD_LOGIC;
				key_out : out  STD_LOGIC_VECTOR (7 downto 0));
	END COMPONENT;



begin

	controller: Controller
		 Port Map( 
			clk => clk,
         key_in => keys,
			led_disable => led_disable,
			key_out => key_out
		  );

end Behavioral;





