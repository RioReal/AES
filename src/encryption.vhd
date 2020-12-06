----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/12/04 11:12:19
-- Design Name: 
-- Module Name: encryption - Behavioral
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

entity encryption is
    Generic (r : integer := 10;
             n : integer := 4);
    Port ( key : in STD_LOGIC_VECTOR (32*n-1 downto 0);
           text_in : in STD_LOGIC_VECTOR (127 downto 0);
           text_out : out STD_LOGIC_VECTOR (127 downto 0);
           clk : in STD_LOGIC);
end encryption;

architecture Behavioral of encryption is
    component KeyExpansion 
        Generic (r : integer := 10;
                 n : integer := 4);
        Port ( key_in : in STD_LOGIC_VECTOR (32*n-1 downto 0);
               key_out : out STD_LOGIC_VECTOR (128*(r+1)-1 downto 0));
    end component;
    
    component AddRoundKey Port 
         ( state_in : in STD_LOGIC_VECTOR (127 downto 0);
           key : in STD_LOGIC_VECTOR (127 downto 0);
           clk : in STD_LOGIC;
           state_out : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    component SubBytes Port (
        state_in : in STD_LOGIC_VECTOR (127 downto 0);
        mode : in STD_LOGIC;
        state_out : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    component ShiftRows Port (
        state_in : in STD_LOGIC_VECTOR (127 downto 0);
        mode : in STD_LOGIC;
        state_out : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    component MixColumns Port (
        state_in : in STD_LOGIC_VECTOR (127 downto 0);
        mode : in STD_LOGIC;
        state_out : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    signal w : std_logic_vector(128*(r+1)-1 downto 0) := (others => '0');
    signal state0 : std_logic_vector(127 downto 0) := (others => '0');
    
    type net is ARRAY (0 to 4*r-1) of std_logic_vector (127 downto 0);
    signal state_net : net := (others => (others => '0'));
    
    type keynet is ARRAY(0 to r) of std_logic_vector (128*(r+1)-1 downto 0);
    signal key_net : keynet := (others => (others => '0'));
    
begin
-- connect all the components in order
-- number of rounds depends on the key length
key_expansion : KeyExpansion Generic map (r => r, n => n) port map (key_in => key, key_out => w);

init_round : AddRoundKey port map (state_in => state0, state_out => state_net(0), clk=>clk, key => w(127 downto 0));

rounds : for i in 1 to r-1 generate
    sub : SubBytes port map (state_in => state_net(4*i-4), state_out => state_net(4*i-3), mode => '0');
    sft : ShiftRows port map (state_in => state_net(4*i-3), state_out => state_net(4*i-2), mode => '0');
    mix : MixColumns port map (state_in => state_net(4*i-2), state_out => state_net(4*i-1), mode => '0');
    add : AddRoundKey port map (state_in => state_net(4*i-1), state_out => state_net(4*i), clk=>clk, key => key_net(i-1)(128*(i+1)-1 downto 128*i));
end generate; 

final_roundsub : SubBytes port map (state_in => state_net(4*r-4), state_out => state_net(4*r-3), mode => '0');
final_roundshift : ShiftRows port map (state_in => state_net(4*r-3), state_out => state_net(4*r-2), mode => '0');
final_roundadd : AddRoundKey port map (state_in => state_net(4*r-2), state_out => state_net(4*r-1), clk=>clk, key => key_net(r-1)(128*(r+1)-1 downto 128*r));

-- registers for expanded keys
reg : process(clk)
    begin
        if rising_edge(clk) then
            key_net(0) <= w;
            for i in 0 to r-1 loop
                key_net(i+1) <= key_net(i);
            end loop;
        end if;    
    end process;    

-- number order of the state should follow the AES rules
process(text_in, state_net)
    begin
        for i in 0 to 3 loop
            for j in 0 to 3 loop 
                state0(8*(4*i+j)+7 downto 8*(4*i+j)) <= text_in(8*(4*j+i)+7 downto 8*(4*j+i));
                text_out(8*(4*j+i)+7 downto 8*(4*j+i)) <= state_net(4*r-1)(8*(4*i+j)+7 downto 8*(4*i+j)); 
            end loop;
        end loop;
    end process;
end Behavioral;
