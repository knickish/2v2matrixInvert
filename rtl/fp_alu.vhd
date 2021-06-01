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

component FPadd is
   PORT( 
      ADD_SUB : IN     std_logic;
      FP_A    : IN     std_logic_vector (31 DOWNTO 0);
      FP_B    : IN     std_logic_vector (31 DOWNTO 0);
      clk     : IN     std_logic;
      FP_Z    : OUT    std_logic_vector (31 DOWNTO 0)
   );
end component;

component FPmul is 
   PORT( 
      FP_A : IN     std_logic_vector (31 DOWNTO 0);
      FP_B : IN     std_logic_vector (31 DOWNTO 0);
      clk  : IN     std_logic;
      FP_Z : OUT    std_logic_vector (31 DOWNTO 0)
   );
end component;

signal out_fpa: std_logic_vector(31 downto 0);
signal out_fpm,out_div: std_logic_vector(31 downto 0);
signal in1_fpa,in2_fpa: std_logic_vector(31 downto 0);
signal res_rdy: std_logic;
signal outer_overflow: std_logic;

begin

in1_fpa<=in1;
in2_fpa<=in2;


fpa1:FPadd 
port map
(
     ADD_SUB => '0',
     FP_A  => in1,
     FP_B   => in2,
     clk   => clk,
     FP_Z => out_fpa
);


fpm1:FPmul PORT MAP 
(
     FP_A  => in1,
     FP_B   => in2,
     clk   => clk,
     FP_Z => out_fpm
);

fpd1:divider port map(
clk      => clk,
res      => '0',
GO       => '1',
x        => in1,
y        => in2,
z        => out_div,
done     => res_rdy,
overflow => outer_overflow
);

process(sel,clk)
begin 
    if(sel="01")
        then
        output1<=out_fpa(31 downto 0);
    elsif(sel="10")
        then
        output1<=out_fpm;
    elsif(sel="11")
        then
        output1<=out_div;
    end if;
end process;
end fp_alu_struct;

