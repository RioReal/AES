----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/28 23:29:37
-- Design Name: 
-- Module Name: coefmult - Behavioral
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

entity coefmult is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           c : out STD_LOGIC_VECTOR (31 downto 0));
end coefmult;

architecture Behavioral of coefmult is
    component gmult Port 
         ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           c : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal d0, d1, d2, d3 : STD_LOGIC_VECTOR(31 downto 0);

begin
    L1 : for i in 0 to 3 generate
        mul : gmult port map(a => a(8*i+7 downto 8*i), b => b(7 downto 0), c => d0(8*i+7 downto 8*i));
	end generate;
	
	L2 : for i in 0 to 3 generate
        mul : gmult port map(a => a(8*i+7 downto 8*i), b => b(15 downto 8), c => d1(8*i+7 downto 8*i));
	end generate;
	
	L3 : for i in 0 to 3 generate
        mul : gmult port map(a => a(8*i+7 downto 8*i), b => b(23 downto 16), c => d2(8*i+7 downto 8*i));
	end generate;
	
	L4 : for i in 0 to 3 generate
        mul : gmult port map(a => a(8*i+7 downto 8*i), b => b(31 downto 24), c => d3(8*i+7 downto 8*i));
	end generate;
	
process(d0, d1, d2, d3)
    begin
        c(7 downto 0) <= d0(7 downto 0) xor d1(31 downto 24) xor d2(23 downto 16) xor d3(15 downto 8);
        c(15 downto 8) <= d0(15 downto 8) xor d1(7 downto 0) xor d2(31 downto 24) xor d3(23 downto 16);
        c(23 downto 16) <= d0(23 downto 16) xor d1(15 downto 8) xor d2(7 downto 0) xor d3(31 downto 24);
        c(31 downto 24) <= d0(31 downto 24) xor d1(23 downto 16) xor d2(15 downto 8) xor d3(7 downto 0);
    end process;
end Behavioral;
