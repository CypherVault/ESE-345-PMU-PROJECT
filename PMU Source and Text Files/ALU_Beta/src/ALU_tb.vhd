library IEEE;
use IEEE.std_logic_1164.all;  
use std.textio.all;	
			
use ieee.numeric_std.all;

use work.all;	 
					
entity ALU_TestBench is
end ALU_TestBench;

architecture testbench of ALU_TestBench is
	signal rs1, rs2, rs3: std_logic_vector(127 downto 0);	   
	signal OpCode: std_logic_vector(24 downto 0);
	signal rd: std_logic_vector(127 downto 0);
begin
    -- Instantiate the ALU
    ALU_Instance: entity work.ALU
        port map (
            rs1 => rs1,
            rs2 => rs2,
            rs3 => rs3,
            OpCode => OpCode,
            rd => rd
        );

    -- Stimulus process
    process					
	variable rd_unsigned: unsigned(127 downto 0);
    begin											  
		
		
		 --Signed Integer Multiply-Add Low with Saturation test
        -- Set input values and OpCode (change these values as needed)
      -- Set input values and OpCode (128-bit wide, change these values as needed)	  
  	   rs1 <= "10000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000";
       rs2 <= "00000000000000000111111111111111000000000000000001111111111111110000000000000000011111111111111100000000000000000111111111111111";
       rs3 <= "00000000000000000111111111111111000000000000000001111111111111110000000000000000011111111111111100000000000000000111111111111111";		
       OpCode <= "1001000000000000000000000";




    -- OpCode <= "11XXXX[0001]000000000000000";


 -- Set your OpCode value here (25 bits wide)
        
        -- Wait for some time (adjust the time based on your design requirements)
        wait for 10 ns;
        
         -- Convert rd to unsigned and report the output directly to the console
       
   		report "Result: " & integer'image(to_integer(unsigned(rd)));
   
		
		
			   
        -- Stop the simulation				   
		
        wait;
    end process;
end testbench;
