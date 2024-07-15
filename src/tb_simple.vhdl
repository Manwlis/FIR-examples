-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 12.6.2024 21:12:56 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_fir_filter_4 is
end tb_fir_filter_4;

architecture tb of tb_fir_filter_4 is

    component fir_filter_4
        port (i_clk     : in std_logic;
              i_coeff_0 : in std_logic_vector (7 downto 0);
              i_coeff_1 : in std_logic_vector (7 downto 0);
              i_coeff_2 : in std_logic_vector (7 downto 0);
              i_coeff_3 : in std_logic_vector (7 downto 0);
              i_data    : in std_logic_vector (7 downto 0);
              o_data    : out std_logic_vector (9 downto 0));
    end component;

    signal i_clk     : std_logic;
    signal i_coeff_0 : std_logic_vector (7 downto 0);
    signal i_coeff_1 : std_logic_vector (7 downto 0);
    signal i_coeff_2 : std_logic_vector (7 downto 0);
    signal i_coeff_3 : std_logic_vector (7 downto 0);
    signal i_data    : std_logic_vector (7 downto 0);
    signal o_data    : std_logic_vector (9 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : fir_filter_4
    port map (i_clk     => i_clk,
              i_coeff_0 => i_coeff_0,
              i_coeff_1 => i_coeff_1,
              i_coeff_2 => i_coeff_2,
              i_coeff_3 => i_coeff_3,
              i_data    => i_data,
              o_data    => o_data);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that i_clk is really your main clock signal
    i_clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        i_coeff_0 <= b"1010_1111";
        i_coeff_1 <= b"1010_1001";
        i_coeff_2 <= b"1111_1001";
        i_coeff_3 <= b"1010_1101";
        i_data <= (others => '0');

		
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
        i_data <= (others => '0');
        
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_fir_filter_4 of tb_fir_filter_4 is
    for tb
    end for;
end cfg_tb_fir_filter_4;