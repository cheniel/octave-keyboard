----------------------------------------------------------------------------------
-- Company: ENGS031 14X
-- Engineer: Vivian Hu and Daniel Chen
-- 
-- Create Date: 14:29:30 08/11/2014 
-- Design Name: Octave Keyboard
-- Module Name: DDS - Behavioral 
-- Project Name: Octive Keyboard
-- Target Devices: Spartan 6
-- Tool versions: 
-- Description: Phase accumulator and register
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DDS is
    Generic (  ACCUMSIZE    : integer := 13;    -- phase accumulator bitsize
               INDEXSIZE    : integer := 8);    -- SineLUT index bitsize
                    
    Port (  clk    : in  STD_LOGIC;
            step   : in  STD_LOGIC_VECTOR(ACCUMSIZE-1 downto 0);
            clk10  : in  STD_LOGIC;
            phase  : out STD_LOGIC_VECTOR(INDEXSIZE-1 downto 0));
end DDS;

architecture Behavioral of DDS is
    signal curr_phase : unsigned(ACCUMSIZE-1 downto 0) := (others => '0');
begin

    AccumPhase: process(clk, clk10)
    begin
        if (rising_edge(clk)) then
            -- increment at enable from PWM (10kHz)
            if (clk10 = '1') then
                curr_phase <= curr_phase + unsigned(step);
            end if;
        end if;
    end process AccumPhase;
  
    -- take only the 8 most significant bits of the phase as index
    phase <= std_logic_vector(curr_phase(ACCUMSIZE-1 downto ACCUMSIZE-INDEXSIZE));

end Behavioral;

