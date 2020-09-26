LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
use IEEE.numeric_std.all;

entity pipe_gen is
port(mode : in std_logic_vector(2 downto 0);
		pixel_row, pixel_column : in std_logic_vector(9 downto 0);
		lsfr_num : in std_logic_vector(3 downto 0);
		reset, vert_sync, enable : in std_logic;
		pipe_on : out std_logic;
		pipe_pos, pipe_gap : out std_logic_vector(9 downto 0);
		lsfr_clk : out std_logic);
end entity pipe_gen;

architecture behaviour of pipe_gen is

	signal pipe_width : std_logic_vector(9 downto 0);
	signal pipe_x_pos : std_logic_vector(9 downto 0):= CONV_STD_LOGIC_VECTOR(660,10);
	signal pipe_movement : std_logic_vector(9 downto 0);
	signal pipe_display : std_logic;
	
begin
	pipe_width <= CONV_STD_LOGIC_VECTOR(16,10);
	pipe_on <= '1' when  ('0' & pipe_x_pos <= '0' & pixel_column + pipe_width) and ('0' & pixel_column <= '0' & pipe_x_pos + pipe_width) -- x_pos - size <= pixel_column <= x_pos + size
						and pipe_display = '1' and enable = '1'
						else '0';
	pipe_movement <= - CONV_STD_LOGIC_VECTOR(0,10) when mode = "000" else -- Main Menu
                        - CONV_STD_LOGIC_VECTOR(2,10) when mode = "001" else -- Training Mode
                        - CONV_STD_LOGIC_VECTOR(2,10) when mode = "010" else -- Game Mode: level 1
                        - CONV_STD_LOGIC_VECTOR(3,10) when mode = "011" else -- Game Mode: level 2
                        - CONV_STD_LOGIC_VECTOR(4,10) when mode = "100" else -- Game Mode: level 3
                        - CONV_STD_LOGIC_VECTOR(0,10) when mode = "101" else -- Pause Game
                        - CONV_STD_LOGIC_VECTOR(0,10) when mode = "111" else -- Game Over
                        - CONV_STD_LOGIC_VECTOR(0,10);
	pipe_pos <= pipe_x_pos;
	lsfr_clk <= '1' when reset = '1' else '0';

	pipe_move : process(reset, vert_sync)
	begin
	-- Move pipe once every vertical sync
	if (rising_edge(vert_sync)) then
		if enable = '1' then
			pipe_x_pos <= pipe_x_pos + pipe_movement;
		elsif reset = '1' then
			pipe_x_pos <= CONV_STD_LOGIC_VECTOR(660,10);
		end if;
	end if;
	end process pipe_move;
	
	pipe_gap_pos: process(pixel_row, pixel_column, lsfr_num)
	begin
		pipe_display <= '1';
		case lsfr_num is
			WHEN "0001" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(150,10);
				IF(pixel_row >= 150 AND pixel_row <= 220) THEN
					pipe_display <= '0';
				END IF;
			WHEN "0010" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(220,10);
				IF(pixel_row >= 220 AND pixel_row <= 290) THEN
					pipe_display <= '0';
				END IF;
			WHEN "0011" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(290,10);
				IF(pixel_row >= 290 AND pixel_row <= 360) THEN
					pipe_display <= '0';
				END IF;
			WHEN "0100" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(360,10);
				IF(pixel_row >= 360 AND pixel_row <= 430) THEN
					pipe_display <= '0';
				END IF;
			WHEN "0101" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(165,10);
				IF(pixel_row >= 165 AND pixel_row <= 235) THEN
					pipe_display <= '0';
				END IF;
			WHEN "0110" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(235,10);
				IF(pixel_row >= 235 AND pixel_row <= 305) THEN
					pipe_display <= '0';
				END IF;
			WHEN "0111" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(305,10);
				IF(pixel_row >= 305 AND pixel_row <= 375) THEN
					pipe_display <= '0';
				END IF;
			WHEN "1000" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(180,10);
				IF(pixel_row >= 180 AND pixel_row <= 250) THEN
					pipe_display <= '0';
				END IF;
			WHEN "1001" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(250,10);
				IF(pixel_row >= 250 AND pixel_row <= 320) THEN
					pipe_display <= '0';
				END IF;
			WHEN "1010" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(320,10);
				IF(pixel_row >= 320 AND pixel_row <= 390) THEN
					pipe_display <= '0';
				END IF;
			WHEN "1011" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(200,10);
				IF(pixel_row >= 200 AND pixel_row <= 270) THEN
					pipe_display <= '0';
				END IF;
			WHEN "1100" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(270,10);
				IF(pixel_row >= 270 AND pixel_row <= 340) THEN
					pipe_display <= '0';
				END IF;
			WHEN "1101" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(340,10);
				IF(pixel_row >= 340 AND pixel_row <= 410) THEN
					pipe_display <= '0';
				END IF;
			WHEN "1110" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(190,10);
				IF(pixel_row >= 190 AND pixel_row <= 260) THEN
					pipe_display <= '0';
				END IF;
			WHEN "1111" =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(220,10);
				IF(pixel_row >= 220 AND pixel_row <= 290) THEN
					pipe_display <= '0';
				END IF;
			WHEN others =>
				pipe_gap <= CONV_STD_LOGIC_VECTOR(220,10);
				IF(pixel_row >= 220 AND pixel_row <= 290) THEN
					pipe_display <= '0';
				END IF;
		END CASE;
	end process pipe_gap_pos;
	
--	lsfr_gen : process(vert_sync, reset)
--	begin
----		if rising_edge(vert_sync) then
--			if reset = '1' then
--				rand_num <= lsfr_num;
--			end if;
----		end if;
--	end process lsfr_gen;
	
end architecture behaviour;