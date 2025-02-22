----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/27 22:19:08
-- Design Name: 
-- Module Name: KeyExpansion - Behavioral
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

entity KeyExpansion is
    Generic (r : integer := 10;
             n : integer := 4);
    Port ( key_in : in STD_LOGIC_VECTOR (32*n-1 downto 0);
           key_out : out STD_LOGIC_VECTOR (128*(r+1)-1 downto 0) := (others => '0'));
end KeyExpansion;

architecture Behavioral of KeyExpansion is
    TYPE box IS ARRAY(0 to 15, 0 to 15) of integer;
    CONSTANT s_box : box :=(
            (16#63#, 16#7c#, 16#77#, 16#7b#, 16#f2#, 16#6b#, 16#6f#, 16#c5#, 16#30#, 16#01#, 16#67#, 16#2b#, 16#fe#, 16#d7#, 16#ab#, 16#76#), 
            (16#ca#, 16#82#, 16#c9#, 16#7d#, 16#fa#, 16#59#, 16#47#, 16#f0#, 16#ad#, 16#d4#, 16#a2#, 16#af#, 16#9c#, 16#a4#, 16#72#, 16#c0#), 
            (16#b7#, 16#fd#, 16#93#, 16#26#, 16#36#, 16#3f#, 16#f7#, 16#cc#, 16#34#, 16#a5#, 16#e5#, 16#f1#, 16#71#, 16#d8#, 16#31#, 16#15#), 
            (16#04#, 16#c7#, 16#23#, 16#c3#, 16#18#, 16#96#, 16#05#, 16#9a#, 16#07#, 16#12#, 16#80#, 16#e2#, 16#eb#, 16#27#, 16#b2#, 16#75#), 
            (16#09#, 16#83#, 16#2c#, 16#1a#, 16#1b#, 16#6e#, 16#5a#, 16#a0#, 16#52#, 16#3b#, 16#d6#, 16#b3#, 16#29#, 16#e3#, 16#2f#, 16#84#), 
            (16#53#, 16#d1#, 16#00#, 16#ed#, 16#20#, 16#fc#, 16#b1#, 16#5b#, 16#6a#, 16#cb#, 16#be#, 16#39#, 16#4a#, 16#4c#, 16#58#, 16#cf#), 
            (16#d0#, 16#ef#, 16#aa#, 16#fb#, 16#43#, 16#4d#, 16#33#, 16#85#, 16#45#, 16#f9#, 16#02#, 16#7f#, 16#50#, 16#3c#, 16#9f#, 16#a8#), 
            (16#51#, 16#a3#, 16#40#, 16#8f#, 16#92#, 16#9d#, 16#38#, 16#f5#, 16#bc#, 16#b6#, 16#da#, 16#21#, 16#10#, 16#ff#, 16#f3#, 16#d2#), 
            (16#cd#, 16#0c#, 16#13#, 16#ec#, 16#5f#, 16#97#, 16#44#, 16#17#, 16#c4#, 16#a7#, 16#7e#, 16#3d#, 16#64#, 16#5d#, 16#19#, 16#73#), 
            (16#60#, 16#81#, 16#4f#, 16#dc#, 16#22#, 16#2a#, 16#90#, 16#88#, 16#46#, 16#ee#, 16#b8#, 16#14#, 16#de#, 16#5e#, 16#0b#, 16#db#), 
            (16#e0#, 16#32#, 16#3a#, 16#0a#, 16#49#, 16#06#, 16#24#, 16#5c#, 16#c2#, 16#d3#, 16#ac#, 16#62#, 16#91#, 16#95#, 16#e4#, 16#79#), 
            (16#e7#, 16#c8#, 16#37#, 16#6d#, 16#8d#, 16#d5#, 16#4e#, 16#a9#, 16#6c#, 16#56#, 16#f4#, 16#ea#, 16#65#, 16#7a#, 16#ae#, 16#08#), 
            (16#ba#, 16#78#, 16#25#, 16#2e#, 16#1c#, 16#a6#, 16#b4#, 16#c6#, 16#e8#, 16#dd#, 16#74#, 16#1f#, 16#4b#, 16#bd#, 16#8b#, 16#8a#), 
            (16#70#, 16#3e#, 16#b5#, 16#66#, 16#48#, 16#03#, 16#f6#, 16#0e#, 16#61#, 16#35#, 16#57#, 16#b9#, 16#86#, 16#c1#, 16#1d#, 16#9e#), 
            (16#e1#, 16#f8#, 16#98#, 16#11#, 16#69#, 16#d9#, 16#8e#, 16#94#, 16#9b#, 16#1e#, 16#87#, 16#e9#, 16#ce#, 16#55#, 16#28#, 16#df#), 
            (16#8c#, 16#a1#, 16#89#, 16#0d#, 16#bf#, 16#e6#, 16#42#, 16#68#, 16#41#, 16#99#, 16#2d#, 16#0f#, 16#b0#, 16#54#, 16#bb#, 16#16#));
    
    -- since the key length is at least 128-bit, we can just enumerate all Rcon(i) rather than repeated computation
    TYPE list is ARRAY(1 to 10) of integer;
    CONSTANT Rcon : list := (16#01#, 16#02#, 16#04#, 16#08#, 16#10#, 16#20#, 16#40#, 16#80#, 16#1b#, 16#36#);
    
begin

process(key_in)
    variable w : STD_LOGIC_VECTOR (128*(r+1)-1 downto 0);
    variable tmp : STD_LOGIC_VECTOR (31 downto 0);
    variable rot_tmp : STD_LOGIC_VECTOR (7 downto 0);
    variable x, y : integer;
    variable cnt : integer range 0 to 11 := 0;
    begin
        cnt := 1;
        w(32*n-1 downto 0) := key_in(32*n-1 downto 0);
        for i in n to 4*(r+1)-1 loop
            tmp := w((4*(i-1)+3)*8+7 downto 4*(i-1)*8);
            if (i mod n = 0) then
                --rot word
                rot_tmp := tmp(7 downto 0);
                tmp(23 downto 0) := tmp(31 downto 8);
                tmp(31 downto 24) := rot_tmp;
                --sub word
                for j in 0 to 3 loop
                    x := to_integer(unsigned(tmp(8*j+7 downto 8*j+4)));
                    y := to_integer(unsigned(tmp(8*j+3 downto 8*j)));
                    tmp(8*j+7 downto 8*j) := std_logic_vector(to_unsigned(s_box(x,y),8));
                end loop;
                --coef add
                tmp(7 downto 0) := tmp(7 downto 0) xor std_logic_vector(TO_UNSIGNED(Rcon(cnt),8));
                tmp(31 downto 8) := tmp(31 downto 8) xor "000000000000000000000000";
                cnt := cnt + 1;
            elsif (n > 6 and i mod n = 4) then
                --sub word
                for j in 0 to 3 loop
                    x := to_integer(unsigned(tmp(8*j+7 downto 8*j+4)));
                    y := to_integer(unsigned(tmp(8*j+3 downto 8*j)));
                    tmp(8*j+7 downto 8*j) := std_logic_vector(to_unsigned(s_box(x,y),8));
                end loop;
            end if;
            w((4*i+3)*8+7 downto 4*i*8) := w((4*(i-n)+3)*8+7 downto 4*(i-n)*8) xor tmp;
        end loop;
        key_out <= w;
    end process;
end Behavioral;
