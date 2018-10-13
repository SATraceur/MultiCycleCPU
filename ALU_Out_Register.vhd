----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2018 16:47:40
-- Design Name: 
-- Module Name: ALUoutRegister - Behavioral
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

entity ALUoutRegister is
    Port ( RegisterWriteControl : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (7 downto 0);
           DataOut : out STD_LOGIC_VECTOR (7 downto 0));
end ALUoutRegister;

architecture Behavioral of ALUoutRegister is
     
signal temp_output : std_logic_vector (7 downto 0);

begin

    process(RegisterWriteControl)
    begin
        if RegisterWriteControl'event and RegisterWriteControl = '1' then
            temp_output <= DataIn;
        end if;
    end process;

    DataOut <= temp_output;

end Behavioral;
