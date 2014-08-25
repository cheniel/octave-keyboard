--------------------------------------------------------------------------------
-- Company: ENGS031 14X
-- Engineer: Daniel Chen, Vivian Hu
-- 
-- Create Date:    11:40:24 08/16/2014 
-- Design Name:    Play Counter
-- Module Name:    PlayCount - Behavioral 
-- Project Name:   Octave-Keyboard
-- Target Devices: Nexys3
-- Tool versions: 
-- Description: Play Counter used to keep track of beats for the controller FSM.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PlayCount is
    Port (  clk : in  STD_LOGIC;
            count_en : in STD_LOGIC;
            count_to : in  STD_LOGIC_VECTOR (3 downto 0);
            tc_tick : out  STD_LOGIC);
end PlayCount;

architecture Behavioral of PlayCount is
    constant QRTR_CLK_DIV    : integer := 12500000;
    signal   clkcount    : integer := 0;
    signal   count        : unsigned(3 downto 0) := "0001";
begin
    
    -- counts for a quarter second
    Qrtr_Sec_Count: process(clk)
    begin
        if (rising_edge(clk)) then
            -- if the clock is rising and counting is enabled
            if (count_en = '1') then 
                tc_tick <= '0';
                
                -- if a quarter second has passed
                if (clkcount = QRTR_CLK_DIV - 1) then

                    -- if enough quarter seconds have passed
                    if (count = unsigned(count_to)) then 
                        tc_tick <= '1';  -- tell the controller
                        count <= "0001"; -- reset the count

                    -- otherwise, just wait for enough quarter seconds to pass.
                    else
                        count <= count + 1;
                    end if;
                    
                    clkcount <= 0;

                -- wait for a quarter second otherwise
                else
                    clkcount <= clkcount + 1; 
                end if;
            else
                tc_tick <= '0';
            end if;
        end if;
    end process Qrtr_Sec_Count;            
end Behavioral;

