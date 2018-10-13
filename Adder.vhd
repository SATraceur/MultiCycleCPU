library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Adder is
    Port ( cin : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (1 downto 0);
           b : in STD_LOGIC_VECTOR (1 downto 0);
           output : out STD_LOGIC_VECTOR (1 downto 0));
end Adder;

architecture Behavioral of Adder is

  component alu_slice is
        port( a : in STD_LOGIC;
              b : in STD_LOGIC;
              s : out STD_LOGIC;
              opcode : in STD_LOGIC_VECTOR(2 downto 0); 
              cin : in STD_LOGIC;
              cout : out STD_LOGIC);
    end component;
    
    signal carry : STD_LOGIC_VECTOR(1 downto 0);
    signal s_int : STD_LOGIC_VECTOR(1 downto 0);
    signal zero : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal flag : std_logic := '0';

begin

    slice0: alu_slice
        port map(a => a(0),
                 b => b(0),
                 s => s_int(0),
                 opcode => zero,
                 cin => cin,
                 cout => carry(0)); 
    
    slice1: alu_slice
        port map(a => a(1),
                 b => b(1),
                 s => s_int(1),
                 opcode => zero,
                 cin => carry(0),
                 cout => carry(1)); 

    output <= s_int;

    

end Behavioral;
