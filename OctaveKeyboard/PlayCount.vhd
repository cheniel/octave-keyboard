----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:40:24 08/16/2014 
-- Design Name: 
-- Module Name:    PlayCount - Behavioral 
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

entity PlayCount is
    Port ( clk : in  STD_LOGIC;
           count_to : in  STD_LOGIC_VECTOR (3 downto 0);
           tc_tick : out  STD_LOGIC);
end PlayCount;

architecture Behavioral of PlayCount is
	constant QRTR_CLK_DIV	: integer := 12500000;
	signal 	clkcount	: integer := 0;
	signal	count		: unsigned(3 downto 0) := "000";
begin
	
	Qrtr_Sec_Count: process(clk)
	begin

		if (rising_edge(clk)) then
		
			tc_tick <= '0';
			
			if (clkcount = QRTR_CLK_DIV - 1) then
				if (count = unsigned(count_to)) then
					tc_tick <= '1';
					count <= "000";
				else
					count <= count + 1;
				end if;
				
				clkcount <= 0;
			else
				clkcount <= clkcount + 1;
			end if;
		end if;
	end process Qrtr_Sec_Count;			
	
end Behavioral;

