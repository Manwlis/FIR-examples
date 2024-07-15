library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_t_coeff.all;
use ieee.math_real.all;

entity fir_filter is
	generic (
        constant c_input_size  : positive range 1 to 64 := 8;
        constant c_output_size : positive range 1 to 64 := 10;
        constant c_num_coef    : positive range 1 to 64 := 5;
        constant c_coef_width  : positive range 1 to 64 := 8
	);
	port (
		i_clk   : in std_logic;
		i_reset : in std_logic;
		-- coefficient
		i_coeff : in t_coeff;
		-- data input
		i_data  : in std_logic_vector( c_input_size-1 downto 0 );
		-- filtered data
		o_data  : out std_logic_vector( c_output_size-1 downto 0 )
	);
end fir_filter;

architecture rtl of fir_filter is

	constant c_product_size : positive := c_input_size + c_coef_width;
	constant c_sum_size     : positive := c_product_size + integer( ceil( log2( real( c_num_coef ) ) ) );

	type t_product is array( 0 to c_num_coef-1 ) of signed( c_product_size-1 downto 0 );
	type t_sum     is array( 0 to c_num_coef-1 ) of signed( c_sum_size-1 downto 0 );

	signal s_product : t_product;
	signal s_sum     : t_sum;

begin

	o_data <= std_logic_vector( s_sum(0)( c_sum_size-1 downto c_sum_size-c_output_size ) );

	process( i_clk )
	begin
		if ( rising_edge( i_clk ) ) then
			if i_reset = '1' then
				for k in 0 to c_num_coef-1 loop
					s_product(k) <= ( others => '0' );
					s_sum(k) <= ( others => '0' );
				end loop;
			else
				for k in 0 to c_num_coef-1 loop
					s_product(k) <= signed( i_data ) * signed( i_coeff(k) );
					if ( k < c_num_coef-1 ) then
						s_sum(k) <= resize( s_product(k) , c_sum_size ) + s_sum(k+1);
					else
						s_sum(k) <= resize( s_product(k) , c_sum_size );
					end if;
				end loop;
			end if;
		end if;
	end process;
end rtl;