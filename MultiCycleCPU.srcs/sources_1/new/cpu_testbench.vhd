--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:49:00 05/13/2015
-- Design Name:   
-- Module Name:   U:/dsm/project2015/cpu_testbench.vhd
-- Project Name:  project2015
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cpu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 
ENTITY cpu_testbench IS
END cpu_testbench;
 
ARCHITECTURE behavior OF cpu_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cpu
    PORT(
         clk : IN  std_logic;
         IOaddress : OUT  std_logic_vector(6 downto 0);
         IOread : IN  std_logic_vector(7 downto 0);
         IOwrite : OUT  std_logic_vector(7 downto 0);
         IOwrite_enable : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal IOread : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal IOaddress : std_logic_vector(6 downto 0);
   signal IOwrite : std_logic_vector(7 downto 0);
   signal IOwrite_enable : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	type ram_type is array (0 to 127) of std_logic_vector (7 downto 0);
   signal ioram : ram_type:=(X"a1", X"43", X"e0", X"22", X"f8", X"d0", X"30", X"7e", 
	                         X"dd", X"85", X"37", X"78", X"d7", X"da", X"e9", X"52", 
							 X"26", X"d1", X"84", X"e8", X"7a", X"72", X"94", X"98", 
							 X"e1", X"90", X"f3", X"43", X"be", X"46", X"bf", X"f5",others=>X"00");


 
BEGIN
   
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          clk => clk,
          IOaddress => IOaddress,
          IOread => IOread,
          IOwrite => IOwrite,
          IOwrite_enable => IOwrite_enable
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   process (clk,IOwrite_enable,IOaddress,IOwrite)  --implement the ram.  This is a synchronus write.
   begin
     if rising_edge(clk) then
       if IOwrite_enable='1' then
         ioram(conv_integer(IOaddress)) <= IOwrite;
       end if;
     end if;
  end process;
  
  IOread<=ioram(conv_integer(IOaddress));


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
      -- insert stimulus here 
      wait;
   end process;

END;
