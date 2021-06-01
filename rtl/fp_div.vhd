library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity divider is port(
    clk      : in std_logic;
    res      : in std_logic;
    GO      : in std_logic;
    x       : in std_logic_vector(31 downto 0);
    y       : in std_logic_vector(31 downto 0);
    z        : out std_logic_vector(31 downto 0);
    done     : out std_logic;
    overflow : out std_logic);
end divider;

architecture design of divider is
    signal x_reg      : std_logic_vector(31 downto 0);
    signal y_reg      : std_logic_vector(31 downto 0);
    signal x_mantissa : std_logic_vector(23 downto 0);
    signal y_mantissa : std_logic_vector(23 downto 0);
    signal z_mantissa : std_logic_vector(23 downto 0);
    signal x_exponent : std_logic_vector(7 downto 0);
    signal y_exponent : std_logic_vector(7 downto 0);
    signal z_exponent : std_logic_vector(7 downto 0);
    signal x_sign     : std_logic;
    signal y_sign     : std_logic;
    signal z_sign     : std_logic;
    signal sign       : std_logic;
    signal SC         : integer range 0 to 26;
    signal exp        : std_logic_vector(9 downto 0);
    signal EA         : std_logic_vector(24 downto 0);
    signal B          : std_logic_vector(23 downto 0);
    signal Q          : std_logic_vector(24 downto 0);
    type states is (reset, idle, s0, s1, s2, s3, s4);
    signal state : states;

begin
    x_mantissa <= '1' & x_reg(22 downto 0);
    x_exponent <= x_reg(30 downto 23);
    x_sign <= x_reg(31);
    y_mantissa <= '1' & y_reg(22 downto 0);
    y_exponent <= y_reg(30 downto 23);
    y_sign <= y_reg(31);
process(clk)begin
    if clk'event and clk = '1' then if res = '1' then state <= reset;
        exp <= (others => '0');
        sign <= '0';
        x_reg <= (others => '0');
        y_reg <= (others => '0');
        z_sign <= '0';
        z_mantissa <= (others => '0');
        z_exponent <= (others => '0');
        EA <= (others => '0');
        Q <= (others => '0');
        B <= (others => '0');
        overflow <= '0';
        done <= '0';
    else
        case state is
            when reset =>  
                state <= idle;
            when idle => 
                if GO = '1' 
                then 
                    state <= s0;
                    x_reg <= x;
                    y_reg <= y;
                end if;
            when s0 => 
                state <= s1;
                overflow <= '0';
                SC <= 25;
                done <= '0';
                sign <= x_sign xor y_sign;
                EA <= '0' & x_mantissa;
                B <= y_mantissa;
                Q <= (others => '0');
                exp <= ("00" & x_exponent) + not ("00" & y_exponent) + 1 + "0001111111";
            when s1 => 
                if (y_mantissa = x"800000" and y_exponent = x"00") 
                then 
                    overflow <= '1';
                    z_sign <= sign;
                    z_mantissa <= (others => '0');
                    z_exponent <= (others => '1');
                    done <= '1';
                    state <= idle;
                elsif exp(9) = '1' or exp(7 downto 0) = x"00" or (x_exponent = x"00" and x_mantissa = x"00") or (y_exponent = x"FF" and y_mantissa = x"00")  
                then 
                    z_sign <= sign;
                    z_mantissa <= (others => '0');
                    z_exponent <= (others => '0');
                    done <= '1';
                    state <= idle;
                else
                    EA <= EA  + ('0' & not B) + 1;
                    state <= s2;
                end if;
            when s2 =>  
                if EA(24) = '1' 
                then 
                    Q(0) <= '1';
                else
                    Q(0) <= '0';
                    EA <= EA + B;
                end if;
                SC <= SC -1;
                state <= s3;
            when s3 => 
                if SC = 0 then 
                    if Q(24) = '0' 
                    then 
                        Q <= Q (23 downto 0) & '0';
                        exp <= exp -1;
                    end if;
                    state <= s4;
                else EA <= EA(23 downto 0) & Q(24);
                    Q <= Q(23 downto 0) & '0';
                    state <= s1;
                end if;
            when s4 =>  
                if exp = x"00" then  z_sign <= sign;
                    z_mantissa <= (others => '0');
                    z_exponent <= (others => '0');
                elsif exp(9 downto 8) = "01" 
                then
                    z_sign <= sign;
                    z_mantissa <= (others => '0');
                    z_exponent <= (others => '1');
                else  
                    z_sign <= sign;
                    z_mantissa <= Q(24 downto 1);
                    z_exponent <= exp(7 downto 0);
                end if;
                done <= '1';
                state <= idle;
        end case;
        end if;
    end if;
end process;
    z <= z_sign & z_exponent & z_mantissa(22 downto 0);
end design;

