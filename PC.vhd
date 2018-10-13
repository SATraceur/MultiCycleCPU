library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port ( PCWrite : in STD_LOGIC;
           PCin : in STD_LOGIC_VECTOR (9 downto 0);
           PCout : out STD_LOGIC_VECTOR (9 downto 0));
end PC;

architecture Behavioral of PC is

    signal ProgramCounter : STD_LOGIC_VECTOR(9 downto 0) := "0000000000";

begin

    process(PCWrite, PCin)
    begin
        if PCWrite = '1' then -- if rising edge occurs
            ProgramCounter <= PCin;              
        end if;
    end process;

    PCout <= ProgramCounter;

end Behavioral;
