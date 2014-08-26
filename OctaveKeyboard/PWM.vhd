----------------------------------------------------------------------------------
-- Company: ENGS031 14X
-- Engineer: Vivian Hu and Daniel Chen
-- 
-- Create Date: 10:13:11 08/13/2014 
-- Design Name: Pulse Width Modulator
-- Module Name: PWM - Behavioral 
-- Project Name: Octave Keyboard
-- Target Devices: Nexys3
-- Tool versions: 
-- Description: Pulse width modulator (counter and comparator)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM is
    Generic (  LUTOUT  : integer := 10);    -- SineLUT output bitsize

    Port (  clk     : in  STD_LOGIC;
            sample  : in  STD_LOGIC_VECTOR(LUTOUT-1 downto 0);
            slowclk : out STD_LOGIC;
            pulse   : out  STD_LOGIC);
end PWM;

architecture Behavioral of PWM is
    signal count    : unsigned(13 downto 0) := (others => '0');
    signal offset   : unsigned(LUTOUT-1 downto 0) := (others => '0');
    constant max    : unsigned(13 downto 0) := "01001110001000";   -- max count value
begin

    PWM: process(clk, sample)
    begin
        -- convert SinLUT output from two's complement to unsigned offset binary
        offset <= unsigned(not sample(LUTOUT-1) & sample(LUTOUT-2 downto 0)); 
        
        if (rising_edge(clk)) then
            
            -- increment counter
            count <= count + 1;        
            
            -- compare first 10 bits to SinLUT output
            if (count(9 downto 0) < offset) then    
                pulse <= '1';
            else
                pulse <= '0';
            end if;
            
            -- if max count hit
            if (count = max) then
                -- send 10kHz enable pulse to phase accumulator
                slowclk <= '1';
                count <= (others => '0');   -- restart count
            else
                slowclk <= '0';
            end if;
        end if;
    end process PWM;

end Behavioral;

