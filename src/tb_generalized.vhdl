library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pkg_t_coeff is
  	type t_coeff is array ( natural range<> ) of std_logic_vector;
    constant INPUT_SIZE : positive := 8;
    constant OUTPUT_SIZE : positive := 12;
    constant NUM_COEF : positive := 5;
    constant COEF_WIDTH : positive := 8;
end package pkg_t_coeff;


library ieee;
use ieee.std_logic_1164.all;
use work.pkg_t_coeff.all;
use IEEE.math_real.all;

entity tb_fir_filter is
end tb_fir_filter;

architecture tb of tb_fir_filter is
	
	component fir_filter
		generic (
            constant c_input_size  : positive;
            constant c_output_size : positive;
            constant c_num_coef    : positive;
            constant c_coef_width  : positive
		);
		port (
			i_clk   : in std_logic;
			i_reset : in std_logic;
			i_coeff : in t_coeff( c_num_coef-1 downto 0 )( c_coef_width-1 downto 0 );
			i_data  : in std_logic_vector( c_input_size-1 downto 0 );
			o_data  : out std_logic_vector( c_output_size-1 downto 0 )
		);
	end component;

	signal i_clk   : std_logic;
	signal i_reset : std_logic;
	signal i_coeff : t_coeff( NUM_COEF-1 downto 0 )( COEF_WIDTH-1 downto 0 );
	signal i_data  : std_logic_vector( INPUT_SIZE-1 downto 0 );
	signal o_data  : std_logic_vector( OUTPUT_SIZE-1 downto 0 );

	constant TbPeriod : time := 100 ns;
	signal TbClock    : std_logic := '0';
	signal TbSimEnded : std_logic := '0';

begin

	fir_filter_inst : fir_filter
		generic map (
			c_input_size => INPUT_SIZE,
			c_output_size => OUTPUT_SIZE,
            c_num_coef => NUM_COEF,
            c_coef_width => COEF_WIDTH
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
		i_coeff(4) <= b"1010_1101";
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