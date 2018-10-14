----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2018 20:52:11
-- Design Name: 
-- Module Name: SignExtend - Behavioral
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

entity SignExtend is
    Port ( Input : in STD_LOGIC_VECTOR (7 downto 0);
           Output : out STD_LOGIC_VECTOR (9 downto 0));
end SignExtend;

architecture Behavioral of SignExtend is

signal temp_output : std_logic_vector(9 downto 0);

begin
    
    temp_output <= Input(7) & Input(7) & Input(7 downto 0);
    Output <= temp_output;

end Behavioral;
