library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.ALL;		   


---------------------------EX_WBreg

entity EX_WBreg is
 
  port (
   clk        : in std_logic;
    reset_bar  : in std_logic; 
  
  alu_rddata_in   : in STD_LOGIC_VECTOR(127 downto 0);	
  alu_opcodedata_in : in STD_LOGIC_VECTOR(24 downto 0);
  
  alu_rddata_out  : out STD_LOGIC_VECTOR(127 downto 0);
  Valid_Instruction_In: in std_logic;
Valid_Instruction_Out: out std_logic;
Valid_Instruction_Out_FWD: out std_logic;
  write_enable     : out std_logic;
  alu_opcodedata_out: out STD_LOGIC_VECTOR(24 downto 0)
  
  );		    
  
  
end entity EX_WBreg;

architecture Behavioral of EX_WBreg is	 

signal ALU_rd_previous :  STD_LOGIC_VECTOR(127 downto 0) :=  (others => '0');
signal ALU_opcode_previous :  STD_LOGIC_VECTOR(24 downto 0) :=  (others => '0'); 

begin
	
	
 process(clk, reset_bar, Valid_Instruction_In, alu_opcodedata_in, alu_rddata_in)
  begin
    if reset_bar = '0' then
      
		alu_rddata_out <= (others => '0');
		alu_opcodedata_out <= (others => '0');
		--ALU_rd_previous <=  (others => '0');
		--ALU_opcode_previous <=  (others => '0'); 	  
		
		
		
    elsif (clk = '1') then
		
		 if (Valid_Instruction_In ='1') then 
		
			 Valid_Instruction_Out <= '1';
			 Valid_Instruction_Out_FWD <= '1';
			 if not (alu_rddata_in(127) = 'U' or alu_opcodedata_in(24) = 'U') then
  alu_rddata_out <= alu_rddata_in;
  alu_opcodedata_out <= alu_opcodedata_in;
  write_enable <= '1';
  
  			else
	  
  
			end if;
			
			else 
		   
				Valid_Instruction_Out <= '0';	
		
			end if;	

		
		--ALU_rd_previous <= 	 alu_rddata_in;
		--ALU_opcode_previous	<= 	 alu_opcodedata_in;	
		
	elsif  (clk = '0') then
		   

		write_enable <= '0';
		
	else
		null;
		
		
		
    end if;
	
if (Valid_Instruction_In = '0') then	
			 
			 Valid_Instruction_Out <= '0';
			 
		  else
		  end if;	
	
	
  end process;	
	
	
	
end architecture Behavioral;


		   