----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2018 15:50:06
-- Design Name: 
-- Module Name: ALU_SRC_MUX - Behavioral
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

entity ALU_SRC_MUX is
    Port ( In1 : in STD_LOGIC_VECTOR (7 downto 0);
           In2 : in STD_LOGIC_VECTOR (7 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0);
           SRC_Select : in STD_LOGIC_VECTOR (1 downto 0));
end ALU_SRC_MUX;

architecture Behavioral of ALU_SRC_MUX is

signal temp_output : std_logic_vector(7 downto 0);

begin

    process(SRC_Select, In1, In2)
    begin
        case SRC_Select is
            when "01" => 
                temp_output <= In1;
            when "00" =>
                temp_output <= In2;
            when others =>
                temp_output <= "00000000";
            end case;
    end process;

Output <= temp_output;

end Behavioral;
