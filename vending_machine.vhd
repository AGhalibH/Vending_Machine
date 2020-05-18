library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine is
	port (
		-- Control
		money 	: inout std_logic_vector(1 downto 0) := "00";
		sel		: in std_logic_vector(3 downto 0) := "0000";
		CLK		: in std_logic;
		nRST	: in std_logic := '1';

		-- Drinks
		water 	: out std_logic := '0';
		tea 	: out std_logic := '0';
		milk 	: out std_logic := '0';
		coffee 	: out std_logic := '0';
		grn_tea	: out std_logic := '0';
		soda	: out std_logic := '0';

		-- Snacks
		candy 		: out std_logic := '0';
		choco_bar 	: out std_logic := '0';
		gum 		: out std_logic := '0';
		cookies 	: out std_logic := '0';
		chips 		: out std_logic := '0';
		
		-- Other outputs
		change	: out string(1 to 9) := "Rp  0.000";
		stock 	: out std_logic_vector(3 downto 0)
	);
end vending_machine;

architecture Bhvr of vending_machine is

	component ram32x4_dual is
	port
	(
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		rdaddress	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		wraddress	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		wrclock		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
	end component;

	type state_type is (start, rp5, rp10, rp15, rp20, fin);
	signal state, next_state : state_type := start;

	signal sel_class	: std_logic_vector(1 downto 0) := "00";
	signal sel_out		: std_logic_vector(3 downto 0) := "0000";

	signal nCLK 	: std_logic;
	signal rdAdd 	: std_logic_vector(4 downto 0) := (others =>'0');
	signal wrAdd 	: std_logic_vector(4 downto 0) := (others =>'0');
	signal count 	: std_logic_vector(3 downto 0) := (others => '0');
	signal wren 	: std_logic := '0';
	signal q		: std_logic_vector(3 downto 0) := (others => '0');

begin

	-- Process untuk menerima uang
	process(sel)
	begin

		if (sel /= "0000" and state /= start) then

			money <= "00";

		end if;
	end process;
	
	-- Agar mempersingkat kondisi untuk perpindahan state
	-- input dibagi menjadi kelas-kelas berdasarkan harga barang
	sel_class <= 	"01" when sel = "0001" else
					"01" when sel = "0010" else
					"01" when sel = "0011" else
					"10" when sel = "0100" else
					"10" when sel = "0101" else
					"10" when sel = "0110" else
					"01" when sel = "0111" else
					"01" when sel = "1000" else
					"01" when sel = "1001" else
					"10" when sel = "1010" else
					"11" when sel = "1011" else
					"00";

	-- ------------------------------------------ FINITE STATE MACHINE ------------------------------------------
	process(CLK)
	begin

		if (falling_edge(CLK)) then

			state <= next_state;

		end if;
	end process;

	-- State process
	process(nRst, state, money, sel_class)
	begin

		if (nRST = '0') then
			next_state <= start;
		else
		case(state) is

			when start =>

				case(money) is

					when "01" 	=> next_state <= rp5;
					when "10" 	=> next_state <= rp10;
					when "11" 	=> next_state <= rp20;
					when others => next_state <= start;
				end case;

			when rp5 =>

				if (sel_class = "00") then
					case(money) is

						when "01" 	=> next_state <= rp10;
						when "10" 	=> next_state <= rp15;
						when others => next_state <= rp5;
					end case;

				else
					case(sel_class) is

						when "01" 	=> next_state <= fin;
						when others => next_state <= rp5;
					end case;
				end if;

			when rp10 =>

				if (sel_class = "00") then
					case(money) is

						when "01" 	=> next_state <= rp15;
						when "10" 	=> next_state <= rp20;
						when others => next_state <= rp10;
					end case;
				else
					case(sel_class) is

						when "01" 	=> next_state <= rp5;
						when "10" 	=> next_state <= fin;
						when others => next_state <= rp10;
					end case;
				end if;

			when rp15 =>

				if (sel_class = "00") then
					case(money) is

						when "01" 	=> next_state <= rp20;
						when others => next_state <= rp15;
					end case;
				else
					case(sel_class) is

						when "01" 	=> next_state <= rp10;
						when "10" 	=> next_state <= rp5;
						when "11" 	=> next_state <= fin;
						when others => next_state <= rp15;
					end case;
				end if;

			when rp20 =>

				case(sel_class) is

					when "01" 	=> next_state <= rp15;
					when "10" 	=> next_state <= rp10;
					when "11" 	=> next_state <= rp5;
					when others => next_state <= rp20;
				end case;

			when fin => next_state <= start;
		end case;
		end if;
	end process;

	-- Output Process
	process(CLK, state, sel)
	begin

		-- Output Cases
		-- Agar output berupa sinyal impulse pada saat CLK = 1, maka dimatikan saat CLK = 0
		if (CLK = '1') then
			case(state) is

				when rp5 =>

					case(sel) is
					
						when "0001"|"0010"|"0011" => sel_out <= sel;
						when "0111"|"1000"|"1001" => sel_out <= sel;
						when others => 
							sel_out <= "0000";
					end case;
					
				when rp10 =>

					case(sel) is
						
						when "0001"|"0010"|"0011" => sel_out <= sel;
						when "0111"|"1000"|"1001" => sel_out <= sel;
						when "0100"|"0101"|"0110" => sel_out <= sel;
						when "1010" => sel_out <= sel;
						when others => 
							sel_out <= "0000";
					end case;

				when rp15|rp20 =>

					case(sel) is
						
						when "0001"|"0010"|"0011" => sel_out <= sel;
						when "0111"|"1000"|"1001" => sel_out <= sel;
						when "0100"|"0101"|"0110" => sel_out <= sel;
						when "1010" => sel_out <= sel;
						when "1011" => sel_out <= sel;
						when others => 
							sel_out <= "0000";
					end case;

				when others => 
					sel_out <= "0000";
				
			end case;
		else 
			sel_out <= "0000";
		end if;
	end process;
	
	-- ------------------------------------------ MEMORY MANAGEMENT ------------------------------------------
	nCLK 	<= not CLK;
	rdAdd 	<= '0' & sel;
	count 	<= std_logic_vector(unsigned(q) + 1);
	
	ram : 	entity work.ram32x4_dual
			port map (count, rdAdd, nCLK, wrAdd, CLK, wren, q);
	
	-- Memory Process
	process(CLK, state, sel)
	begin
		if (falling_edge(CLK)) then
		
			wrAdd 	<= rdAdd;
			
			case(state) is

				when rp5 =>

					case(sel) is
					
						when "0001"|"0010"|"0011" => wren <= '1'; 
						when "0111"|"1000"|"1001" => wren <= '1';
						when others => 
							wren <= '0';
					end case;
					
				when rp10 =>

					case(sel) is
						
						when "0001"|"0010"|"0011" => wren <= '1';
						when "0111"|"1000"|"1001" => wren <= '1';
						when "0100"|"0101"|"0110" => wren <= '1';
						when "1010" => wren <= '1';
						when others => 
							wren <= '0';
					end case;

				when rp15|rp20 =>

					case(sel) is
						
						when "0001"|"0010"|"0011" => wren <= '1';
						when "0111"|"1000"|"1001" => wren <= '1';
						when "0100"|"0101"|"0110" => wren <= '1';
						when "1010" => wren <= '1';
						when "1011" => wren <= '1';
						when others => 
							wren <= '0';
					end case;

				when others => 
					wren <= '0';
			end case;
		end if;
	end process;
	
	-- ------------------------------------------ MISCELLANEOUS OUTPUTS ------------------------------------------
	-- Output barang
	water 		<= '1' when sel_out = "0001" else '0';
	tea 		<= '1' when sel_out = "0010" else '0';
	milk 		<= '1' when sel_out = "0011" else '0';
	grn_tea		<= '1' when sel_out = "0100" else '0';
	coffee 		<= '1' when sel_out = "0101" else '0';
	soda 		<= '1' when sel_out = "0110" else '0';
	candy 		<= '1' when sel_out = "0111" else '0';
	choco_bar 	<= '1' when sel_out = "1000" else '0';
	gum 		<= '1' when sel_out = "1001" else '0';
	cookies		<= '1' when sel_out = "1010" else '0';
	chips 		<= '1' when sel_out = "1011" else '0';
	
	-- Output jumlah barang yang tersisa
	stock	<= not q;
	
	-- Output jumlah uang yang tersisa dalam String
	change <= 	"Rp  5.000" when state = rp5 else
				"Rp 10.000" when state = rp10 else
				"Rp 15.000" when state = rp15 else
				"Rp 20.000" when state = rp20 else
				"Rp  0.000";
	
end Bhvr;