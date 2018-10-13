library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionMemory is
    Port ( PC : in STD_LOGIC_VECTOR (9 downto 0);
           InstructionRead : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR (19 downto 0));
end InstructionMemory;

architecture Behavioral of InstructionMemory is

    type IM is array (0 to 1023) of STD_LOGIC_VECTOR(19 downto 0);
    signal InstructionMemory : IM;
    signal OutputInstruction : STD_LOGIC_VECTOR (19 downto 0);

begin
    InstructionMemory <= (X"3C000", X"3C101", X"3C201", X"3C400", X"3C501", X"3C60C", X"3C708", X"8C180", X"8EA00", 
                         X"00A30", X"8F200", X"00A30", X"8FA00", X"00A30", X"841A0", X"02DBC", X"3C201", X"01028", 
                         X"10A02", X"036DC", X"3C103", X"0249C", X"02148", X"14A03", X"03FFC", X"3C400", X"3C11A", 
                         X"14D02", X"3C500", X"14E02", X"3C600", X"14F02", X"3C700", X"0001C", X"3C120", X"148E4", 
                         X"08240", others => X"00000"); 

    process(InstructionRead)
    begin
         if InstructionRead = '1' then
             OutputInstruction <= InstructionMemory(to_integer(unsigned(PC)));
         end if;
    end process;
    
    Instruction <= OutputInstruction;
    

end Behavioral;
