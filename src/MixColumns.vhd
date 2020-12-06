----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/27 22:19:08
-- Design Name: 
-- Module Name: MixColumns - Behavioral
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

entity MixColumns is
    Port ( state_in : in STD_LOGIC_VECTOR (127 downto 0);
           mode : in STD_LOGIC := '0';
           state_out : out STD_LOGIC_VECTOR (127 downto 0));
end MixColumns;

architecture Behavioral of MixColumns is
    component coefmult Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           c : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    signal col0, col1, col2, col3 : STD_LOGIC_VECTOR (31 downto 0);
    signal res0, res1, res2, res3 : STD_LOGIC_VECTOR (31 downto 0);
    signal a : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
    constant coe : STD_LOGIC_VECTOR (31 downto 0) := "00000011000000010000000100000010";
    constant inv_coe : STD_LOGIC_VECTOR (31 downto 0) := "00001011000011010000100100001110";

begin

COE_MULT1 : coefmult Port map (a => a, b => col0, c => res0);
COE_MULT2 : coefmult Port map (a => a, b => col1, c => res1);
COE_MULT3 : coefmult Port map (a => a, b => col2, c => res2);
COE_MULT4 : coefmult Port map (a => a, b => col3, c => res3);

-- mix each column
process(state_in, mode, res0, res1, res2, res3)
    begin
        for i in 0 to 3 loop
            col0(8 * i + 7 downto 8 * i) <= state_in(32 * i + 7 downto 32 * i);
            col1(8 * i + 7 downto 8 * i) <= state_in(32 * i + 15 downto 32 * i + 8);
            col2(8 * i + 7 downto 8 * i) <= state_in(32 * i + 23 downto 32 * i + 16);
            col3(8 * i + 7 downto 8 * i) <= state_in(32 * i + 31 downto 32 * i + 24);
            
            state_out(32 * i + 7 downto 32 * i) <=	res0(8 * i + 7 downto 8 * i);
            state_out(32 * i + 15 downto 32 * i + 8) <=	res1(8 * i + 7 downto 8 * i);
            state_out(32 * i + 23 downto 32 * i + 16) <= res2(8 * i + 7 downto 8 * i);
            state_out(32 * i + 31 downto 32 * i + 24) <= res3(8 * i + 7 downto 8 * i);
        end loop;
        if mode = '0' then
            a <= coe;
        elsif mode = '1' then
            a <= inv_coe;
        end if;
    end process;
end Behavioral;
