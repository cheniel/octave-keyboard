----------------------------------------------------------------------------------
-- Company: ENGS031 14X
-- Engineer: Daniel Chen and Vivian Hu
-- 
-- Create Date:    15:30:42 08/11/2014 
-- Design Name: Frequency LUT
-- Module Name:    FreqLUT - Behavioral 
-- Project Name: Octave Keyboard
-- Target Devices: Nexys3
-- Tool versions: 
-- Description: Frequency LUT that takes the keys and outputs the increment 
-- corresponding to the notes.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FreqLUT is
     Generic (  ACCUMSIZE : integer := 13;
                CLKFREQ   : integer := 10000);
                    
    Port ( clk : in  STD_LOGIC;
           key_in : in  STD_LOGIC_VECTOR (7 downto 0);
           increment : out  STD_LOGIC_VECTOR (ACCUMSIZE-1 downto 0));
end FreqLUT;

architecture Behavioral of FreqLUT is
    constant PHASECONSTANT : integer := 2**ACCUMSIZE;
    constant LOWC : integer := 262;
    constant D : integer := 294;
    constant E : integer := 330;
    constant F : integer := 349;
    constant G : integer := 392;
    constant A : integer := 440;
    constant B : integer := 494;
    constant HIGHC : integer := 523;
begin
    
getIncrement: process(clk, key_in)
begin
    if rising_edge(clk) then
        if (key_in(7) = '1') then
            increment <=std_logic_vector(to_unsigned(LOWC*PHASECONSTANT/CLKFREQ,ACCUMSIZE));
        elsif (key_in(6) = '1') then
            increment <=std_logic_vector(to_unsigned(D*PHASECONSTANT/CLKFREQ,ACCUMSIZE));
        elsif (key_in(5) = '1') then
            increment <=std_logic_vector(to_unsigned(E*PHASECONSTANT/CLKFREQ,ACCUMSIZE));
        elsif (key_in(4) = '1') then
            increment <=std_logic_vector(to_unsigned(F*PHASECONSTANT/CLKFREQ,ACCUMSIZE));
        elsif (key_in(3) = '1') then
            increment <=std_logic_vector(to_unsigned(G*PHASECONSTANT/CLKFREQ,ACCUMSIZE));
        elsif (key_in(2) = '1') then
            increment <=std_logic_vector(to_unsigned(A*PHASECONSTANT/CLKFREQ,ACCUMSIZE));
        elsif (key_in(1) = '1') then
            increment <=std_logic_vector(to_unsigned(B*PHASECONSTANT/CLKFREQ,ACCUMSIZE));
        elsif (key_in(0) = '1') then
            increment <=std_logic_vector(to_unsigned(HIGHC*PHASECONSTANT/CLKFREQ,ACCUMSIZE));
        else 
            increment <= (others => '0');
        end if;
    end if;
end process getIncrement;
    
end Behavioral;

