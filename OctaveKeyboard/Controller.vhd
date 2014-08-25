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
use IEEE.NUMERIC_STD.ALL;

entity Controller is --yea
    Port (     clk         : in  STD_LOGIC;
               key_in      : in  STD_LOGIC_VECTOR(7 downto 0);
               led_disable : in  STD_LOGIC;
               song_enable : in  STD_LOGIC;
               beat_tick   : in  STD_LOGIC;
               beat_en     : out STD_LOGIC;
               count_out   : out STD_LOGIC_VECTOR(3 downto 0);
               key_out     : out STD_LOGIC_VECTOR(7 downto 0);
               led_out     : out STD_LOGIC_VECTOR(7 downto 0));
end Controller;

architecture Behavioral of Controller is
    type statetype is (idle, low_c, d, e, f, g, a, b, high_c, autoidle,
        intro1c, intro1cr, intro1d, intro1dr, intro1e, intro1er, intro1g, intro1gr,
        enda, endar, endb, enda2, endg, endgr, ende, endd,
        intro2c, intro2a, intro2ar, intro2b, intro2br, intro2g, intro2gr
        );
    signal curr_state, next_state : statetype := idle;
    signal output : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal reps : STD_LOGIC := '1';
    signal introSelector : STD_LOGIC := '0';
    signal repeat_tick : STD_LOGIC := '0';
begin

    StateUpdate: process(clk)
    begin
        if rising_edge(clk) then
            curr_state <= next_state;
        end if;
    end process StateUpdate;

    CombLogic: process(curr_state, next_state, key_in, led_disable, output, beat_tick, song_enable, introSelector)
    begin
        -- defaults
        next_state <= curr_state;
        output <= (others => '0');
        key_out <= output;
        count_out <= "0001";
        repeat_tick <= '0';
        beat_en <= '0';
        
        if (led_disable = '1') then
            led_out <= (others => '0');
        else
            led_out <= output;
        end if;

        case curr_state is
        
            when idle =>            
                
                if song_enable = '1' then
                    next_state <= autoidle;
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
                
            when autoidle =>
                beat_en <= '1';
                output <= (others => '0');
                if (beat_tick = '1') then
                    next_state <= intro1c;
                end if;
            
            when intro1c =>
                beat_en <= '1';
                output <= "10000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro1cr;
                end if;


            when intro1cr =>
                beat_en <= '1';
                output <= "00000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro1d;
                end if;


            when intro1d =>
                beat_en <= '1';
                output <= "01000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro1dr;
                end if;


            when intro1dr =>
                beat_en <= '1';
                output <= "00000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro1e;
                end if;


            when intro1e =>
                beat_en <= '1';
                output <= "00100000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro1er;
                end if;


            when intro1er =>
                beat_en <= '1';
                output <= "00000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro1g;
                end if;


            when intro1g =>
                beat_en <= '1';
                output <= "00001000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro1gr;
                end if;


            when intro1gr =>
                beat_en <= '1';
                output <= "00000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= enda;
                end if;


            when enda =>
                beat_en <= '1';
                output <= "00000100";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= endar;
                end if;


            when endar =>
                beat_en <= '1';
                output <= "00000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= endb;
                end if;


            when endb =>
                beat_en <= '1';
                output <= "00000010";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= enda2;
                end if;


            when enda2 =>
                beat_en <= '1';
                output <= "00000100";
                count_out <= "0010";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= endg;
                end if;


            when endg =>
                beat_en <= '1';
                output <= "00001000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= endgr;
                end if;


            when endgr =>
                beat_en <= '1';
                output <= "00000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= ende;
                end if;


            when ende =>
                beat_en <= '1';
                output <= "00100000";
                count_out <= "1001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= endd;
                end if;


            when endd =>
                beat_en <= '1';
                output <= "01000000";
                count_out <= "1000";
                
                if (beat_tick = '1') then
                    repeat_tick <= '1';
                    
                    if (introSelector = '0') then
                        next_state <= intro1c;
                    else 
                        next_state <= intro2c;
                    end if;
                    
                elsif (song_enable = '0') then
                    next_state <= idle;                    

                end if;

            when intro2c =>
                beat_en <= '1';
                output <= "00000001";
                count_out <= "0010";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro2a;
                end if;


            when intro2a =>
                beat_en <= '1';
                output <= "00000100";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro2ar;
                end if;


            when intro2ar =>
                beat_en <= '1';
                output <= "00000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro2b;
                end if;


            when intro2b =>
                beat_en <= '1';
                output <= "00000010";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro2br;
                end if;


            when intro2br => 
                beat_en <= '1';
                output <= "00000000"; 
                count_out <= "0001"; 
                if (song_enable = '0') then 
                    next_state <= idle; 
                elsif(beat_tick = '1') then 
                    next_state <= intro2g; 
                end if; 


            when intro2g =>
                beat_en <= '1';
                output <= "00001000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= intro2gr;
                end if;


            when intro2gr =>
                beat_en <= '1';
                output <= "00000000";
                count_out <= "0001";
                if (song_enable = '0') then
                    next_state <= idle;
                elsif(beat_tick = '1') then
                    next_state <= enda;
                end if;            
            
            when others =>
                next_state <= idle;
            
        end case;

    end process CombLogic;

    RepeatCounter: process(clk, repeat_tick, reps, introselector)
    begin
        if (rising_edge(clk)) then
            if (repeat_tick = '1') then
                if (reps = '1') then
                    introSelector <= not introSelector;
                    reps <= '0';
                else
                    reps <= not reps;
                end if;
            end if;
        end if;
    end process RepeatCounter;

end Behavioral;

