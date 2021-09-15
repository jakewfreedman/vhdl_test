library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib_tb is
end fib_tb;


architecture TB of fib_tb is

	-- component top_fib
		-- port (
			-- clock : in  std_logic;
			-- reset : in std_logic;
			-- n : in std_logic_vector(7 downto 0);
			-- done : out std_logic;
			-- result : out std_logic_vector(7 downto 0);
			-- go    : in std_logic
			-- );
	-- end component;

	component fib
		port (
			clock : in  std_logic;
			reset : in std_logic;
			n : in std_logic_vector(7 downto 0);
			done : out std_logic;
			result : out std_logic_vector(7 downto 0);
			go    : in std_logic
			);
	end component;

signal clock : std_logic := '0';
signal reset : std_logic := '0';
signal clock_en : std_logic := '1';
signal n : std_logic_vector(7 downto 0);
signal done : std_logic;
signal result : std_logic_vector(7 downto 0);
signal go : std_logic := '0';

begin


	-- UUT: top_fib
		-- generic map(
			-- WIDTH => 8
		-- )
		-- port map(
			-- clock => clock,
			-- reset => reset,
			-- n => n,
			-- done => done,
			-- result => result,
			-- go => go
			-- );
			
	UUT: fib
		generic map(
			WIDTH => 8
		)
		port map(
			clock => clock,
			reset => reset,
			n => n,
			done => done,
			result => result,
			go => go
			);

	clock <= not clock and clock_en after 10 ns;
			
	process
	begin
	    -- test all input combinations
		-- for i in 1 to 255 loop				  
			-- n <= std_logic_vector(to_unsigned(i,8));
			-- go <= '1';
			-- wait for 100 ns;
			-- go <= '0';
			-- wait for 20 ns;
		-- end loop;
		-- clock_en <= '0';
		-- wait;
		wait for 10 ns;
		reset <= '1';
		wait for 10 ns;
		reset <= '0';
		wait for 10 ns;
		
		n <= "00000001";
		go <= '1';
		wait for 160 ns;
		go <= '0';
		wait for 20 ns;
		n <= "00000010";
		go <= '1';
		wait for 160 ns;
		go <= '0';
		wait for 20 ns;
		n <= "00000011";
		go <= '1';
		wait for 160 ns;
		go <= '0';
		wait for 20 ns;
		n <= "00000100";
		go <= '1';
		wait for 180 ns;
		go <= '0';
		wait for 20 ns;
		n <= "00000101";
		go <= '1';
		wait for 220 ns;
		go <= '0';
		wait for 20 ns;
		n <= "00000110";
		go <= '1';
		wait for 260 ns;
		go <= '0';
		wait for 20 ns;
		n <= "00000111";
		go <= '1';
		wait for 320 ns;
		go <= '0';
		wait for 20 ns;
		n <= "00001000";
		go <= '1';
		wait for 380 ns;
		go <= '0';
		wait for 20 ns;
		clock_en <= '0';
		wait;
		
	
	end process;

end TB;