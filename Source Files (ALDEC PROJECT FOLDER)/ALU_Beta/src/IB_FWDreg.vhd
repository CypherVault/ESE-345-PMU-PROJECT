

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.ALL;		   


---------------------------IB_FWDreg

entity IB_FWDreg is
 
  port (
   clk        : in std_logic;
   reset_bar  : in std_logic; 
  
  --IB_rs1   : in STD_LOGIC_VECTOR(127 downto 0);	
--  IB_rs2   : in STD_LOGIC_VECTOR(127 downto 0);
--  IB_rs3   : in STD_LOGIC_VECTOR(127 downto 0);
--  
IB_opcode : in STD_LOGIC_VECTOR(24 downto 0);	 
Valid_Instruction_In: in std_logic;
Valid_Instruction_Out: out std_logic;
  
 -- IBfwd_rs1  : out STD_LOGIC_VECTOR(127 downto 0);
--  IBfwd_rs2  : out STD_LOGIC_VECTOR(127 downto 0);
--  IBfwd_rs3  : out STD_LOGIC_VECTOR(127 downto 0);
--  
  IBfwd_opcode: out STD_LOGIC_VECTOR(24 downto 0)
  
  );		
  
  
end entity IB_FWDreg;

architecture Behavioral of IB_FWDreg is	  

--VARIABLE for holding WHAT the previous inputt on the port in was. 
	
	--signal IB_rs1_previous :  STD_LOGIC_VECTOR(127 downto 0);
--	signal IB_rs2_previous :  STD_LOGIC_VECTOR(127 downto 0);
--	signal IB_rs3_previous :  STD_LOGIC_VECTOR(127 downto 0);
	---signal IB_opcode_previous :  STD_LOGIC_VECTOR(24 downto 0);
	
	

begin
	
	
	
	
 process(clk, reset_bar)											 
  begin
    if reset_bar = '0' then
      
		--IBfwd_rs1 <= (others => '0');	
--		IBfwd_rs2 <= (others => '0');
--		IBfwd_rs3 <= (others => '0');
		IBfwd_opcode <= (others => '0');
--		IB_rs1_previous <=  (others => '0');
--		IB_rs2_previous <=  (others => '0');
--		IB_rs3_previous <=  (others => '0');
	--	IB_opcode_previous <=  (others => '0');
		
		
		
    elsif (clk = '1') then
		
		
		if 	(Valid_Instruction_In = '1' ) then
		--IBfwd_rs1 <= IB_rs1_previous; 
--		IBfwd_rs2 <= IB_rs2_previous;
--		IBfwd_rs3 <= IB_rs3_previous;
		IBfwd_opcode <= IB_opcode;	 
		Valid_Instruction_Out <= '1';
		--IB_rs1_previous <= IB_rs1;
--		IB_rs2_previous <= IB_rs2;
	--	IB_opcode_previous <= IB_opcode;
		else 
		IBfwd_opcode <= (others => '0');
		Valid_Instruction_Out <= '0';	
		end if;
		

    end if;
  end process;	
	
	
	
	
end architecture Behavioral;



			  