library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib is
	generic (
		WIDTH : positive := 8);
	port (
		n : in std_logic_vector(WIDTH-1 downto 0);
		done : out std_logic;
		result : out std_logic_vector(WIDTH-1 downto 0);
		clock, reset, go : in std_logic
		);
end fib;




architecture FSMD2 of fib is

	type state_type is (S_START, S_RESTART, S_INIT, S_LOOP_COND, S_LOOP_BODY, S_FINISH, S_DONE);
	signal state, next_state : state_type;
	--signal out_sig : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
	
	
begin  -- FSMD


	process(clock,reset)
	begin
		if (reset = '1') then
			state <= S_START;
		elsif (rising_edge(clock)) then
			state <= next_state;
		end if;
	end process;
	
	process(state, go)
		
		variable tmpx, tmpy, tmpi, tmpr, temp : std_logic_vector(WIDTH-1 downto 0);
		
	begin
		
		done <= '0';
		result <= "00000000";
		next_state <= state;
		
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
			
				tmpx := "00000001";
				tmpy := "00000001";
				tmpi := "00000011";
				
				next_state <= S_LOOP_COND;
				
			when S_LOOP_COND =>
				if (tmpi <= n) then	
					next_state <=  S_LOOP_BODY;		
				else
					--next_state <= S_FINISH;
					next_state <= S_DONE;
				end if;		
				
			when S_LOOP_BODY =>		
				
				temp := std_logic_vector(unsigned(tmpx) + unsigned(tmpy));
				tmpx := tmpy;
				tmpy := temp;
				tmpi := std_logic_vector(unsigned(tmpi) + to_unsigned(1, 8));
				next_state <= S_LOOP_COND;
				
			when S_FINISH =>
				
				-- tmpr := tmpy;
				
				-- next_state <= S_DONE;
				
			when S_DONE =>
			
				tmpr := tmpy;
				

				if (go = '0') then
					next_state <= S_RESTART;
				else
					next_state <= S_DONE;
				end if;
				
				done <= '1';

			when others =>
				null;
		end case;
		
		result <= tmpr;
		
	end process;
		
	
end FSMD2;