library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity fpa_seq is port(
    n1,n2   :in std_logic_vector(32 downto 0);
    clk     :in std_logic;
    sum     :out std_logic_vector(32 downto 0)
    );
end fpa_seq;
    
architecture Behavioral of fpa_seq is
signal sub_e:std_logic_vector(7 downto 0):="00000000";
signal c_temp:std_logic:='0';
signal shift_count1:integer:=0;
signal num2_temp2: std_logic_vector(32 downto 0):="000000000000000000000000000000000";
signal s33:std_logic_vector(23 downto 0):="000000000000000000000000";
signal s2_temp :std_logic_vector(23downto 0):="000000000000000000000000";
signal diff:unsigned(7 downto 0):="00000000";
signal e1:unsigned(7 downto 0):="00000000";
signal e2:unsigned(7 downto 0):="00000000";

begin
----------sub calling-----------------------------------------------------------------
diff <= e1 - e2;
if(diff>="00011100")
then
    sum<=num1;
elsif(diff<"00011100")
then
    shift_count:=conv_integer(d);
    shift_count1<=shift_count;
    num2_temp2<=num2;
--------------shifter calling---------------------------------------------------------
    shift(s2,shift_count,s3);
    ------------sign bit checking------
    if (num1(32)/=num2(32))
    then
        s3:=(not(s3)+'1'); ------2's complement
        adder23(s1,s3,s4,c_out);
        if(c_out='1')
        then
            shift_left(s4,d_shl,ss4);
            sub(e1,d_shl,ee4);
            sum<=n1(32)& ee4 & ss4;
        else
            if(s4(23)='1')
            then
                s4:=(not(s4)+'1'); ------2's complement
                sum<=n1(32)& e1 & ss4;
            end if;
        end if;
    else
        s3:=s3;
    ---------------------same sign start
    ---------------adder 8 calling---------------
        adder8(e2,d,e3);
        sub_e<=e3;
        num1_temp:=n1(32)& e1 & s1;
        num2_temp:=n2(32)& e3 & s3;
        ---------------adder 23 calling---------------
        adder23(s1,s3,s4,c_out);
        c_temp<=c_out;
        if(c_out='1')
        then
            s33<=s4;
            s5:='1' & s4(23 downto 1);
            s2_temp<=s5;
            adder8(e3,"00000001",e4);
            e3:=e4;
            sum<=n1(32)& e3 & s5;
        else
            sum<=n1(32)& e3 & s4;
        end if;
        end if;
        end if;
    end if;----same sign end
end if;
end process;
end Behavioral;
