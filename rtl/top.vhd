----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2019 11:33:33 AM
-- Design Name: 
-- Module Name: processor_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inverter is
  Port (CLK100MHZ: in std_logic;
        btn_0: in std_logic;
        btn_1: in std_logic;
        led0_g: out std_logic;
        led0_b: out std_logic
        );
end inverter;

architecture Behavioral of inverter is

component debounce port(
      clk: in std_logic;
      raw: in std_logic;
      debounced: out std_logic
  );
  
end component;


signal button_0_db: std_logic; 
signal button_1_db: std_logic; 



begin

debounce0: debounce port map(
  clk => CLK100MHZ,
  raw => btn_0,
  debounced => button_0_db 
 );
 
 debounce1: debounce port map(
  clk => CLK100MHZ,
  raw => btn_1,
  debounced => button_1_db 
 );

led0_b <= NOT(button_0_db);
led0_g <= NOT(button_1_db);
end Behavioral;
