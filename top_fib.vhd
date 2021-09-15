library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_fib is
	generic (
		WIDTH : positive := 8);
	port (
		n : in std_logic_vector(WIDTH-1 downto 0);
		done : out std_logic;
		result : out std_logic_vector(WIDTH-1 downto 0);
		clock, reset, go : in std_logic
		);
end top_fib;

architecture STR of top_fib is

	signal x_sel, x_ld, n_ld, y_sel, y_ld, i_sel, i_ld, result_ld : std_logic;
	signal i_le_n : std_logic;

begin

	U_DATAPATH: entity work.datapath_fib
		generic map (
			WIDTH => 8
		)
		port map (
			clock => clock,
			reset => reset,
			n => n,
			result => result,
			x_sel => x_sel,
			y_sel => y_sel,
			i_sel => i_sel,
			x_ld => x_ld,
			y_ld => y_ld,
			i_ld => i_ld,
			n_ld => n_ld,
			result_ld => result_ld,
			i_le_n => i_le_n
		);
		



		
	U_CTRL: entity work.ctrl_fib
		port map (
			clk => clock,
			rst => reset,
			x_sel => x_sel,
			y_sel => y_sel,
			i_sel => i_sel,
			x_ld => x_ld,
			y_ld => y_ld,
			i_ld => i_ld,
			n_ld => n_ld,
			result_ld => result_ld,
			i_le_n => i_le_n,
			go => go,
			done => done
		);
			
	
	

end STR;