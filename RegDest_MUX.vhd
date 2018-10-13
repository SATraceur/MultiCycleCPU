----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2018 14:50:52
-- Design Name: 
-- Module Name: RegDest_MUX - Behavioral
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

entity RegDest_MUX is
    Port ( In1 : in STD_LOGIC_VECTOR (2 downto 0);
           In2 : in STD_LOGIC_VECTOR (2 downto 0);
           Output : out STD_LOGIC_VECTOR (2 downto 0);
           RegDest : in STD_LOGIC);
end RegDest_MUX;

architecture Behavioral of RegDest_MUX is

signal temp_output : std_logic_vector (2 downto 0);

begin

    process(RegDest, In1, In2)
    begin
        case RegDest is
            when '1' => -- rt
                temp_output <= In1;
            when '0' => -- rd
                temp_output <= In2;
            when others =>
                temp_output <= "000";
            end case;
    end process;

    Output <= temp_output;


end Behavioral;
