library ieee;
use ieee.std_logic_1164.all;
use work.pkg_t_coeff.all;
use IEEE.math_real.all;

entity tb_fir_filter is
end tb_fir_filter;

architecture tb of tb_fir_filter is

	component fir_filter
		generic (
			c_input_size  : positive range 1 to 64 := 8;
			c_output_size : positive range 1 to 64 := 8;
		);
		port (
			i_clk   : in std_logic;
			i_reset : in std_logic;
			i_coeff : in t_coeff;
			i_data  : in std_logic_vector ( c_input_size-1 downto 0 );
			o_data  : out std_logic_vector ( c_output_size-1 downto 0 )
		);
	end component;

	signal i_clk   : std_logic;
	signal i_reset : std_logic;
	signal i_coeff : t_coeff;
	signal i_data  : std_logic_vector ( 7 downto 0 );
	signal o_data  : std_logic_vector ( 9 downto 0 );

	constant TbPeriod : time := 100 ns;
	signal TbClock    : std_logic := '0';
	signal TbSimEnded : std_logic := '0';

begin

	fir_filter_inst : fir_filter
		generic map (
			c_input_size => 8,
			c_output_size => 10
		)
		port map (
			i_clk   => i_clk,
			i_reset => i_reset,
			i_coeff => i_coeff,
			i_data  => i_data,
			o_data  => o_data
		);

	-- Clock generation
	TbClock <= not TbClock after TbPeriod / 2 when TbSimEnded /= '1' else '0';

	-- pass lock to module
	i_clk <= TbClock;

	stimuli : process
	begin
		-- reset
		i_reset <= '1';
		-- initialization
		wait for TbPeriod;
		i_reset <= '0';
		i_coeff(0) <= b"1010_1111";
		i_coeff(1) <= b"1010_1001";
		i_coeff(2) <= b"1111_1001";
		i_coeff(3) <= b"1010_1101";
		i_data <= ( others => '0' );

		-- begin inputs
		wait for TbPeriod;
		i_data <= b"1111_1111";
		
		wait for TbPeriod;
		i_data <= b"1111_1100";
		
		wait for TbPeriod;
		i_data <= b"0011_1111";
		
		wait for TbPeriod;
		i_data <= b"0011_1111";
		
		wait for TbPeriod;
		i_data <= b"1111_1111";
		
		wait for TbPeriod;
		i_data <= ( others => '0' );
		
		wait for 10 * TbPeriod;

		-- Stop the clock and hence terminate the simulation
		TbSimEnded <= '1';
		wait;
	end process;

end tb;