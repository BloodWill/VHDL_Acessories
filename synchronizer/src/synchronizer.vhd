library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity synchronizer is
    generic (DATA_SIZE : integer := 8;
    SYNC_STAGE : integer := 2);  -- SYNC_STAGE must equal or larger than 2
  port (
    clock: in std_logic;
    reset: in std_logic;
    data_in : in std_logic_vector (DATA_SIZE - 1 downto 0);
    data_out : out std_logic_vector( DATA_SIZE - 1 downto 0)
  ) ;
end synchronizer ;

architecture arch of synchronizer is

type int_con is array (1 to SYNC_STAGE) of std_logic_vector( DATA_SIZE-1 downto 0);

signal data_int : int_con;

begin

stage: for i in 1 to SYNC_STAGE - 1 generate

    process(clock) begin
        if (rising_edge(clock)) then
            if(reset = '1') then
                data_int(i+1) <= (others => '0');
              -- data_out <= (others => '0');
            else 
--                data_int(1) <= data_in;
                --data_out <= data_int(SYNC_STAGE); 
--                data_out <= data_int(2);
--                data_int(2) <= data_int(1);
--                data_int(3) <= data_int(2);
                
                    data_int(i+1) <= data_int(i);
                
            end if;
               end if;
    end process;
  end generate;


 process(clock) begin
 
 if rising_edge(clock) then
 if (reset = '1') then
 data_out <= (others => '0');
 else
 data_out <= data_int(SYNC_STAGE);   
 
 end if;
 end if;
 
 
 end process;
  
--   data_int(1) <= data_in; 
   
                data_int(1) <= data_in;
                
                

end architecture ; -- arch