----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:58:26 08/12/2014 
-- Design Name: 
-- Module Name:    OctaveKeyboardTop - Behavioral 
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

library UNISIM;
use UNISIM.VComponents.all;

entity OctaveKeyboardTop is
	 Generic (	ACCUMSIZE	: integer := 13;
					INDEXSIZE	: integer := 8;
					LUTOUT		: integer := 10;
					CLKFREQ 		: integer := 10000);
					
    Port ( keys : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           led_disable : in  STD_LOGIC;
			  tone : out STD_LOGIC;
			  high : out STD_LOGIC;
           key_out : out  STD_LOGIC_VECTOR (7 downto 0));
end OctaveKeyboardTop;

architecture Behavioral of OctaveKeyboardTop is
	
	-- signals for 100MHz to 10Mhz clk divider
	constant CLK_DIV_VALUE 	: integer := 5;
	signal clkcount			: integer := 0;
	signal clk_en				: std_logic := '0';
	signal slowclk				: std_logic;

	-- mapping signals
	signal step : std_logic_vector(ACCUMSIZE-1 downto 0) := (others => '0');
	signal controllerKeys : std_logic_vector(7 downto 0) := (others => '0');
	signal phase : std_logic_vector(INDEXSIZE-1 downto 0) := (others => '0');
	signal lutfreq : std_logic_vector(15 downto 0) := (others => '0');
	signal reg_en : std_logic := '0';

	COMPONENT Controller
		PORT ( clk 				: in  STD_LOGIC;
				 key_in 			: in  STD_LOGIC_VECTOR (7 downto 0);
				 led_disable 	: in  STD_LOGIC;
				 key_out 		: out  STD_LOGIC_VECTOR (7 downto 0));
	END COMPONENT;

	COMPONENT FreqLUT
		PORT ( clk 			: in  STD_LOGIC;
				 key_in 		: in  STD_LOGIC_VECTOR (7 downto 0);
				 increment 	: out  STD_LOGIC_VECTOR (ACCUMSIZE-1 downto 0));
	END COMPONENT;

	COMPONENT DDS
		PORT ( clk 			: in  STD_LOGIC;
				 clk10		: in STD_LOGIC;
				 step			: in	STD_LOGIC_VECTOR(ACCUMSIZE-1 downto 0);
				 phase		: out	STD_LOGIC_VECTOR(INDEXSIZE-1 downto 0));
	END COMPONENT;
	
	COMPONENT PWM
		PORT ( clk 		: in  STD_LOGIC;
				 sample 	: in  STD_LOGIC_VECTOR(LUTOUT-1 downto 0);
				 slowclk : out STD_LOGIC;
             pulse 	: out  STD_LOGIC);
	END COMPONENT;
	
	COMPONENT SinLUT
		PORT ( aclk : IN STD_LOGIC;
				 s_axis_phase_tvalid : IN STD_LOGIC;
				 s_axis_phase_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				 m_axis_data_tvalid : OUT STD_LOGIC;
				 m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
		END COMPONENT;
	
begin

	slowclk_buf: BUFG
      port map (I => clk_en,
                O => slowclk );

	clkDivider: process(clk)
	begin
		if rising_edge(clk) then
			if clkcount = CLK_DIV_VALUE-1 then 
				clk_en <= NOT(clk_en);		
				clkcount <= 0;
			else
				clkcount <= clkcount + 1;
			end if;
		end if;
	end process clkDivider;

	-- map signals
	key_out <= controllerKeys;
	high <= '1';

	KeyControl: Controller
		PORT MAP ( clk 			=> slowclk,
					  key_in 		=> keys,
					  led_disable 	=> led_disable,
					  key_out 		=> controllerKeys);

	keyfrequencies : FreqLUT
		PORT MAP ( clk 			=> slowclk,
					  key_in 		=> controllerKeys,
					  increment 	=> step);
					  
	PhaseAccum: DDS
		PORT MAP ( clk 		=> slowclk,
					  clk10		=> reg_en,
					  step		=> step,
					  phase		=> phase);
					  
	PulseWM: PWM
		PORT MAP ( clk			=> slowclk,
					  sample		=> lutfreq(9 downto 0),
					  slowclk	=> reg_en,
					  pulse		=> tone);
					
	SinFreqs : SinLUT
		PORT MAP ( aclk  						=> slowclk,
					  s_axis_phase_tvalid 	=> '1',
					  s_axis_phase_tdata 	=> phase,
					  m_axis_data_tvalid 	=> open,
					  m_axis_data_tdata 		=> lutfreq);

end Behavioral;





