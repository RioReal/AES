----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/28 19:43:07
-- Design Name: 
-- Module Name: gmult - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gmult is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           c : out STD_LOGIC_VECTOR (7 downto 0));
end gmult;

architecture Behavioral of gmult is

begin
process(a,b)
    variable p, hbs, a_t, b_t : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    begin
        p := (others => '0');
        a_t := a;
        b_t := b;
        for i in 0 to 7 loop
            if (b_t(0) = '1') then
                p := a_t xor p;
            end if;
            
            hbs := a_t and std_logic_vector(to_unsigned(16#80#, 8));
            a_t :=  std_logic_vector(shift_left(unsigned(a_t), 1));
            if unsigned(hbs) > 0 then
                a_t := a_t xor std_logic_vector(to_unsigned(16#1b#, 8));
            end if;
            b_t :=  std_logic_vector(shift_right(unsigned(b_t), 1));
            
        end loop;
        c <= p;
end process;
end Behavioral;
