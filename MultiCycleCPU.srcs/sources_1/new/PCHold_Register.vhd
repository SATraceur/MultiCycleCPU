----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.05.2018 00:05:51
-- Design Name: 
-- Module Name: PCHold_Register - Behavioral
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

entity PCHold_Register is
    Port ( PCHoldControl : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (9 downto 0);
           DataOut : out STD_LOGIC_VECTOR (9 downto 0));
end PCHold_Register;

architecture Behavioral of PCHold_Register is

signal temp_output : std_logic_vector (9 downto 0) := "0000000000";

begin

    process(PCHoldControl)
    begin
        if PCHoldControl'event and PCHoldControl = '1' then
            temp_output <= DataIn;
        end if;
    end process;

    DataOut <= temp_output;


end Behavioral;
