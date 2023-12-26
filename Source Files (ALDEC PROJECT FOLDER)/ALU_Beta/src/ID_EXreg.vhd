

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.ALL;		   


---------------------------ID_EXreg

entity ID_EXreg is
 
  port (
   clk        : in std_logic;
   reset_bar  : in std_logic; 
  
  RF_rs1   : in STD_LOGIC_VECTOR(127 downto 0);	
  RF_rs2   : in STD_LOGIC_VECTOR(127 downto 0);
  RF_rs3   : in STD_LOGIC_VECTOR(127 downto 0);
  
  RF_opcode : in STD_LOGIC_VECTOR(24 downto 0);
  
  IDfwd_rs1  : out STD_LOGIC_VECTOR(127 downto 0);
  IDfwd_rs2  : out STD_LOGIC_VECTOR(127 downto 0);
  IDfwd_rs3  : out STD_LOGIC_VECTOR(127 downto 0);
  Valid_Instruction_In: in std_logic;
  Valid_Instruction_Out: out std_logic;
  
  IDfwd_opcode: out STD_LOGIC_VECTOR(24 downto 0)
  
  );		
  
  
end entity ID_EXreg;

architecture Behavioral of ID_EXreg is	  

--VARIABLE for holding WHAT the previous inputt on the port in was. 
	
	signal RF_rs1_previous :  STD_LOGIC_VECTOR(127 downto 0);
	signal RF_rs2_previous :  STD_LOGIC_VECTOR(127 downto 0) ;
	signal RF_rs3_previous :  STD_LOGIC_VECTOR(127 downto 0) ;
	signal RF_opcode_previous :  STD_LOGIC_VECTOR(24 downto 0);
	
	

begin
	
	
	
	
 process(clk, reset_bar)											 
  begin
     if reset_bar = '0' then
      
		IDfwd_rs1 <= (others => '0');	
		IDfwd_rs2 <= (others => '0');
		IDfwd_rs3 <= (others => '0');
		IDfwd_opcode <= (others => '0');
		RF_rs1_previous <=  (others => '0');
		RF_rs2_previous <=  (others => '0');
		RF_rs3_previous <=  (others => '0');
		RF_opcode_previous <=  (others => '0');
		
		
		
    elsif (clk = '1') then
		
		
		if (Valid_Instruction_In ='1') then 
		IDfwd_rs1 <= RF_rs1; 
		IDfwd_rs2 <= RF_rs2;
		IDfwd_rs3 <= RF_rs3;
		IDfwd_opcode <= RF_opcode;	
		Valid_Instruction_Out <= '1';
	--	
--		RF_rs1_previous <= RF_rs1;
--		RF_rs2_previous <= RF_rs2;
--		RF_rs3_previous <= RF_rs3;
--	    RF_opcode_previous <= RF_opcode;		
--		
		else 
		   
				Valid_Instruction_Out <= '0';	
		
			end if;

    end if;
  end process;	
	
	
	
	
end architecture Behavioral;

