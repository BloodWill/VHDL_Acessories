library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity synchronizer_tb is
end synchronizer_tb ;

architecture arch of synchronizer_tb is

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

   constant DATA_SIZE : integer := 8;
   constant SYNC_STAGE: integer := 3; 

signal clk_50Mhz, reset : std_logic;
signal data_in, data_out: std_logic_vector(DATA_SIZE -1 downto 0);

begin



uut: synchronizer
    generic map (DATA_SIZE => DATA_SIZE,
    SYNC_STAGE => SYNC_STAGE)  -- SYNC_STAGE must equal or larger than 2
  port map(
    clock => clk_50Mhz, --: in std_logic;
    reset => reset, --: in std_logic;
    data_in => data_in, --: in std_logic_vector (DATA_SIZE - 1 downto 0);
    data_out => data_out --: out std_logic_vector( DATA_SIZE - 1 downto 0);
  ) ;
   
clk: process begin
    clk_50Mhz <= '0' ;
    wait for 10 ns;
    clk_50Mhz <= '1';
    wait for 10 ns;

end process;

data: process begin
data_in <= x"DE";
wait until rising_edge(clk_50Mhz);
data_in <= x"AB";
wait until rising_edge(clk_50Mhz);
data_in <= x"CC";
wait until rising_edge(clk_50Mhz);
data_in <= x"FF";
end process;

tb1: process 
begin
reset <= '1';
wait until rising_edge(clk_50Mhz);
reset <= '0';
wait until rising_edge(clk_50Mhz);

wait for 5 us;
reset <= '1';




end process;    





end architecture ; -- arch