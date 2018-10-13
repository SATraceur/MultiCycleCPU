----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.05.2018 22:18:57
-- Design Name: 
-- Module Name: Control - Behavioral
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

entity Control is
    Port ( ALUOut : in STD_LOGIC_VECTOR (7 downto 0);
           AdderOut : in STD_LOGIC_VECTOR (1 downto 0);
           OPCode : in STD_LOGIC_VECTOR (5 downto 0);
           Funct : in STD_LOGIC_VECTOR (2 downto 0);
           ALUZeroFlag : in STD_LOGIC;
           clk : in STD_LOGIC;
           PCWriteControl : out STD_LOGIC;
           InstructionReadControl : out STD_LOGIC;
           RegDestControl : out STD_LOGIC;
           RegWriteControl : out STD_LOGIC;
           WDSelectControl : out STD_LOGIC_VECTOR (1 downto 0);
           ALUsrcAControl : out STD_LOGIC_VECTOR (1 downto 0);
           ALUsrcBControl : out STD_LOGIC_VECTOR (1 downto 0);
           OPControl : out STD_LOGIC_VECTOR (2 downto 0);
           PCSourceControl : out STD_LOGIC_VECTOR (1 downto 0);
           IORAMEnableControl : out STD_LOGIC;
           RAMEnableControl : out STD_LOGIC;
           RDMUXControl : out STD_LOGIC;
           PCHoldWriteControl : out STD_LOGIC;
           ARegisterWriteControl : out STD_LOGIC;
           BRegisterWriteControl : out STD_LOGIC;
           ALUoutRegisterWriteControl : out STD_LOGIC;
           MDRRegisterWriteControl : out STD_LOGIC
           --ConcatPC : out STD_LOGIC_VECTOR (9 downto 0)
           );
end Control;


architecture Behavioral of Control is

    type ins_enum is (ADD_ins, SUB_ins, AND_ins, OR_ins, XOR_ins, NOT_ins, LBS_ins, INC_ins, LOADI_ins, LOAD_ins, STORE_ins, BEQ_ins, BNE_ins, JUMP_ins, NOP_ins, UNKNOWN_ins);  -- Exists for debugging 
    type ins_type_enum is (R_TYPE, I_TYPE, J_TYPE, UNKNOWN_TYPE);
    type cycle_enum is (CC1, CC2, CC3, CC4, CC5);    
    signal current_instruction : ins_enum := UNKNOWN_ins;
    signal current_instruction_type : ins_type_enum := UNKNOWN_TYPE;
    signal current_cycle : cycle_enum := CC1;
    signal tempOPControl : std_logic_vector(2 downto 0) := "111";
        
begin

    process(clk)
    begin
    
        if clk'event and clk = '1' then -- If rising edge of clock occurs (clk changes states) 
                   
            case current_cycle is   
                  
                when CC1 => -- CC1 is the same for all instructions
                    
                    current_instruction_type <= UNKNOWN_TYPE;  
                    current_instruction <= UNKNOWN_ins;  
                
                    -- Reset register latch control variables from previous instructions
                    PCWriteControl <= '0';
                    RegWriteControl <= '0';   
                    ARegisterWriteControl <= '0';
                    BRegisterWriteControl <= '0';  
                    ALUoutRegisterWriteControl <= '0';
                    MDRRegisterWriteControl <= '0';
                    RAMEnableControl <= '0'; 
                    IORAMEnableControl <= '0'; 
                    
                
                    -- Set PC as input to ALU source A
                    ALUsrcAControl <= "01";                  
                    -- Set ALU to increment PC
                    tempOPControl <= "111";                                      
                    -- Store PC + 1 in PC hold register
                    PCHoldWriteControl <= '1';                                                
                    -- Read instruction from memory
                    InstructionReadControl <= '1'; 
                    -- Set next state
                    current_cycle <= CC2;   
                                       
                when CC2 =>  
                    -- Reset register latch control signals from cycle 1
                    PCHoldWriteControl <= '0';
                    InstructionReadControl <= '0';
                                    
                    -- Determine instruction type
                    case OPCode is
                        
                        when "000000" => -- R-Type instruction
                            current_instruction_type <= R_TYPE;                            
                            case Funct is
                                when "000" => 
                                    current_instruction <= ADD_ins;                                    
                                when "001" => 
                                    current_instruction <= SUB_ins;                                    
                                when "010" => 
                                    current_instruction <= AND_ins;                                    
                                when "011" => 
                                    current_instruction <= OR_ins;                                           
                                when "100" =>
                                    current_instruction <= XOR_ins;                                                   
                                when "101" => 
                                    current_instruction <= NOT_ins;                                    
                                when "110" => 
                                    current_instruction <= LBS_ins;                                    
                                when "111" => 
                                    current_instruction <= INC_ins;                                    
                                when others =>                                                   
                            end case;
                            
                            -- Store $rs and $rt in intermediate registers
                            ARegisterWriteControl <= '1';
                            BRegisterWriteControl <= '1';                 
                            -- Set ALU sources to rs and rt
                            ALUsrcAControl <= "00";
                            ALUsrcBControl <= "01";  
                            -- Set ALU OPcode as per the instruction FUNCT field
                            tempOPControl <= Funct;                       
                            -- Set PC source to PC + 1
                            PCSourceControl <= "00";                                                    
                            -- Set next cycle
                            current_cycle <= CC3;  
                            
                            
                        when "001111" => -- Load Immediate Instruction    
                            current_instruction_type <= I_TYPE;
                            current_instruction <= LOADI_ins;
                            -- Set write data to 8-bit immediate value
                            WDSelectControl <= "00";
                            -- Set write register to rt
                            RegDestControl <= '1';
                            -- Write 8-bit immediate to rt
                            RegWriteControl <= '1';                
                            -- Set PC source to PC + 1
                            PCSourceControl <= "00";
                            -- Update PC
                            PCWriteControl <= '1';
     ------------------------------------------------------------------------------------                       
                            -- Set ALU to calculate PC + 1
              --              ALUsrcAControl <= "01";                                    
              --              ALUsrcBControl <= "11";            
              --              tempOPControl <= "111";   
                            
            
        ---------------------------------------------------------------------                     
                            
                           -- Set next state
                            current_cycle <= CC1; 
                                                   
                        when "100011" | "100001" => -- Load or Store Instruction
                            current_instruction_type <= I_TYPE;
                            if OPCode = "100011" then
                                current_instruction <= LOAD_ins;
                            else
                                current_instruction <= STORE_ins;
                            end if;
                            -- Store $rs and $rt in intermediate registers
                            ARegisterWriteControl <= '1';
                            BRegisterWriteControl <= '1';
                            -- Set ALU sources to $rs and 8-bit immediate
                            ALUsrcAControl <= "00";
                            ALUsrcBControl <= "00";
                            -- Set ALU OPcode to ADD
                            tempOPControl <= "000";
                            -- Set PC source to PC + 1
                            PCSourceControl <= "00";            
                            -- Set next cycle
                            current_cycle <= CC3;                                                                       
                                                
                        when "000100" | "000101" => -- BEQ or BNE Instruction
                            current_instruction_type <= I_TYPE;
                            if OPCode = "000100" then
                                current_instruction <= BEQ_ins;    
                            else
                                current_instruction <= BNE_ins;                           
                            end if;
                            
                            -- Store $rs and $rt in intermediate registers
                            ARegisterWriteControl <= '1';
                            BRegisterWriteControl <= '1';
                            -- Set ALU sources to $rs and $rt
                            ALUsrcAControl <= "00";
                            ALUsrcBControl <= "01";
                            -- Set ALU operation to subtract
                            tempOPControl <= "001";                           
                            -- Set next cycle
                            current_cycle <= CC3;   
                            
                        when "000010" => -- Jump Instruction
                            current_instruction_type <= J_TYPE;
                            current_instruction <= JUMP_ins;
                            -- Set PC to jump target
                            PCSourceControl <= "01";
                            -- Update PC
                            PCWriteControl <= '1';
                            
                            -- Set next state
                            current_cycle <= CC1; 
                        
                        when others => -- NOP
                            -- Set next state
                            current_cycle <= CC1; 
                            
                    end case; 
                                 
                when CC3 =>
                    case current_instruction_type is
                        when R_TYPE =>                            
                            -- Store ALU result in ALUout Register
                            ALUoutRegisterWriteControl <= '1';
                            -- Select ALU result as write data via WD_MUX
                            WDSelectControl <= "01";
                            -- Set rd as register to write to
                            RegDestControl <= '0';
                            -- Set the next state
                            current_cycle <= CC4;  
                            
                        when I_TYPE =>
                        
                            case current_instruction is
                            
                                when BEQ_ins =>
                                    if ALUZeroFlag = '1' then -- if $rs == $rt
                                        -- Set PC source to PC + 8-bit immediate
                                        PCSourceControl <= "10"; -- changed this from PC + immediate to PCholdout
                                        -- Calculate PC + 8-bit immediate
                                        ALUsrcAControl <= "01";                                      
                                        ALUsrcBControl <= "00";              
                                        tempOPControl <= "000";                
                                    else
                                        -- Set PC source to PC + 1
                                        PCSourceControl <= "00";
                                        -- Set ALU to calculate PC + 1
                                        ALUsrcAControl <= "01";                                    
                                        ALUsrcBControl <= "11";            
                                        tempOPControl <= "111";                                                                        
                                    end if; 
                                    -- Set next state
                                    current_cycle <= CC4; 
                                    
                                when BNE_ins =>
                                    if ALUZeroFlag = '0' then -- if $rs != $rt
                                        -- Set PC source to PC + 8-bit immediate
                                        PCSourceControl <= "10"; -- changed this from PC + immediate to PCholdout
                                        -- Calculate PC + 8-bit immediate
                                        ALUsrcAControl <= "01";                                      
                                        ALUsrcBControl <= "00";              
                                        tempOPControl <= "000";   
                                        
                                    else
                                        -- Set PC source to PC + 1
                                        PCSourceControl <= "00";
                                        -- Calculate PC + 1
                                        ALUsrcAControl <= "01";                                      
                                        ALUsrcBControl <= "11";              
                                        tempOPControl <= "111"; 
                                    end if;
                                    -- Set next state
                                    current_cycle <= CC4;
                                    
                                when LOAD_ins =>
                                    -- Store ALU result ($rs + immediate) in ALUout register
                                    ALUoutRegisterWriteControl <= '1';
                                    -- Choose whether to read data from internal or external RAM 
                                    if ALUOut(7) = '1' then -- if result > 127
                                        -- Read from external RAM
                                        RDMUXControl <= '1';
                                    else  -- else result <= 127   
                                        -- Read from internal RAM
                                        RDMUXControl <= '0';
                                    end if;       
                                    -- Set the next state
                                    current_cycle <= CC4;
                                    
                                when STORE_ins =>
                                    -- Store ALU result ($rs + immediate) in ALUout register
                                    ALUoutRegisterWriteControl <= '1';
                                    -- Choose whether to read data from internal or external RAM 
                                    if ALUOut(7) = '1' then -- if result > 127
                                        -- Read from external RAM
                                        RDMUXControl <= '1';
                                    else  -- else result <= 127   
                                        -- Read from internal RAM
                                        RDMUXControl <= '0';
                                    end if;      
                                    -- Choose whether to store $rt in internal or external RAM
                                    if ALUOut(7) = '1' then -- if result > 127
                                        -- Store $rt in external RAM
                                        IORAMEnableControl <= '1';  
                                    else -- else result <= 127   
                                        -- Store $rt in internal RAM
                                        RAMEnableControl <= '1';                                   
                                    end if;                                
                                    -- Set the next state
                                    current_cycle <= CC4;
                                    
                                    
                                when others => -- Will be no others 
                            
                            end case;
                        
                        when others => -- Shouldnt get here 
                        
                    end case;
                              
                when CC4 =>
                    case current_instruction_type is
                        when R_TYPE =>                          
                            -- Write ALU result to register
                            RegWriteControl <= '1';
                            -- Update PC
                            PCWriteControl <= '1';
                            -- Set ALU to calculate PC + 1 
                            ALUsrcAControl <= "01";                                      
                            ALUsrcBControl <= "11";              
                            tempOPControl <= "111"; 
                            -- Set next state
                            current_cycle <= CC1;  
                            
                        when I_TYPE => 
                        
                            case current_instruction is
                            
                                when LOAD_ins => -- MDR <- mem[ALUout]    
                                    -- Store RAM data in Memory Data Register
                                    MDRRegisterWriteControl <= '1';
                                    -- Select data to write to rt in next cycle
                                    WDSelectControl <= "10";
                                    -- Select rt as destination register
                                    RegDestControl <= '1';                               
                                    -- Set next state
                                    current_cycle <= CC5; 
                                    
                                when STORE_ins =>
                                    -- Update PC
                                    PCWriteControl <= '1';
                                    -- Set ALU to calculate PC + 1 
                                    ALUsrcAControl <= "01";                                      
                                    ALUsrcBControl <= "11";            
                                    tempOPControl <= "111";   
                                    -- Set next state
                                    current_cycle <= CC1;
                                 
                                when BNE_ins | BEQ_ins => 
                                    
                                --    PCHoldWriteControl <= '1'; 
                                 --    PCSourceControl <= "00";
                                 
                                    -- Update PC 
                                    PCWriteControl <= '1';                     
                                    -- Set next state
                                    current_cycle <= CC1; 
                                    
                                when others => -- will be no others
                                    
                            end case;
                          
                        when others => -- Nothing should get here
                        
                    end case;
                    
                when CC5 => -- Only load instruction will get here
                    
                    if current_instruction = LOAD_ins then
                        -- Write data to rt
                        RegWriteControl <= '1';
                        -- Update PC
                        PCWriteControl <= '1';                  
                        -- Set ALU to calculate PC + 1 
                        ALUsrcAControl <= "01";                                      
                        ALUsrcBControl <= "11";              
                        tempOPControl <= "111";                                                                             
                    else
                    --    PCHoldWriteControl <= '0'; 
                    --    PCWriteControl <= '1';                             
                    end if;
                    
                    -- Set next state
                    current_cycle <= CC1;  
                    
                         
                                                                                            
                when others => -- Nothing should get here
                          
            end case;

        end if;
        
    end process;
    
    OPControl <= tempOPControl;
    

end Behavioral;
