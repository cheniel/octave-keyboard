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
			  song_enable : in STD_LOGIC;
			  --play_en	: in STD_LOGIC;
			  tone : out STD_LOGIC;
			  shutdown : out STD_LOGIC;
           key_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  led_out : out  STD_LOGIC_VECTOR (7 downto 0));
end OctaveKeyboardTop;

architecture Behavioral of OctaveKeyboardTop is
	
	-- signals for 100MHz to 10Mhz clk divider
	constant CLK_DIV_VALUE 	: integer := 1;
	signal clkcount			: integer := 0;
	signal clk_en				: std_logic := '0';
	signal slowclk				: std_logic;

	signal led_disable_sync : std_logic := '0';
	signal song_enable_sync : std_logic := '0';

	-- mapping signals
	signal step : std_logic_vector(ACCUMSIZE-1 downto 0) := (others => '0');
	signal controllerKeys : std_logic_vector(7 downto 0) := (others => '0');
	signal phase : std_logic_vector(INDEXSIZE-1 downto 0) := (others => '0');
	signal lutfreq : std_logic_vector(15 downto 0) := (others => '0');
	signal reg_en : std_logic := '0';
	signal tempo_en : std_logic := '0';

	signal keyDB : std_logic_vector(7 downto 0) := (others => '0');

	signal countDone : std_logic := '0';
	signal count : std_logic_vector(3 downto 0) := (others => '0');

	COMPONENT Controller
		PORT ( clk 				: in  STD_LOGIC;
				 key_in 			: in  STD_LOGIC_VECTOR (7 downto 0);
				 led_disable 	: in  STD_LOGIC;
				 song_enable 	: in 	STD_LOGIC;
				 beat_tick 		: in 	STD_LOGIC;
				 beat_en			: out STD_LOGIC;
				 count_out		: out STD_LOGIC_VECTOR(3 downto 0);
				 key_out 		: out  STD_LOGIC_VECTOR (7 downto 0);
				 led_out			: out STD_LOGIC_VECTOR (7 downto 0));
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
		
	COMPONENT debounce
		PORT ( clk : IN STD_LOGIC;
				 switch : IN STD_LOGIC;
				 dbswitch : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT PlayCount is
		PORT ( 	clk : in  STD_LOGIC;
					count_en : in STD_LOGIC;
					count_to : in  STD_LOGIC_VECTOR (3 downto 0);
					tc_tick : out  STD_LOGIC);
	END COMPONENT;
	
begin

	SynchronizeSwitches: process(clk) 
	begin
		if rising_edge(clk) then
			led_disable_sync <= led_disable;
			song_enable_sync <= song_enable;
		end if;
	end process SynchronizeSwitches;

	slowclk_buf: BUFG
      port map (I => clk_en,
                O => slowclk );

	clkDivider: process(clk)
	begin
		if rising_edge(clk) then
			clk_en <= NOT(clk_en);
		end if;
	end process clkDivider;

	-- map signals
	key_out <= controllerKeys;
	shutdown <= '1';

	debouncer0: debounce
		Port map ( 	clk => slowclk,	
					switch => keys(0),
					dbswitch => keyDB(0) );		

	debouncer1: debounce
		Port map ( 	clk => slowclk,	
					switch => keys(1),
					dbswitch => keyDB(1) );		

	debouncer2: debounce
		Port map ( 	clk => slowclk,	
					switch => keys(2),
					dbswitch => keyDB(2) );		

	debouncer3: debounce
		Port map ( 	clk => slowclk,	
					switch => keys(3),
					dbswitch => keyDB(3) );		

	debouncer4: debounce
		Port map ( 	clk => slowclk,	
					switch => keys(4),
					dbswitch => keyDB(4) );		

	debouncer5: debounce
		Port map ( 	clk => slowclk,	
					switch => keys(5),
					dbswitch => keyDB(5) );		

	debouncer6: debounce
		Port map ( 	clk => slowclk,	
					switch => keys(6),
					dbswitch => keyDB(6) );		

	debouncer7: debounce
		Port map ( 	clk => slowclk,	
					switch => keys(7),
					dbswitch => keyDB(7) );		

	KeyControl: Controller
		PORT MAP ( clk 			=> slowclk,
					  key_in 		=> keyDB,
					  led_disable 	=> led_disable_sync,
					  song_enable 	=> song_enable_sync,
					  beat_tick 	=> countdone,
					  beat_en		=> tempo_en,
					  count_out		=> count,
					  key_out 		=> controllerKeys,
					  led_out		=> led_out);

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

	kidsCounter : PlayCount
		PORT MAP	( clk => slowclk,
					  count_en => tempo_en,
					  count_to => count,
					  tc_tick => countDone);

end Behavioral;





