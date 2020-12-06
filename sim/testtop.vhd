----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/30 23:39:09
-- Design Name: 
-- Module Name: testtop - Behavioral
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

entity testtop is
--  Port ( );
end testtop;

architecture Behavioral of testtop is
component top
    Generic (r : integer := 10;
             n : integer := 4);
    Port ( key : in STD_LOGIC_VECTOR (32*n-1 downto 0);
           mode : in STD_LOGIC;
           clk : in STD_LOGIC;
           text_in : in STD_LOGIC_VECTOR (127 downto 0);
           text_out : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    signal test_key, test_text, test_out : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
    signal m : STD_LOGIC := '0';
    signal clk_sig : STD_LOGIC := '0';
begin
    uut : top generic map(r => 10, n => 4) port map (key => test_key, mode => m, clk => clk_sig, text_in => test_text, text_out => test_out);
    
    clock_generate: process
    begin
        wait for 5 ns;
        clk_sig <= not clk_sig;
    end process clock_generate;
    
test : process
    begin
        test_key <= "01110101010001100010000001100111011011100111010101001011001000000111100101101101001000000111001101110100011000010110100001010100";
        test_text <= "00111010110101110000001000011010101100111001100100100010010000001111011000100000000101000101011101011111010100001100001100101001";
        wait for 20 ns;
        test_text <= "00000010110101110000001000011010101100111001100100100010010000001111011000100000000101000101011101011111010100001100001100101001";
        wait;
    end process;
end Behavioral;
