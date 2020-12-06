----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/29 21:23:08
-- Design Name: 
-- Module Name: testadd - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testadd is
--  Port ( );
end testadd;

architecture Behavioral of testadd is
    component AddRoundKey Port 
         ( state_in : in STD_LOGIC_VECTOR (127 downto 0);
           key : in STD_LOGIC_VECTOR (127 downto 0);
           state_out : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    signal test_in, test_out, k : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
begin
    uut1 : AddRoundKey port map (state_in => test_in, state_out => test_out, key => k);
    
test : process
    begin
        test_in <= "11001101100101110100011101100101100010001011111001110001100010011100001001001011010011011100111010011101011111111100100100010101";
        k <= "11111010111101110011101010100000011010010101010101000011011101101000111110110001000110101100011100000111001000000000100001010110";
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
