----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/27 22:19:08
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Generic (r : integer := 10;
             n : integer := 4);
    Port ( key : in STD_LOGIC_VECTOR (32*n-1 downto 0);
           mode : in STD_LOGIC := '0';
           clk : in STD_LOGIC;
           text_in : in STD_LOGIC_VECTOR (127 downto 0);
           text_out : out STD_LOGIC_VECTOR (127 downto 0));
end top;

architecture Behavioral of top is
component encryption
    Generic (r : integer := 10;
             n : integer := 4);
    Port ( key : in STD_LOGIC_VECTOR (32*n-1 downto 0);
           text_in : in STD_LOGIC_VECTOR (127 downto 0);
           text_out : out STD_LOGIC_VECTOR (127 downto 0);
           clk : in STD_LOGIC);
end component;

component decryption
    Generic (r : integer := 10;
             n : integer := 4);
    Port ( key : in STD_LOGIC_VECTOR (32*n-1 downto 0);
           text_in : in STD_LOGIC_VECTOR (127 downto 0);
           text_out : out STD_LOGIC_VECTOR (127 downto 0);
           clk : in STD_LOGIC);
end component;
    
    signal text_out_e, text_out_d : std_logic_vector(127 downto 0);
    
begin

e : encryption Generic map(r => r, n => n)
               Port map(key => key, clk => clk, text_in => text_in, text_out => text_out_e);
               
d : decryption Generic map(r => r, n => n)
               Port map(key => key, clk => clk, text_in => text_in, text_out => text_out_d);

-- top is a mux: outputs depend on the mode
process(mode, text_out_e, text_out_d)
    begin
        if mode = '0' then
            text_out <= text_out_e;
        else
            text_out <= text_out_d;
        end if;
    end process;
end Behavioral;
