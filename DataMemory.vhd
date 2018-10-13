library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataMemory is
    Port ( Address : in STD_LOGIC_VECTOR (7 downto 0);
           WD : in STD_LOGIC_VECTOR (7 downto 0);
           RD : out STD_LOGIC_VECTOR (7 downto 0);
           MemWrite : in STD_LOGIC);
end DataMemory;

architecture Behavioral of DataMemory is

    type DM is array (0 to 127) of STD_LOGIC_VECTOR(7 downto 0);
    signal DataMemory : DM := (X"69", X"52", X"50", X"EE", X"21", X"F3", X"A6", X"92", X"03", X"A3", 
                               X"3E", X"94", X"BC", X"7F", X"C5", X"F5", X"33", X"5A", X"70", X"CC",
                               X"71", X"FE", X"35", X"92", X"09", X"BE",others=>X"00");
begin

    -- Ignore MSB of address, only need addresses 0 - 127
    RD <= DataMemory(to_integer(unsigned('0'&Address(6 downto 0))));
    
    process(MemWrite)
    begin
        if MemWrite = '1' then
            DataMemory(to_integer(unsigned(Address))) <= WD;
        end if;
    end process;

end Behavioral;
