----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/27 22:19:08
-- Design Name: 
-- Module Name: AddRoundKey - Behavioral
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

entity AddRoundKey is
    Port ( state_in : in STD_LOGIC_VECTOR (127 downto 0);
           key : in STD_LOGIC_VECTOR (127 downto 0);
           clk : in STD_LOGIC;
           state_out : out STD_LOGIC_VECTOR (127 downto 0));
end AddRoundKey;

architecture Behavioral of AddRoundKey is
    signal state : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
    
begin
-- addroundkey is in all rounds, so set a register here can be viewed as a register for each round
-- the pipeline will be implemented easily inside it rather than in higher level entities
reg : process(clk)
    begin
        if rising_edge (clk) then
            state_out <= state;
        end if;
    end process;

-- xor key and state in proper order
process(state_in, key)
    begin
        for i in 0 to 3 loop
            state(8*i+7 downto 8*i) <= state_in(8*i+7 downto 8*i) xor key((4*i)*8+7 downto 4*i*8);
            state(8*(4+i)+7 downto 8*(4+i)) <= state_in(8*(4+i)+7 downto 8*(4+i)) xor key((4*i+1)*8+7 downto (4*i+1)*8);
            state(8*(8+i)+7 downto 8*(8+i)) <= state_in(8*(8+i)+7 downto 8*(8+i)) xor key((4*i+2)*8+7 downto (4*i+2)*8);
            state(8*(12+i)+7 downto 8*(12+i)) <= state_in(8*(12+i)+7 downto 8*(12+i)) xor key((4*i+3)*8+7 downto (4*i+3)*8);
        end loop;
    end process;
end Behavioral;
