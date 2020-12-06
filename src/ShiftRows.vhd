----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/27 22:19:08
-- Design Name: 
-- Module Name: ShiftRows - Behavioral
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

entity ShiftRows is
    Port ( state_in : in STD_LOGIC_VECTOR (127 downto 0);
           mode : in STD_LOGIC := '0';
           state_out : out STD_LOGIC_VECTOR (127 downto 0));
end ShiftRows;

architecture Behavioral of ShiftRows is

begin
-- shift rows in the state
process(state_in, mode)
    variable tmp : STD_LOGIC_VECTOR (7 downto 0);
    variable state : STD_LOGIC_VECTOR (127 downto 0);
    variable s : integer range 0 to 3;
    begin
        state(127 downto 0) := state_in(127 downto 0);
        for i in 1 to 3 loop
            s := 0;
            while (s < i) loop
                if mode = '0' then
                    tmp := state(4*i*8+7 downto 4*i*8);
                    for k in 1 to 3 loop                    
                        state((4*i+k-1)*8+7 downto (4*i+k-1)*8) := state((4*i+k)*8+7 downto (4*i+k)*8);
                    end loop;
                    state((4*i+3)*8+7 downto (4*i+3)*8) := tmp;
                elsif mode = '1' then
                    tmp := state((4*i+3)*8+7 downto (4*i+3)*8);
                    for k in 3 downto 1 loop
                        state((4*i+k)*8+7 downto (4*i+k)*8) := state((4*i+k-1)*8+7 downto (4*i+k-1)*8);           
                    end loop;
                    state(4*i*8+7 downto 4*i*8) := tmp;
                end if;
                s := s + 1;
            end loop;
        end loop;
        state_out <= state;
    end process;
end Behavioral;
