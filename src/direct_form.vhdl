library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_filter_4 is
port (
	i_clk        : in  std_logic;
	-- coefficient
	i_coeff_0    : in  std_logic_vector( 7 downto 0);
	i_coeff_1    : in  std_logic_vector( 7 downto 0);
	i_coeff_2    : in  std_logic_vector( 7 downto 0);
	i_coeff_3    : in  std_logic_vector( 7 downto 0);
	-- data input
	i_data       : in  std_logic_vector( 7 downto 0);
	-- filtered data 
	o_data       : out std_logic_vector( 9 downto 0));
end fir_filter_4;

architecture rtl of fir_filter_4 is

	type t_data_pipe	is array (0 to 3) of signed(7  downto 0);
	type t_coeff		is array (0 to 3) of signed(7  downto 0);
	type t_product		is array (0 to 3) of signed(15 downto 0);
	type t_sum			is array (0 to 3) of signed(17 downto 0);

	signal r_coeff	: t_coeff ;
	signal p_data	: t_data_pipe;
	signal r_mult	: t_product;
	signal r_add	: signed(15+2  downto 0);

begin

	p_input : process (i_clk)
	begin
		if(rising_edge(i_clk)) then
			p_data      <= signed(i_data)&p_data(0 to p_data'length-2);
			r_coeff(0)  <= signed(i_coeff_0);
			r_coeff(1)  <= signed(i_coeff_1);
			r_coeff(2)  <= signed(i_coeff_2);
			r_coeff(3)  <= signed(i_coeff_3);

			for k in 0 to 3 loop
				r_mult(k) <= p_data(k) * r_coeff(k);
			end loop;
            
            r_add <= resize( r_mult(0) , 18 ) + resize( r_mult(1) , 18 ) + resize( r_mult(2) , 18 ) + resize( r_mult(3) , 18 );

			o_data <= std_logic_vector( r_add(17 downto 8) );
		end if;
	end process p_input;
end rtl;