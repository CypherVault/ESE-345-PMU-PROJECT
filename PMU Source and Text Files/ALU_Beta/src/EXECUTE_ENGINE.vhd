library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.ALL;

entity EXECUTE_ENGINE is
  port (
    clk        : in std_logic;
    reset_bar  : in std_logic; 
	
	EXin_rs1      : in STD_LOGIC_VECTOR(127 downto 0);
    EXin_rs2      : in STD_LOGIC_VECTOR(127 downto 0);
    EXin_rs3      : in STD_LOGIC_VECTOR(127 downto 0); 
	EXin_opcode   : in STD_LOGIC_VECTOR(24 downto 0);
	rd_fwd        : in STD_LOGIC_VECTOR(127 downto 0); 
	opcode_fwd    : in STD_LOGIC_VECTOR(24 downto 0);	
	Valid_Instruction_In: in std_logic;
	Valid_Instruction_In_FWD: in std_logic;
	Valid_Instruction_Out: out std_logic;
	
	EXout_rs1      : out STD_LOGIC_VECTOR(127 downto 0);
    EXout_rs2      : out STD_LOGIC_VECTOR(127 downto 0);
    EXout_rs3      : out STD_LOGIC_VECTOR(127 downto 0);
	
	EXout_opcode   : out STD_LOGIC_VECTOR(24 downto 0)
	
	
	
	
    --rd           : out STD_LOGIC_VECTOR(127 downto 0);
	--EXout_opcode   : out STD_LOGIC_VECTOR(24 downto 0)
	
	
	
  );
end entity EXECUTE_ENGINE;

architecture behavioral of EXECUTE_ENGINE is 

--signals	
SIGNAL rs1_alu    : std_logic_vector(127 DOWNTO 0);	
SIGNAL rs2_alu    : std_logic_vector(127 DOWNTO 0);

SIGNAL opcode    : std_logic_vector(24 DOWNTO 0);

begin
	 
process(EXin_rs1, EXin_rs2, EXin_rs3, EXin_opcode, Valid_Instruction_In, rd_fwd ,opcode_fwd , Valid_Instruction_In_FWD   )	--opcode_fwd, rd_fwd  
	
	
variable forward_index: std_logic_vector(4 downto 0); 
variable forward_int : integer;

	
  begin
    if reset_bar = '0' then
      
		
		--reset action

    else 

		if (Valid_Instruction_In ='1') then 
			
			if not ( opcode_fwd = EXin_opcode ) then

--LI HAZARDS		
if EXin_opcode(24) = '0' then  
	
	forward_index := opcode_fwd(4 downto 0);
		
	
if ( (Valid_Instruction_In_FWD = '1') and (forward_index = EXin_opcode(4 downto 0))) then
  
	EXout_rs1 <= rd_fwd(127 downto 0);
	EXout_rs2 <= EXin_rs2(127 downto 0);
	EXout_rs3 <= EXin_rs3(127 downto 0);
	EXout_opcode <= EXin_opcode(24 downto 0);	
	
else 	
	   
		
		EXout_rs1 <= EXin_rs1(127 downto 0);  	
		EXout_rs2 <= EXin_rs2(127 downto 0);
		EXout_rs3 <= EXin_rs3(127 downto 0);
		EXout_opcode <= EXin_opcode(24 downto 0);
		
end if;

	
		
end if;	--LI END   



--R4 HAZARDS
if EXin_opcode(24 downto 23) = "10" then
	
	  forward_index := opcode_fwd(4 downto 0);
	  
	  
if (Valid_Instruction_In_FWD = '1') and (forward_index = EXin_opcode(19 downto 15)) then
	
		EXout_rs1 <= EXin_rs1(127 downto 0);
		EXout_rs2 <= EXin_rs2(127 downto 0);
		EXout_rs3 <= rd_fwd(127 downto 0);
	   	EXout_opcode <= EXin_opcode(24 downto 0);	
		  
		
elsif (Valid_Instruction_In_FWD = '1') and (forward_index = EXin_opcode(14 downto 10)) then
	
		EXout_rs1 <= EXin_rs1(127 downto 0);
		EXout_rs2 <= rd_fwd(127 downto 0);
		EXout_rs3 <= EXin_rs3(127 downto 0);
	   	EXout_opcode <= EXin_opcode(24 downto 0); 
		 	
		
elsif (Valid_Instruction_In_FWD = '1') and (forward_index = EXin_opcode(9 downto 5)) then
  
		EXout_rs1 <= rd_fwd(127 downto 0);
		EXout_rs2 <= EXin_rs2(127 downto 0);
		EXout_rs3 <= EXin_rs3(127 downto 0);
		EXout_opcode <= EXin_opcode(24 downto 0);	
			
else
  
	 
		EXout_rs1 <= EXin_rs1(127 downto 0);
		EXout_rs2 <= EXin_rs2(127 downto 0);
		EXout_rs3 <= EXin_rs3(127 downto 0);
		EXout_opcode <= EXin_opcode(24 downto 0);	  
		
	
end if;  -- hazard check end
	  
	  
	
end if;	-- R4 END		   


--R3 HAZARDS
if EXin_opcode(24 downto 23) = "11" then
	
	  forward_index := opcode_fwd(4 downto 0);
	  
	  
if (Valid_Instruction_In_FWD = '1') and (forward_index = EXin_opcode(14 downto 10)) then
	
		EXout_rs1 <= EXin_rs1(127 downto 0);
		EXout_rs2 <= rd_fwd(127 downto 0);
		EXout_rs3 <= EXin_rs3(127 downto 0);
		EXout_opcode <= EXin_opcode(24 downto 0);	
		
		
elsif (Valid_Instruction_In_FWD = '1') and (forward_index = EXin_opcode(9 downto 5)) then
  
		EXout_rs1 <= rd_fwd(127 downto 0);
		EXout_rs2 <= EXin_rs2(127 downto 0);
		EXout_rs3 <= EXin_rs3(127 downto 0);
		EXout_opcode <= EXin_opcode(24 downto 0); 
	
else
  
	 
		EXout_rs1 <= EXin_rs1(127 downto 0);
		EXout_rs2 <= EXin_rs2(127 downto 0);
		EXout_rs3 <= EXin_rs3(127 downto 0);
		EXout_opcode <= EXin_opcode(24 downto 0);
		
	
end if;  -- hazard check end
	
end if;	-- R3 END

EXout_opcode <= EXin_opcode   ;	
Valid_Instruction_Out <= '1';


else 
	
end if;

		else 
		   
				Valid_Instruction_Out <= '0';	
		
			end if;
	
end if;	 
		
	   


 end process;
	
 
 
  
  
end architecture behavioral;
