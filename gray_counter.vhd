library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gray_counter is
generic(COUNTER_SIZE:integer := 2);
 port(
reset: in std_logic;
 clock : in std_logic;
 en : in std_logic;
 counter_out: out std_logic_vector(COUNTER_SIZE - 1 downto 0)
 );
end gray_counter ;

architecture arch of gray_counter is

--signal q : std_logic_vector (COUNTER_SIZE - 1 downto 0);
signal q : std_logic_vector ( COUNTER_SIZE - 1 downto 0);
begin

    process(clock) begin

if(rising_edge(clock)) then
        if (reset = '1') then
            q <= (others => '0');
            --counter_out <= '0';
        else
            if en = '1' then
            
            q <= std_logic_vector(unsigned(q) + "1");
        counter_out <= q xor ('0' & q(COUNTER_SIZE - 1 downto 1));
            end if;
        end if;
    end if;
    end process;






end architecture ; -- arch