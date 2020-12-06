----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/28 13:58:30
-- Design Name: 
-- Module Name: testshift - Behavioral
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

entity testshift is
--  Port ( );
end testshift;

architecture Behavioral of testshift is
    component ShiftRows Port (
        state_in : in STD_LOGIC_VECTOR (127 downto 0);
        mode : in STD_LOGIC;
        state_out : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    signal test_in, test_out : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
    signal m : STD_LOGIC := '0';
begin
    uut1 : ShiftRows port map (state_in => test_in, state_out => test_out, mode => m);
    
test : process
    begin
        test_in <= "10001011100110111111010000111101100111101001100010011100001100000001001001001000010011101010000010111101110010110101100101101010";
        wait for 10 ns;
        m <= '1';
        test_in <= "10011011111101000011110110001011100111000011000010011110100110001010000000010010010010000100111010111101110010110101100101101010";
        wait for 10 ns;
        wait;
    end process;
end Behavioral;