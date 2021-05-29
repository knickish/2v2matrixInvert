library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity fpm is
    port(
        in1,in2:in std_logic_vector(31 downto 0);

        out1:out std_logic_vector(31 downto 0));
end fpm;
architecture Behavioral of fpm is
    procedure adder( a,b:in std_logic_vector(7 downto 0);
sout : out  STD_LOGIC_VECTOR (8 downto 0)) is 
    variable g,p:std_logic_vector(7 downto 0);
    variable c:std_logic_vector(8 downto 0);
    variable sout1 :STD_LOGIC_VECTOR (7 downto 0);
begin
    c(0):='0';
for i in 0 to 7 loop
    g(i):= a(i) and b(i);
p(i):= a(i) xor b(i);
end loop;
for i in 0 to 7 loop
    c(i+1):=(g(i) or (c(i) and p(i)));
end loop;
for i in 0 to 7 loop
    sout1(i):=c(i) xor a(i) xor b(i);
end loop;
sout:=c(8) & sout1;
end adder;
-------------------------------------------multiplier-------------------------------
procedure multiplier ( a,b : in  STD_LOGIC_VECTOR (23 downto 0);
y : out  STD_LOGIC_VECTOR (47 downto 0))isvariable temp,prod:std_logic_vector(47 downto 0);
begintemp:="000000000000000000000000"&a;
prod:="000000000000000000000000000000000000000000000000";
for i in 0 to 23 loopif b(i)='1' thenprod:=prod+temp;
end if;
temp:=temp(46 downto 0)&'0';
end loop;
y:=prod;
end multiplier;
--------------------------end multipier-----------------------------------------------
begin
    process(in1,in2)variable sign_f,sign_in1,sign_in2: std_logic:='0';
    variable e1,e2: std_logic_vector(7 downto 0):="00000000";
    variable add_expo:std_logic_vector(8 downto 0):="000000000";
    variable m1,m2: std_logic_vector(23 downto 0):="000000000000000000000000";
    variable mantisa_round: std_logic_vector(22 downto 0):="00000000000000000000000";
    variable prod:std_logic_vector(47 downto 0):="000000000000000000000000000000000000000000000000";
    variable mul_mantisa :std_logic_vector(47 downto 0):="000000000000000000000000000000000000000000000000";
    variable bias:std_logic_vector(8 downto 0):="001111111";
    variable bias_sub:std_logic_vector(7 downto 0):="00000000";
    variable inc_bias:std_logic_vector(8 downto 0):="000000000";
    variable bias_round:std_logic_vector(8 downto 0):="000000000";
begin
    sign calculation
    sign_in1:=in1(31);
    sign_in2:=in2(31);
    sign_f:=sign_in1 xor sign_in2;

