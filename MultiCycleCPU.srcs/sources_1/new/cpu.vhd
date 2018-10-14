----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2018 12:54:19
-- Design Name: 
-- Module Name: cpu - Behavioral
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

entity cpu is
PORT(
      clk : IN  std_logic;
      IOaddress : OUT  std_logic_vector(6 downto 0);
      IOread : IN  std_logic_vector(7 downto 0);
      IOwrite : OUT  std_logic_vector(7 downto 0);
      IOwrite_enable : OUT  std_logic
     );
end cpu;

architecture Behavioral of cpu is

-- Component Connecting Signals
signal PCout2IR : std_logic_vector (9 downto 0);
signal MUX2PCin : std_logic_vector (9 downto 0);
signal IRout : std_logic_vector (19 downto 0);
signal WRin : std_logic_vector (2 downto 0);
signal WDin : std_logic_vector (7 downto 0);
signal RD1out : std_logic_vector (7 downto 0);
signal RD2out : std_logic_vector (7 downto 0);
signal Aout : std_logic_vector (7 downto 0);
signal Bout : std_logic_vector (7 downto 0);
signal ALUinA : std_logic_vector (7 downto 0);
signal ALUinB : std_logic_vector (7 downto 0);
signal ALUresult : std_logic_vector (7 downto 0);
signal ALURegOut : std_logic_vector (7 downto 0);
signal AdderCin : std_logic;
signal AdderOut : std_logic_vector(1 downto 0);
signal zero : std_logic_vector(1 downto 0) := "00";
signal AdderSRCB : std_logic_vector(1 downto 0) := "00";
signal concatPC : std_logic_vector (9 downto 0);
signal ALUZeroFlag : std_logic;
signal RAMRDout : std_logic_vector (7 downto 0);
signal MDRin : std_logic_vector (7 downto 0);
signal MDRout : std_logic_vector (7 downto 0);
signal SEout : std_logic_vector (9 downto 0);
signal PCHoldout : std_logic_vector (9 downto 0);



-- Control Signals
signal PCWriteControl : std_logic;
signal InstructionReadControl : std_logic := '0';
signal RegDestControl : std_logic;
signal RegWriteControl : std_logic;
signal ALUsrcAControl : std_logic_vector (1 downto 0) := "01"; -- initilised for PC + 1 on first cycle
signal ALUsrcBControl : std_logic_vector (1 downto 0);
signal OPControl : std_logic_vector (2 downto 0) := "111"; -- initilised for PC + 1 on first cycle
signal WDSelectControl : std_logic_vector (1 downto 0);
signal PCSelectControl : std_logic_vector (1 downto 0);
signal RAMEnableControl : std_logic;
signal IORAMEnableControl : std_logic;
signal RDMUXControl : std_logic;
signal PCHoldControl : std_logic;
signal ARegisterWriteControl : std_logic;
signal BRegisterWriteControl : std_logic;
signal ALUoutRegisterWriteControl : std_logic;
signal MDRRegisterWriteControl : std_logic;

-- Component Declarations

component Control 
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
          -- ConcatPC : out STD_LOGIC_VECTOR (9 downto 0)
           );
end component;

component PC 
    Port ( PCWrite : in STD_LOGIC;
           PCin : in STD_LOGIC_VECTOR (9 downto 0);
           PCout : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component ALU 
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           s : out STD_LOGIC_VECTOR (7 downto 0);
           opcode : in STD_LOGIC_VECTOR(2 downto 0); 
           overflow : out STD_LOGIC;
           zero : out STD_LOGIC);
end component;

component Adder 
    Port ( cin : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (1 downto 0);
           b : in STD_LOGIC_VECTOR (1 downto 0);
           output : out STD_LOGIC_VECTOR (1 downto 0));
end component;

component SignExtend
    Port ( Input : in STD_LOGIC_VECTOR (7 downto 0);
           Output : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component DataMemory 
    Port ( Address : in STD_LOGIC_VECTOR (7 downto 0);
           WD : in STD_LOGIC_VECTOR (7 downto 0);
           RD : out STD_LOGIC_VECTOR (7 downto 0);
           MemWrite : in STD_LOGIC);
end component;

component InstructionMemory 
    Port ( PC : in STD_LOGIC_VECTOR (9 downto 0);
           InstructionRead : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR (19 downto 0));
end component;

component Registers 
    Port ( RR1 : in STD_LOGIC_VECTOR (2 downto 0);
           RR2 : in STD_LOGIC_VECTOR (2 downto 0);
           WR : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (7 downto 0);
           RD1 : out STD_LOGIC_VECTOR (7 downto 0);
           RD2 : out STD_LOGIC_VECTOR (7 downto 0);
           RegWrite : in STD_LOGIC);
end component;

component AB_Register 
    Port ( RegisterWriteControl : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (7 downto 0);
           DataOut : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component ALUoutRegister 
    Port ( RegisterWriteControl : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (7 downto 0);
           DataOut : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component MemoryDataRegister 
    Port ( RegisterWriteControl : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (7 downto 0);
           DataOut : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component PCHold_Register is
    Port ( PCHoldControl : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (9 downto 0);
           DataOut : out STD_LOGIC_VECTOR (9 downto 0));
end component;

------------------------------------- MUX's -----------------------------------------

component RegDest_MUX 
    Port ( In1 : in STD_LOGIC_VECTOR (2 downto 0);
           In2 : in STD_LOGIC_VECTOR (2 downto 0);
           Output : out STD_LOGIC_VECTOR (2 downto 0);
           RegDest : in STD_LOGIC);
end component;

component ALU_SRC_MUX 
    Port ( In1 : in STD_LOGIC_VECTOR (7 downto 0);
           In2 : in STD_LOGIC_VECTOR (7 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0);
           SRC_Select : in STD_LOGIC_VECTOR (1 downto 0));
end component;

component WD_MUX 
    Port ( In1 : in STD_LOGIC_VECTOR (7 downto 0);
           In2 : in STD_LOGIC_VECTOR (7 downto 0);
           In3 : in STD_LOGIC_VECTOR (7 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0);
           SRC_Select : in STD_LOGIC_VECTOR (1 downto 0));
end component;

component PC_MUX 
    Port ( In1 : in STD_LOGIC_VECTOR (9 downto 0);
           In2 : in STD_LOGIC_VECTOR (9 downto 0);
           In3 : in STD_LOGIC_VECTOR (9 downto 0);
           Output : out STD_LOGIC_VECTOR (9 downto 0);
           PCSelect : in STD_LOGIC_VECTOR (1 downto 0));
end component;

component RAM_MUX 
    Port ( In1 : in STD_LOGIC_VECTOR (7 downto 0);
           In2 : in STD_LOGIC_VECTOR (7 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0);
           RDSelect : in STD_LOGIC);
end component;



begin

-- Component Instantiation

   ProgramCounter_INS : PC PORT MAP ( PCWrite => PCWriteControl, 
                                      PCin => MUX2PCin, 
                                      PCout => PCout2IR);
                                      
   InstructionMemory_INS : InstructionMemory PORT MAP ( PC => PCout2IR, 
                                                        InstructionRead => InstructionReadControl, 
                                                        Instruction => IRout);
                                                       
   Registers_INS : Registers PORT MAP ( RR1 => IRout(13 downto 11), 
                                        RR2 => IRout(10 downto 8), 
                                        WR => WRin,
                                        WD => WDin, 
                                        RD1 => RD1out, 
                                        RD2 => RD2out, 
                                        RegWrite => RegWriteControl);
   
   RegDestMUX_INS : RegDest_MUX  PORT MAP ( In1 => IRout(10 downto 8), 
                                            In2 => IRout(7 downto 5), 
                                            Output => WRin, 
                                            RegDest => RegDestControl);
                                            
   A_INS : AB_Register PORT MAP ( RegisterWriteControl => ARegisterWriteControl,
                                  DataIn => RD1out,
                                  DataOut => Aout);
                                  
   B_INS : AB_Register PORT MAP ( RegisterWriteControl => BRegisterWriteControl,
                                  DataIn => RD2out,
                                  DataOut => Bout);
                                  
   ALUsrcAMUX_INS : ALU_SRC_MUX PORT MAP ( In1 => PCout2IR(7 downto 0),
                                           In2 => Aout, 
                                           Output => ALUinA,
                                           SRC_Select => ALUsrcAControl);
                                           
   ALUsrcBMUX_INS : ALU_SRC_MUX PORT MAP ( In1 => Bout,
                                           In2 => IRout(7 downto 0), 
                                           Output => ALUinB,
                                           SRC_Select => ALUsrcBControl);
                                           
   ALU_INS : ALU PORT MAP ( a => ALUinA,
                            b => ALUinB,
                            s => ALUresult,
                            opcode => OPControl,
                            overflow => AdderCin,
                            zero => ALUZeroFlag); 
                            
   Adder_INS : Adder PORT MAP ( cin => AdderCin,
                                a => PCout2IR(9 downto 8), -- 2 MSB's of PC
                                b => AdderSRCB,                
                                output => AdderOut);
                            
   WD_MUX_INS : WD_MUX PORT MAP (In1 => IRout(7 downto 0),
                                 In2 => ALURegOut,
                                 In3 => MDRout,
                                 Output => WDin,
                                 SRC_Select => WDSelectControl);
                                 
   ALUoutRegister_INS : ALUoutRegister PORT MAP( RegisterWriteControl => ALUoutRegisterWriteControl,
                                                 DataIn => ALUresult,
                                                 DataOut => ALURegOut);
                                                 
   SignExtend_INS : SignExtend PORT MAP ( Input => IRout(7 downto 0),
                                          Output => SEout);
                                                  
   PC_MUX_INS : PC_MUX PORT MAP ( In1 => PCHoldout,          -- PC + 1
                                  In2 => IRout(13 downto 4), -- Jump Target
                                  In3 => concatPC,           -- PC + immediate
                                  Output => MUX2PCin, 
                                  PCSelect => PCSelectControl);
                                  
   DataMemory_INS : DataMemory PORT MAP ( Address => ALURegOut, 
                                          WD => Bout,
                                          RD => RAMRDout,
                                          MemWrite => RAMEnableControl);
                                          
   RAM_MUX_INS : RAM_MUX PORT MAP ( In1 => RAMRDout,
                                    In2 => IOread, -- might have to store in intermediate signal
                                    Output => MDRin,
                                    RDSelect => RDMUXControl);
                                    
   MDR_INS : MemoryDataRegister PORT MAP ( RegisterWriteControl => MDRRegisterWriteControl, 
                                           DataIn => MDRin, 
                                           DataOut => MDRout);
                                           
   PCHoldRegister_INS : PCHold_Register PORT MAP ( PCHoldControl => PCHoldControl,
                                                   DataIn => concatPC,
                                                   DataOut => PCHoldout);
                                                   
   Control_INS : Control PORT MAP ( ALUOut => ALUresult,
                                    AdderOut => Adderout,
                                    OPCode => IRout(19 downto 14),
                                    Funct => IRout(4 downto 2),
                                    ALUZeroFlag => ALUZeroFlag,
                                    clk => clk,
                                    PCWriteControl => PCWriteControl,
                                    InstructionReadControl => InstructionReadControl,
                                    RegDestControl => RegDestControl,
                                    RegWriteControl => RegWriteControl,
                                    WDSelectControl => WDSelectControl,
                                    ALUsrcAControl => ALUsrcAControl,
                                    ALUsrcBControl => ALUsrcBControl,
                                    OPControl => OPControl,
                                    PCSourceControl => PCSelectControl,
                                    IORAMEnableControl => IORAMEnableControl,
                                    RAMEnableControl => RAMEnableControl,
                                    RDMUXControl => RDMUXControl,
                                    PCHoldWriteControl => PCHoldControl,
                                    ARegisterWriteControl => ARegisterWriteControl,
                                    BRegisterWriteControl => BRegisterWriteControl,
                                    ALUoutRegisterWriteControl => ALUoutRegisterWriteControl,
                                    MDRRegisterWriteControl => MDRRegisterWriteControl
                                    --ConcatPC => concatPC
                                    );
                                                                           
   -- Calculate concatenation of signals
   concatPC <= AdderOut & ALUresult; -- Concatenate PC 2 MSB's with 8 LSB's 
   
   
   -- Input into source B of adder for correct addition of 2's comp numbers
   AdderSRCB <= ALUinB(7) & ALUinB(7);
   --AdderSRCB <= PCout2IR(9) & PCout2IR(9);

   -- Connect IORAM
   IOwrite <= Bout;
   IOaddress <= ALURegOut(6 downto 0);
   IOwrite_enable <= IORAMEnableControl;
   

end Behavioral;
