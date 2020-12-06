----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/30 17:42:45
-- Design Name: 
-- Module Name: testkexp - Behavioral
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

entity testkexp is
--  Port ( );
end testkexp;

architecture Behavioral of testkexp is
    component KeyExpansion 
        Generic (r : integer := 10;
                 n : integer := 4);
        Port ( key_in : in STD_LOGIC_VECTOR (32*n-1 downto 0);
               key_out : out STD_LOGIC_VECTOR (128*(r+1)-1 downto 0));
    end component;
    
    signal k0 : std_logic_vector (127 downto 0);
    signal k0_out : std_logic_vector (1407 downto 0);
    signal k1 : std_logic_vector (191 downto 0);
    signal k1_out : std_logic_vector (128*13-1 downto 0);
    signal k2 : std_logic_vector (254 downto 0);

begin
uut1 : KeyExpansion generic map(r => 10, n => 4) port map (key_in => k0 , key_out =>k0_out);
uut2 : KeyExpansion generic map(r => 12, n => 6) port map (key_in => k1 , key_out =>k1_out);
process
    begin
        k0 <= "01110101010001100010000001100111011011100111010101001011001000000111100101101101001000000111001101110100011000010110100001010100";
        k1 <= "001100011000011000100011100010110001011110101010011011111111010000100010110110110010101100111010000110111001000010000001011010000111010111010100000000111111111001011101100111001110001100110001";
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
