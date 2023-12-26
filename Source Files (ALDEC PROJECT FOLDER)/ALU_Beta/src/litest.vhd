library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ALU is
    Port (
        -- Inputs
        rs1 : in std_logic_vector(127 downto 0);
        rs2 : in std_logic_vector(127 downto 0);
        rs3 : in std_logic_vector(127 downto 0);
        OpCode : in std_logic_vector(24 downto 0);
        
        -- Output
        rd : out std_logic_vector(127 downto 0)
    );
end entity ALU;







architecture behavioral of ALU is 
begin 
--process is based on ANY CHANGE of the Input Vectors, which needs to account for the case that R1,R2,R3 dont change , and the op code changes, or none but one of each or any change.
process (rs1, rs2, rs3, OpCode)	   

--LI VARIABLES________________________________________________________________________________________________
variable LI_TEMP_VAL : std_logic_vector(127 downto 0); -- Temporary variable to hold the calculation
variable LI_START_REPLACE_BT, LI_endd_REPLACE_BT : natural := 0; -- Variables to specify the range (x downto y) for insertion by LOADINDEX VALUE

--R4 VARIABLES________________________________________________________________________________________________	
	variable SIMALwS_mult1, SIMALwS_mult2, SIMALwS_mult3, SIMALwS_mult4: signed(31 downto 0);
    variable SIMALwS_add1, SIMALwS_add2, SIMALwS_add3, SIMALwS_add4: signed(31 downto 0);
    variable SIMALwS_temp_result: signed(127 downto 0);


--R3 VARIABLES________________________________________________________________________________________________
	variable AU_unsigned_add1, AU_unsigned_add2, AU_unsigned_add3, AU_unsigned_add4: unsigned(31 downto 0);
    variable AU_temp_result: signed(127 downto 0);
	
begin	

	
-- __________________________________________________________________________________________________________________________________	
	
	--LI Check and Arithmetic:	
 if OpCode(24) = '0' then
	  -- save input value ( How the hell do we know where the data from RD is coming from? input 1 or 2 or 3? Data forqwarding? )
    LI_TEMP_VAL := rs1; 
	-- start and end insertion values
	 LI_START_REPLACE_BT := 16 * (to_integer(unsigned(OpCode(23 downto 21))));
	 LI_endd_REPLACE_BT := 16+ (16 * (to_integer(unsigned(OpCode(23 downto 21)))));
    
    -- Step 2: Modify the specified range in Temp using OpCode (20 downto 5)
    LI_TEMP_VAL(LI_START_REPLACE_BT downto LI_endd_REPLACE_BT) := OpCode(20 downto 5);
    
    -- Step 3: Assign Temp to the rd output
    rd <= LI_TEMP_VAL;
	 --rest of operation.
end if;	 
-- __________________________________________________________________________________________________________________________________




		 end process;
	
end architecture behavioral;