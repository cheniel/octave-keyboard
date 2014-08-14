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
-- Description: Basic controller which converts to monotone.
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
    Port ( 	clk 			: in  STD_LOGIC;
           	key_in 		: in  STD_LOGIC_VECTOR(7 downto 0);
				led_disable : in  STD_LOGIC;
           	key_out 		: out  STD_LOGIC_VECTOR(7 downto 0));
end Controller;

architecture Behavioral of Controller is
	type statetype is (idle, low_c, d, e, f, g, a, b, high_c);
	signal curr_state, next_state : statetype := idle;
	signal output : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin

	StateUpdate: process(clk)
	begin
		if rising_edge(clk) then
			curr_state <= next_state;
		end if;
	end process StateUpdate;

	CombLogic: process(curr_state, next_state, key_in, led_disable, output)
	begin
		-- defaults
		next_state <= curr_state;
		output <= (others => '0');
		
		if (led_disable = '1') then
			key_out <= (others => '0');
		else
			key_out <= output;
		end if;

		case curr_state is
		
			when idle =>			
				if key_in(7) = '1' then
					next_state <= low_c;
				elsif key_in(6) = '1' then
					next_state <= d;
				elsif key_in(5) = '1' then
					next_state <= e;
				elsif key_in(4) = '1' then
					next_state <= f;
				elsif key_in(3) = '1' then
					next_state <= g;
				elsif key_in(2) = '1' then
					next_state <= a;
				elsif key_in(1) = '1' then
					next_state <= b;
				elsif key_in(0) = '1' then
					next_state <= high_c;
				end if;

			when low_c =>
				output <= "10000000";
				if key_in(7) = '0' then
					next_state <= idle;
				end if;	
		
			when d =>
				output <= "01000000";
				if key_in(6) = '0' then
					next_state <= idle;
				end if;	
			
			when e =>
				output <= "00100000";
				if key_in(5) = '0' then
					next_state <= idle;
				end if;	
			
			when f =>
				output <= "00010000";
				if key_in(4) = '0' then
					next_state <= idle;
				end if;	
			
			when g =>
				output <= "00001000";
				if key_in(3) = '0' then
					next_state <= idle;
				end if;	
			
			when a =>
				output <= "00000100";
				if key_in(2) = '0' then
					next_state <= idle;
				end if;	
			
			when b =>
				output <= "00000010";
				if key_in(1) = '0' then
					next_state <= idle;
				end if;	
			
			when high_c =>
				output <= "00000001";
				if key_in(0) = '0' then
					next_state <= idle;
				end if;	
			
		end case;

	end process CombLogic;

end Behavioral;

