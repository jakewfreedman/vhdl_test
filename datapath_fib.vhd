library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_fib is
    generic (
        WIDTH : positive := 8);
    port (
		clock, reset : in std_logic;
		n : in std_logic_vector(WIDTH-1 downto 0);
		x_sel, x_ld, n_ld, y_sel, y_ld, i_sel, i_ld, result_ld : in std_logic;
		i_le_n : out std_logic;
		result : out std_logic_vector(WIDTH-1 downto 0)
		);
end datapath_fib;

		


architecture STR of datapath_fib is

	--signal i_sel, x_sel, y_sel : std_logic;
	signal i_mux_out, x_mux_out, y_mux_out : std_logic_vector(WIDTH-1 downto 0);
	--signal i_ld, x_ld, y_ld, n_ld, result_ld : std_logic;
	signal i_reg_out, x_reg_out, y_reg_out, n_reg_out : std_logic_vector(WIDTH-1 downto 0);
	--signal i_le_n : std_logic;
	signal i_add, xy_add : std_logic_vector(WIDTH-1 downto 0);

	
	
begin

	U_I_MUX: entity work.mux_2x1(IF_STATEMENT)
		generic map (
			WIDTH => 8
		)
		port map (
			in1 => "00000011",
			in2 => i_add,
			sel => i_sel,
			output => i_mux_out
		);
		
	U_X_MUX: entity work.mux_2x1(IF_STATEMENT)
		generic map (
			WIDTH => 8
		)
		port map (
			in1 => "00000001",
			in2 => y_reg_out,
			sel => x_sel,
			output => x_mux_out
		);
		
	U_Y_MUX: entity work.mux_2x1(IF_STATEMENT)
		generic map (
			WIDTH => 8
		)
		port map (
			in1 => "00000001",
			in2 => xy_add,
			sel => y_sel,
			output => y_mux_out
		);
		
		
	U_I_REG: entity work.reg
		generic map (
			WIDTH => 8
		)
		port map (
			clk => clock,
			rst => reset,
			en => i_ld,
			input => i_mux_out,
			output => i_reg_out
		);
		
	U_X_REG: entity work.reg
		generic map (
			WIDTH => 8
		)
		port map (
			clk => clock,
			rst => reset,
			en => x_ld,
			input => x_mux_out,
			output => x_reg_out
		);
		
	U_Y_REG: entity work.reg
		generic map (
			WIDTH => 8
		)
		port map (
			clk => clock,
			rst => reset,
			en => y_ld,
			input => y_mux_out,
			output => y_reg_out
		);
		
	U_N_REG: entity work.reg
		generic map (
			WIDTH => 8
		)
		port map (
			clk => clock,
			rst => reset,
			en => n_ld,
			input => n,
			output => n_reg_out
		);
		
	U_COMP: entity work.comparator
		generic map (
			WIDTH => 8
		)
		port map (
			x => i_reg_out,
			y => n_reg_out,
			x_lt_y => i_le_n,
			x_ne_y => open
		);
				

	U_I_ADDER: entity work.adder(CARRY_LOOKAHEAD)
		generic map (
			WIDTH => 8
		)
		port map (
			x => i_reg_out,
			y => "00000001",
			cin => '0',
			s => i_add,
			cout => open
		);
	
	U_XY_ADDER: entity work.adder(CARRY_LOOKAHEAD)
		generic map (
			WIDTH => 8
		)
		port map (
			x => x_reg_out,
			y => y_reg_out,
			cin => '0',
			s => xy_add,
			cout => open
		);
		
		
	U_RES_REG: entity work.reg
		generic map (
			WIDTH => 8
		)
		port map (
			clk => clock,
			rst => reset,
			en => result_ld,
			input => y_reg_out,
			output => result
		);
		

	
end STR;
