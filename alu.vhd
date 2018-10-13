library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           s : out STD_LOGIC_VECTOR (7 downto 0);
           opcode : in STD_LOGIC_VECTOR(2 downto 0); 
           overflow : out STD_LOGIC;
           zero : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

    component alu_slice is
        port( a : in STD_LOGIC;
              b : in STD_LOGIC;
              s : out STD_LOGIC;
              opcode : in STD_LOGIC_VECTOR(2 downto 0); 
              cin : in STD_LOGIC;
              cout : out STD_LOGIC);
    end component;

    signal carry : STD_LOGIC_VECTOR(8 downto 0);
	signal s_int : STD_LOGIC_VECTOR(7 downto 0);
	
begin

slice0: alu_slice
    port map(a => a(0),
			 b => b(0),
			 s => s_int(0),
			 opcode => opcode,
			 cin => carry(0),
             cout => carry(1)); 

slice1: alu_slice
	port map(a => a(1),
			 b => b(1),
			 s => s_int(1),
			 opcode => opcode,
			 cin => carry(1),
             cout => carry(2)); 

slice2: alu_slice
	port map(a => a(2),
			 b => b(2),
			 s => s_int(2),
			 opcode => opcode,
			 cin => carry(2),
	         cout => carry(3)); 

slice3: alu_slice
	port map(a => a(3),
			 b => b(3),
			 s => s_int(3),
			 opcode => opcode,
			 cin => carry(3),
	         cout => carry(4));

slice4: alu_slice
	port map(a => a(4),
			 b => b(4),
			 s => s_int(4),
			 opcode => opcode,
			 cin => carry(4),
	         cout => carry(5));

slice5: alu_slice
	port map(a => a(5),
			 b => b(5),
			 s => s_int(5),
			 opcode => opcode,
			 cin => carry(5),
	         cout => carry(6));

slice6: alu_slice
	port map(a => a(6),
			 b => b(6),
			 s => s_int(6),
			 opcode => opcode,
			 cin => carry(6),
	         cout => carry(7));

slice7: alu_slice
	port map(a => a(7),
			 b => b(7),
			 s => s_int(7),
			 opcode => opcode,
			 cin => carry(7),
	         cout => carry(8));


    process(opcode)
        begin
        case opcode is
            when "001" => --> Subtract
                carry(0) <= '1';
            when "110" => --> LBS
                carry(0) <= '1';
            when "111" => --> A++
                carry(0) <= '1';
            when others =>
                carry(0) <= '0';
            end case;
    end process;
    
    zero <= not (s_int(0) or s_int(1) or s_int(2) or s_int(3) or s_int(4) or s_int(5) or s_int(6) or s_int(7));
    overflow <= carry(8);
    s <= s_int;
    
end Behavioral;
