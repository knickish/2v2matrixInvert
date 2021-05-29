library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity fp_alu is
port(
in1,in2:    in std_logic_vector(31 downto 0);
clk:        in std_logic;sel:in std_logic_vector(1 downto 0);
output1:    out std_logic_vector(31 downto 0)
);
end fp_alu;


architecture fp_alu_struct of fp_alu is 

component divider is
port(
clk      : in std_logic;
res      : in std_logic;
GO       : in std_logic;
x        : in std_logic_vector(31 downto 0);
y        : in std_logic_vector(31 downto 0);
z        : out std_logic_vector(31 downto 0);
done     : out std_logic;
overflow : out std_logic);
end component;

component fpa_seq is
port(
n1,n2   :in std_logic_vector(32 downto 0);
clk     :in std_logic;
sum     :out std_logic_vector(32 downto 0)
);
end component;

component fpm is 
port(
in1,in2     :in std_logic_vector(31 downto 0);
out1        :out std_logic_vector(31 downto 0)
);
end component;

signal out_fpa: std_logic_vector(32 downto 0);
signal out_fpm,out_div: std_logic_vector(31 downto 0);
signal in1_fpa,in2_fpa: std_logic_vector(32 downto 0);

begin

in1_fpa<=in1&'0';
in2_fpa<=in2&'0';
fpa1:fpa_seq port map(in1_fpa,in2_fpa,clk,out_fpa);
fpm1:fpm port map(in1,in2,out_fpm);
fpd1:divider port map(clk,'0','1',in1,in2,out_div);

process(sel,clk)
begin 
    if(sel="01")
        then
        output1<=out_fpa(32 downto 1);
    elsif(sel="10")
        then
        output1<=out_fpm;
    elsif(sel="11")
        then
        output1<=out_div;
    end if;
end process;
end fp_alu_struct;
