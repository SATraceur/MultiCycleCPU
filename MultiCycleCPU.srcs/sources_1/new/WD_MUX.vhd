----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2018 16:39:49
-- Design Name: 
-- Module Name: WD_MUX - Behavioral
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

entity WD_MUX is
    Port ( In1 : in STD_LOGIC_VECTOR (7 downto 0);
           In2 : in STD_LOGIC_VECTOR (7 downto 0);
           In3 : in STD_LOGIC_VECTOR (7 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0);
           SRC_Select : in STD_LOGIC_VECTOR (1 downto 0));
end WD_MUX;

architecture Behavioral of WD_MUX is

signal temp_output : std_logic_vector(7 downto 0);

begin

    process(SRC_Select, In1, In2, In3)
    begin
        case SRC_Select is
            when "00" => -- 8-bit immediate
                temp_output <= In1;
            when "01" => -- ALUout
                temp_output <= In2;
            when "10" => -- Data Memory out
                temp_output <= In3;
            when others =>
                temp_output <= "00000000";
            end case;
    end process;

    Output <= temp_output;

end Behavioral;
