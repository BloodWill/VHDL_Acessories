library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;

entity asynchronous_fifo is
  generic(DATA_WIDTH : natural := 8;
  DATA_DEPTH : natural := 1024);
    port (
    clock_w : in std_logic;
    reset_w : in std_logic;
    data_w  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    write_en : in std_logic;

    clock_r : in std_logic;
    reset_r : in std_logic;
    data_r  : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    read_en : in std_logic;
    full    : out std_logic;
    empty   : out std_logic
  ) ;
end asynchronous_fifo ;

architecture arch of asynchronous_fifo is
component fifo_ram is
generic(
DATA_DEPTH : natural := 1024;
DATA_WIDTH : natural := 8
);
port(
clock_r:in std_logic;
data_r:out std_logic_vector(DATA_WIDTH - 1 downto 0);
read_en:in std_logic;
addr_r : in std_logic_vector (integer(ceil(log2(real(DATA_DEPTH)))) - 1 downto 0);
write_en:in std_logic;
data_w : in std_logic_vector(DATA_WIDTH - 1 downto 0); 
addr_w : in std_logic_vector(integer(ceil(log2(real(DATA_DEPTH)))) - 1 downto 0);
clock_w:in std_logic
) ;
end component;


    component synchronizer is
        generic (DATA_SIZE : integer := 8;
        SYNC_STAGE : integer := 2);  -- SYNC_STAGE must equal or larger than 2
      port (
        clock: in std_logic;
        reset: in std_logic;
        data_in : in std_logic_vector (DATA_SIZE - 1 downto 0);
        data_out : out std_logic_vector( DATA_SIZE - 1 downto 0)
      ) ;
    end component ;

constant i : integer :=  11;

signal w_index, r_index : std_logic_vector(10 downto 0);
signal w_index_gray, tmp_w_to_r_index_binary, w_to_r_index_gray, r_index_gray, r_to_w_index_gray, w_to_r_index_binary, tmp_r_to_w_index_binary, r_to_w_index_binary  : std_logic_vector(10 downto 0);



begin

write_control : process(clock_w) begin
if(rising_edge(clock_w)) then
    if reset_w = '1' then
        w_index <= (others => '0');
    else
        if(write_en = '1') then
        w_index <= std_logic_vector(unsigned(w_index) + "1"); 
        end if;
    end if;
end if;
end process;

read_control : process(clock_r) begin
if(rising_edge(clock_r)) then
    if reset_r = '1' then
        r_index <= (others => '0');
    else
        if(read_en = '1' and full = '0' ) then
            r_index <= std_logic_vector(unsigned(r_index) + "1");  
        end if;
    end if;
end if;
end process;
--------------------------------------------------------empty check---------------------------------
binary_to_gray_w_to_r : process (clock_w) begin
if(rising_edge(clock_w)) then
    if(reset_w = '1') then
        w_index_gray <= (others => '0');
    else
    if(write_en = '1' and full = '0' ) then
        w_index_gray <= w_index xor ('0' & w_index(i-1 downto 1));
    end if;
    end if;
end if;
end process;

sync_w_to_r: synchronizer 
    generic map(DATA_SIZE => 11,
    SYNC_STAGE => 2)  -- SYNC_STAGE must equal or larger than 2
  port map(
    clock => clock_r, --: in std_logic;
    reset => reset_r, --: in std_logic;
    data_in => w_index_gray, --: in std_logic_vector (DATA_SIZE - 1 downto 0);
    data_out => w_to_r_index_gray --: out std_logic_vector( DATA_SIZE - 1 downto 0)
  ) ;

tmp_w_to_r_index_binary(i-1) <= w_to_r_index_gray(i-1) ;
gray_to_binary_w_to_r : 
    for x in 0 to i-2 generate
    tmp_w_to_r_index_binary(x) <= tmp_w_to_r_index_binary(x+1) xor w_to_r_index_gray(x);
end generate;
w_to_r_index_binary <= tmp_w_to_r_index_binary;

empty_gen : 
process(clock_r) begin
if w_to_r_index_binary(i-2 downto 0) = r_index then
    empty <= '1';
else
    empty <= '0';
end if;
end process;

---------------------------------------------------------------------------------------
---------------------------------------full check------------------------------------------------
binary_to_gary_r_to_w : process (clock_w) begin
    if(rising_edge(clock_r)) then
        if(reset_r = '1') then
            r_index_gray <= (others => '0');  
        else
        if(read_en = '1') then
            r_index_gray <= r_index xor ('0' & r_index(i - 1 downto 1));
        end if;
        end if;
    end if;
end process;

sync_r_to_w: synchronizer 
    generic map(DATA_SIZE => 11,
    SYNC_STAGE => 2)  -- SYNC_STAGE must equal or larger than 2
    port map(
    clock => clock_w, --: in std_logic;
    reset => reset_w, --: in std_logic;
    data_in => r_index_gray, --: in std_logic_vector (DATA_SIZE - 1 downto 0);
    data_out => r_to_w_index_gray --: out std_logic_vector( DATA_SIZE - 1 downto 0)
  ) ;

tmp_r_to_w_index_binary(i-1) <= r_to_w_index_gray(i-1) ;
gary_to_binary_w_to_r : 
      for x in 0 to i-2 generate
      tmp_r_to_w_index_binary(x) <= tmp_r_to_w_index_binary(x+1) xor r_to_w_index_gray(x);
end generate;
r_to_w_index_binary <= tmp_r_to_w_index_binary;

full_gen : 
process(clock_r) begin
if ((r_to_w_index_binary(i-1) = not w_index (i - 1)) and (r_to_w_index_binary(i-2 downto 0) = w_index(i-2 downto 0))) then
    full <= '1';
else 
    full <= '0';
end if;
end process;

---------------------------------------------------------------------------------------

ram: fifo_ram 
    generic map(
        DATA_DEPTH => 1024,
        DATA_WIDTH => 8
    )
      port map(
        clock_r => clock_r, --   : in std_logic;
        data_r  => data_r, --: out std_logic_vector(DATA_WIDTH - 1 : 0);
        read_en => read_en, -- : in std_logic;
        addr_r  => r_index(i-2 downto 0), -- : in std_logic_vector(ceil(log2(real(DATA_DEPTH))) - 1 : 0);
    
        write_en => write_en, --: in std_logic;
        data_w => data_w, --: in std_logic_vector(DATA_WIDTH - 1 : 0); 
        addr_w  => w_index(i-2 downto 0), --: in std_logic_vector(ceil(log2(real(DATA_DEPTH))) - 1 : 0);
        clock_w => clock_w --: in std_logic
      ) ;








end architecture ; -- arch