library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity asynchronous_fifo_tb is

end asynchronous_fifo_tb ;

architecture arch of asynchronous_fifo_tb is

    component asynchronous_fifo is
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
      end component;



begin

    clk: process begin
        clk_50Mhz <= '0' ;
        wait for 10 ns;
        clk_50Mhz <= '1';
        wait for 10 ns;
    
    end proces

    uut: asynchronous_fifo 
    generic map(DATA_WIDTH => 8,
    DATA_PATH => 1024)
    port map (
        clock_w => clk_50Mhz,
        reset_w => reset_w, --: in std_logic;
        data_w  => data_w, --: in std_logic_vector(DATA_WIDTH - 1 downto 0);
        write_en  => write_en, --: in std_logic;
    
        clock_r => clock_r, --: in std_logic;
        reset_r => reset_r, --: in std_logic;
        data_r  => data_r, --: out std_logic_vector(DATA_WIDTH - 1 downto 0);
        read_en => read_en, --: in std_logic;
        full    => full,    --: out std_logic;
        empty   => empty,   --: out std_logic

    );







end architecture ; -- arch