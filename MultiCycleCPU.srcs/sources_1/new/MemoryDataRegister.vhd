----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2018 19:47:41
-- Design Name: 
-- Module Name: MemoryDataRegister - Behavioral
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

entity MemoryDataRegister is
    Port ( RegisterWriteControl : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (7 downto 0);
           DataOut : out STD_LOGIC_VECTOR (7 downto 0));
end MemoryDataRegister;

architecture Behavioral of MemoryDataRegister is

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
