----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:13:11 08/13/2014 
-- Design Name: 
-- Module Name:    PWM - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM is
	 Generic (	LUTOUT	: integer := 12;
					CLKFREQ 	: integer := 100000000);

    Port ( clk : in  STD_LOGIC;
           sample : in  STD_LOGIC_VECTOR(LUTOUT-1 downto 0);
           pulse : out  STD_LOGIC);
end PWM;

architecture Behavioral of PWM is
	signal count : unsigned(LUTOUT-1 downto 0) := (others => '0');
begin

	PWM: process(clk)
	begin
		if (rising_edge(clk)) then
			count <= count + 1;
			if (count < sample) then	
				pulse <= '1';
			else
				pulse <= '0';
			end if;
		end if;
	end process PWM;
	
end Behavioral;

