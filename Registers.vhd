library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Registers is
    Port ( RR1 : in STD_LOGIC_VECTOR (2 downto 0);
           RR2 : in STD_LOGIC_VECTOR (2 downto 0);
           WR : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (7 downto 0);
           RD1 : out STD_LOGIC_VECTOR (7 downto 0);
           RD2 : out STD_LOGIC_VECTOR (7 downto 0);
           RegWrite : in STD_LOGIC);
end Registers;

architecture Behavioral of Registers is

    type regs is array(7 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
    signal reg : regs := (others => "00000000");

begin

    RD1 <= reg(to_integer(unsigned(RR1))); -- get value of rs and output
    RD2 <= reg(to_integer(unsigned(RR2))); -- get value of rt and output
            
    process(RegWrite)
    begin
        if RegWrite'event and RegWrite = '1' then         
            reg(to_integer(unsigned(WR))) <= WD; -- Assign data to rd
        end if;
    end process;




end Behavioral;
