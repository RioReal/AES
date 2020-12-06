----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/28 12:50:41
-- Design Name: 
-- Module Name: testsub - Behavioral
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

entity testsub is
--  Port ( );
end testsub;

architecture Behavioral of testsub is
    component SubBytes Port (
        state_in : in STD_LOGIC_VECTOR (127 downto 0);
        mode : in STD_LOGIC;
        state_out : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    signal test_in, test_out : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
    signal m : STD_LOGIC := '0';
begin
    uut1 : SubBytes port map (state_in => test_in, state_out => test_out, mode => m);
    
test : process
    begin
        test_in <= "01011000010001110000100010001011000101011011011000011100101110100101100111010100111000101110100011001101001110011101111111001110";
        wait for 10 ns;
        m <= '1';
        test_in <= "01101010101000000011000000111101010110010100111010011100111101001100101101001000100110001001101110111101000100101001111010001011";
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
