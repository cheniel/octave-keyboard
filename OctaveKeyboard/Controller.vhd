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
				song_enable : in 	STD_LOGIC;
				beat_tick 	: in 	STD_LOGIC;
				count_out	: out STD_LOGIC_VECTOR(3 downto 0);
           	key_out 		: out  STD_LOGIC_VECTOR(7 downto 0);
				led_out		: out STD_LOGIC_VECTOR(7 downto 0));
end Controller;

architecture Behavioral of Controller is
	type statetype is (idle, low_c, d, e, f, g, a, b, high_c,
							intro1c, intro1cr, intro1d, intro1dr, intro1e, intro1er, intro1g, intro1fg,
							enda, endar, endb, enda2, endg, endgr, ende, endd,
							intro2c, intro2a, intro2ar, intro2b, intro2br, intro2f, intro2fr
							);
	signal curr_state, next_state : statetype := idle;
	signal output : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal reps : integer := 0;
begin

	StateUpdate: process(clk)
	begin
		if rising_edge(clk) then
			curr_state <= next_state;
		end if;
	end process StateUpdate;

	CombLogic: process(curr_state, next_state, key_in, led_disable, output, beat_tick)
	begin
		-- defaults
		next_state <= curr_state;
		output <= (others => '0');
		key_out <= output;
		
		if (led_disable = '1') then
			led_out <= (others => '0');
		else
			led_out <= output;
		end if;

		case curr_state is
		
			when idle =>			
				
				if song_enable = '1' then
					-- reps <= 0;
					next_state <= intro1c;
				elsif key_in(7) = '1' then
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
				else
					next_state <= idle;
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
			
			when intro1c =>
				output <= "10000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro1cr;
				end if;


			when intro1cr =>
				output <= "00000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro1d;
				end if;


			when intro1d =>
				output <= "01000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro1dr;
				end if;


			when intro1dr =>
				output <= "00000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro1e;
				end if;


			when intro1e =>
				output <= "00100000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro1er;
				end if;


			when intro1er =>
				output <= "00000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro1f;
				end if;


			when intro1g =>
				output <= "00001000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro1fr;
				end if;


			when intro1gr =>
				output <= "00000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= enda;
				end if;


			when enda =>
				output <= "00000100";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= endar;
				end if;


			when endar =>
				output <= "00000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= endb;
				end if;


			when endb =>
				output <= "00000010";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= enda2;
				end if;


			when enda2 =>
				output <= "00000100";
				count_out <= "0010";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= endg;
				end if;


			when endg =>
				output <= "00001000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= endgr;
				end if;


			when endgr =>
				output <= "00000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= ende;
				end if;


			when ende =>
				output <= "00100000";
				count_out <= "1001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= endd;
				end if;


			when endd =>
				output <= "01000000";
				count_out <= "1000";
				if (song_enable = '0') then
					next_state <= idle;
					reps <= 0;

				elsif(beat_tick = '1') then
					
					if (reps > 3) then
						next_state <= intro1c;
						reps <= 1;

					elsif (reps = 0 or reps = 1) then
						next_state <= intro1c;
						reps <= reps + 1;

					elsif (reps = 2) then
						next_state <= intro2c;
						reps <= reps + 1;

					elsif (reps = 3) then
						next_state <= intro2c;
						reps <= reps + 1;

					end if; 

				end if;

			when intro2c =>
				output <= "00000001";
				count_out <= "0010";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro2a;
				end if;


			when intro2a =>
				output <= "00000100";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro2ar;
				end if;


			when intro2ar =>
				output <= "00000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro2b;
				end if;


			when intro2b =>
				output <= "00000010";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro2br;
				end if;


			when intro2br => 
				output <= "00000000"; 
				count_out <= "0001"; 
				if (song_enable = '0') then 
					next_state <= idle; 
				elsif(beat_tick = '1') then 
					next_state <= intro2f; 
				end if; 


			when intro2f =>
				output <= "00010000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= intro2fr;
				end if;


			when intro2fr =>
				output <= "00000000";
				count_out <= "0001";
				if (song_enable = '0') then
					next_state <= idle;
				elsif(beat_tick = '1') then
					next_state <= endg;
				end if;			
			
			
			when others =>
				next_state <= idle;
			
		end case;

	end process CombLogic;

end Behavioral;

