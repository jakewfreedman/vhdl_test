library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl_fib is
	port (
		x_sel, x_ld, n_ld, y_sel, y_ld, i_sel, i_ld, result_ld, done : out std_logic;
		clk, rst, i_le_n, go : in std_logic
		);
end ctrl_fib;

architecture BHV of ctrl_fib is

	type state_type is (S_START, S_RESTART, S_INIT, S_LOOP_COND, S_LOOP_BODY, S_FINISH, S_DONE);
	signal state, next_state : state_type;

begin

	process(clk,rst)
	begin
		if (rst = '1') then
			state <= S_START;
		elsif (rising_edge(clk)) then
			state <= next_state;
		end if;
	end process;
	
	process(state, go, i_le_n)
	begin

		next_state <= state;
		
		i_sel <= '0';
		x_sel <= '0';
		y_sel <= '0';
		i_ld <= '0';
		x_ld <= '0';
		y_ld <= '0';
		n_ld <= '0';
		result_ld <= '0';
		done <= '0';
		
		case state is
			when S_START =>
				if (go = '1') then
					next_state <= S_INIT;
				else
					next_state <= S_START;
				end if;

			when S_RESTART =>			
				if (go = '0') then
					next_state <= S_RESTART;
				else
					next_state <= S_INIT;
				end if;	
				done <= '1';
				
			when S_INIT =>
			
				n_ld <= '1';
				i_sel <= '0';
				x_sel <= '0';
				y_sel <= '0';
				i_ld <= '1';
				x_ld <= '1';
				y_ld <= '1';
				
				next_state <= S_LOOP_COND;
				
			when S_LOOP_COND =>
				if (i_le_n = '1') then	
					next_state <=  S_LOOP_BODY;		
				else
					next_state <= S_FINISH;
				end if;		
				
			when S_LOOP_BODY =>		
				
				x_sel <= '1';
				y_sel <= '1';
				i_ld <= '1';
				x_ld <= '1';
				y_ld <= '1';
				i_sel <= '1';
				
				next_state <= S_LOOP_COND;
				
			when S_FINISH =>
				result_ld <= '1';
				
				next_state <= S_DONE;
				
			when S_DONE =>

				if (go = '0') then
					next_state <= S_RESTART;
				else
					next_state <= S_DONE;
				end if;
				
				done <= '1';

			when others =>
				null;
		end case;
		
	end process;
end BHV;