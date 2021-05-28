library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity fp_mul is
  Port (clk: in std_logic;
  raw: in std_logic;
  debounced: out std_logic
   );
end fp_mul;

architecture Behavioral of fp_mul is
    constant counterMax : std_logic_vector(7 downto 0):=x"20";
    constant counterMid : std_logic_vector(7 downto 0):=x"10";
    signal counter: std_logic_vector(7 downto 0):=counterMid;
    signal lockCounter: std_logic_vector(3 downto 0):=x"0";
    signal internal: std_logic:='0';
    
    
    

begin
process(clk)
begin
    if(clk'event and clk='1')then
        if(lockCounter=x"0")then
            if(raw='1')then
                if (counter<counterMax)then
                    counter <= counter + x"01";
                else
                    lockCounter <= lockCounter +x"1";
                end if;
            else
                if(counter>x"00")then
                    counter <= counter - x"01";
                else
                    lockCounter <= lockCounter +x"1";
                end if;
            end if;
        else
            lockCounter <= lockCounter +x"1";
        end if;
    end if;
end process;

process(counter)
begin
    if (counter=counterMax)then
        internal<='1';
    elsif (counter=x"00")then
        internal <='0';
    end if;
end process;

debounced<=internal;        

end Behavioral;
