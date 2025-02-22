----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/12/01 20:52:39
-- Design Name: 
-- Module Name: testbench - Behavioral
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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
    Generic(
        NR : integer := 14;
        NK : integer := 8;
        SAMPLE_NUM : integer := 30);
    Port (
        MODE : std_logic := '1');
end testbench;

architecture Behavioral of testbench is
    component top
        Generic (r : integer := 10;
                 n : integer := 4);
         Port ( key : in STD_LOGIC_VECTOR (32*n-1 downto 0);
                mode : in STD_LOGIC;
                clk : in STD_LOGIC;
                text_in : in STD_LOGIC_VECTOR (127 downto 0);
                text_out : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    signal k : STD_LOGIC_VECTOR (32*nk-1 downto 0) := (others => '0');
    signal m : STD_LOGIC := '0';
    signal i : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
    signal o : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
    signal clk_sig: STD_LOGIC := '1';
    signal done_sig : STD_LOGIC := '0';
    signal cnt : integer := 0;
    signal cnt_reg : integer := 0;
    
    type StateType is ARRAY(0 to SAMPLE_NUM-1) of STD_LOGIC_VECTOR(127 downto 0);
    type KeyType is ARRAY(0 to SAMPLE_NUM-1) of STD_LOGIC_VECTOR(32*nk-1 downto 0);
    type ModeType is ARRAY(0 to SAMPLE_NUM-1) of STD_LOGIC;                 
    
    signal InputMode : ModeType := (others => '0');
    signal InputState, OutputState, RefState : StateType := (others => (others => '0'));
    signal InputKey : KeyType := (others => (others => '0'));
    
begin
uut : top Generic map(r => NR, n => NK)
          Port map(key => k, mode => MODE, clk => clk_sig, text_in => i, text_out => o);

reg : process(clk_sig)
    begin
        if rising_edge (clk_sig) then
            cnt <= cnt_reg;
        end if;
    end process;
    
counter : process(cnt, InputState, o)
    begin
        if cnt = SAMPLE_NUM+NR+1 then
            done_sig <= '1';
            cnt_reg <= cnt;
        else
            cnt_reg <= cnt + 1;
            if cnt < SAMPLE_NUM then
                i <= InputState(cnt);
                k <= InputKey(cnt);
            end if;
            if cnt > NR then
                OutputState(cnt-NR-1) <= o;
            end if;
            done_sig <= '0';
        end if;
    end process;
    
clock_generate: process
    begin
        wait for 5 ns;
        clk_sig <= not clk_sig;
    end process clock_generate;
    
read_input: process
        FILE file_in: text;
        variable file_status: file_open_status;
        variable buf: line;
        variable data: STD_LOGIC_VECTOR(256+32*nk downto 0);
    begin
        if nk = 4 then
            file_open(file_status, file_in, "eval/t_128.txt", read_mode);
        elsif nk = 6 then 
            file_open(file_status, file_in, "eval/t_192.txt", read_mode);
        elsif nk = 8 then
            file_open(file_status, file_in, "eval/t_256.txt", read_mode);
        end if;
        for index in 0 to SAMPLE_NUM - 1 loop
            readline(file_in, buf);
            read(buf, data);
            InputMode(index) <= data(0);
            InputState(index) <= data(128 downto 1);
            InputKey(index) <= data(128+32*nk downto 129);
            RefState(index) <= data(256+32*nk downto 129+32*nk);
        end loop;
        wait;
    end process;
 
generate_result: process
        file file_out: TEXT;
        variable file_status: file_open_status;
        variable buf: LINE;
        variable s: character := 'f';
    begin
        if nk = 4 then
            if mode = '0' then
                file_open(file_out, "eval/AES_results_encryption_128.txt", write_mode);
            else
                file_open(file_out, "eval/AES_results_decryption_128.txt", write_mode);
            end if;
        elsif nk = 6 then 
            if mode = '0' then
                file_open(file_out, "eval/AES_results_encryption_192.txt", write_mode);
            else
                file_open(file_out, "eval/AES_results_decryption_192.txt", write_mode);
            end if;
        elsif nk = 8 then
            if mode = '0' then
                file_open(file_out, "eval/AES_results_encryption_256.txt", write_mode);
            else
                file_open(file_out, "eval/AES_results_decryption_256.txt", write_mode);
            end if;
        end if;
        wait until rising_edge(done_sig);
        wait until rising_edge(clk_sig);
        for index in 0 to SAMPLE_NUM - 1 loop
            if MODE = InputMode(index) then
                if OutputState(index) = RefState(index) then 
                    s := 'P';
                else
                    s := 'F';
                end if;
            else
                s := 'N';
            end if;
            write(buf, s);
            writeline(file_out,buf);
        end loop; 
        file_close(file_out);
        std.env.finish;
    end process;
end Behavioral;
