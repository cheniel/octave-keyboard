----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:30:42 08/11/2014 
-- Design Name: 
-- Module Name:    FreqLUT - Behavioral 
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

entity FreqLUT is
	 Generic (	ACCUMSIZE	: integer := 7;
					CLKFREQ 		: integer := 100000000);
					
    Port ( clk : in  STD_LOGIC;
           key_in : in  STD_LOGIC_VECTOR (7 downto 0);
           increment : out  STD_LOGIC_VECTOR (15 downto 0));
end FreqLUT;

architecture Behavioral of FreqLUT is
	constant PHASECONSTANT : integer := 2**ACCUMSIZE / CLKFREQ;
	constant LOWC : integer := 262;
	constant D : integer := 294;
	constant E : integer := 330;
	constant F : integer := 349;
	constant G : integer := 392;
	constant A : integer := 440;
	constant B : integer := 494;
	constant HIGHC : integer := 523;
begin
	getIncrement: process(key_in)
	begin
	end process getIncrement;



end Behavioral;

