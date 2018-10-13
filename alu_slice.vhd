----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2018 11:26:49
-- Design Name: 
-- Module Name: alu_slice - Behavioral
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

entity alu_slice is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           s : out STD_LOGIC;
           cin : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR(2 downto 0);
           cout : out STD_LOGIC);
end alu_slice;

architecture Behavioral of alu_slice is
begin

OP_LOGIC: process(a, b, opcode, cin)  
begin

case opcode is

    when "000" => -- a + b
        s <= (cin xor a) xor b;
        cout <= (a and cin) or (b and cin) or (a and b);
    when "001" => -- a - b
        s <= (cin xor a) xor (not b);
        cout <= (a and cin) or ((not b) and cin) or (a and (not b));
    when "010" => -- a & b
        s <= a and b;
        cout <= '0';    
    when "011" => -- a | b
        s <= a or b;
        cout <= '0';
    when "100" => -- a ^ b
        s <= a xor b;
        cout <= '0';
    when "101" => -- ~a
        s <= not a;
        cout <= '0';
    when "110" =>  -- LBS a
        s <= cin;
        cout <= a;
    when "111" => -- a + 1
        s <= (cin xor a) xor '0';
        cout <= (a and cin) or ('0' and cin) or (a and '0');
    when others =>
        s <= '0';
        cout <= '0';
end case;

end process OP_LOGIC;


end Behavioral;
