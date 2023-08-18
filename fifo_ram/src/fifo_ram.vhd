library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use ieee.std_logic_unsigned.all;

entity fifo_ram is
generic (
    DATA_DEPTH : integer := 1024;
    DATA_WIDTH : natural := 8
);
  port (
    clock_r    : in std_logic;
    data_r : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    read_en  : in std_logic;
    addr_r   : in std_logic_vector(integer(ceil(log2(real(DATA_DEPTH))) - real(1)) downto 0);

    write_en : in std_logic;
    data_w : in std_logic_vector(DATA_WIDTH - 1 downto 0); 
    addr_w : in std_logic_vector(integer(ceil(log2(real(DATA_DEPTH)))) - 1 downto 0);
    clock_w: in std_logic
  ) ;
end fifo_ram ;

architecture arch of fifo_ram is

type fifo_mem is array (0 to DATA_DEPTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);

signal fifo : fifo_mem;

begin

process(clock_r) begin
    if(rising_edge(clock_r)) then

            if (read_en = '1') then
            --addr_r <= std_logic_vector(unsigned(addr_r) + "1" );
            data_r <= fifo(to_integer(unsigned(addr_r)));
            end if;
    end if;
end process;

process(clock_w) begin
    if(rising_edge(clock_w)) then
        if (write_en = '1') then

            --addr_w <= std_logic_vector(unsigned(addr_w) + "1" );
            fifo(to_integer(unsigned(addr_w))) <= data_w;       
        end if;
    end if;
end process;


end architecture ; -- arch