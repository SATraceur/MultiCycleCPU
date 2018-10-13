----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2018 18:09:01
-- Design Name: 
-- Module Name: PC_MUX - Behavioral
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

entity PC_MUX is
    Port ( In1 : in STD_LOGIC_VECTOR (9 downto 0);
           In2 : in STD_LOGIC_VECTOR (9 downto 0);
           In3 : in STD_LOGIC_VECTOR (9 downto 0);
           Output : out STD_LOGIC_VECTOR (9 downto 0);
           PCSelect : in STD_LOGIC_VECTOR (1 downto 0));
end PC_MUX;

architecture Behavioral of PC_MUX is

signal temp_output : std_logic_vector(9 downto 0) := "0000000000";

begin

    process(PCSelect, In1, In2, In3)
    begin
        case PCSelect is
            when "00" => -- PC + 1
                temp_output <= In1;
            when "01" => -- Jump Target
                temp_output <= In2;
            when "10" => -- PC + Immediate
                temp_output <= In3;
            when others =>
                temp_output <= "0000000000";
            end case;
    end process;

    Output <= temp_output;

end Behavioral;
