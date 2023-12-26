---chris nielsen and uma s 345 VHDL ALU project stage 1


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
		
		Valid_Instruction_In: in std_logic;
Valid_Instruction_Out: out std_logic;
		
        -- Output
        rd : out std_logic_vector(127 downto 0);
		alu_opcode : out std_logic_vector(24 downto 0);
		rd1 : out std_logic_vector(127 downto 0)
		
		);	
		
end entity ALU;






		 
architecture behavioral of ALU is

constant compare_low: std_logic_vector(63 downto 0) := "1000000000000000000000000000000000000000000000000000000000000000";
constant compare_high: std_logic_vector(63 downto 0) := "0111111111111111111111111111111111111111111111111111111111111111"; 
  
  

begin 
	
--process is based on ANY CHANGE of the Input Vectors, which needs to account for the case that R1,R2,R3 dont change , and the op code changes, or none but one of each or any change.
process (rs1, rs2, rs3, OpCode, Valid_Instruction_In )	   



--LI VARIABLES________________________________________________________________________________________________
variable LI_TEMP_VAL : std_logic_vector(127 downto 0); -- Temporary variable to hold the calculation
variable LI_START_REPLACE_BT, LI_endd_REPLACE_BT : natural := 0; -- Variables to specify the range (x downto y) for insertion by LOADINDEX VALUE  
variable immediate : std_logic_vector(15 downto 0);

--R4 VARIABLES________________________________________________________________________________________________	

--first half of variables for 32 bit operations 
	variable R4_32_mult_1, R4_32_mult_2, R4_32_mult_3, R4_32_mult_4: signed(31 downto 0);
    variable R4_32_add_1, R4_32_add_2, R4_32_add_3, R4_32_add_4: signed(31 downto 0);  
	variable R4_32_sub_1, R4_32_sub_2, R4_32_sub_3, R4_32_sub_4: signed(31 downto 0);
	variable R4_32_mult_sat_1, R4_32_mult_sat_2, R4_32_mult_sat_3,R4_32_mult_sat_4, R4_32_add_sat_1, R4_32_add_sat_2, R4_32_add_sat_3, R4_32_add_sat_4 , R4_32_sub_sat_1, R4_32_sub_sat_2, R4_32_sub_sat_3, R4_32_sub_sat_4: integer;
	variable R4_temp_result: signed(127 downto 0);
	variable R4_overflow_test : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";	  
	variable r4_mult_sign_1,r4_mult_sign_2,r4_mult_sign_3,r4_mult_sign_4 : std_logic;
	
--second half of variables for 64 bit operations
	variable R4_64_mult_1, R4_64_mult_2, R4_64_mult_3, R4_64_mult_4: signed(63 downto 0);
    variable R4_64_add_1, R4_64_add_2, R4_64_add_3, R4_64_add_4: signed(63 downto 0);  
	variable R4_64_sub_1, R4_64_sub_2, R4_64_sub_3, R4_64_sub_4: signed(63 downto 0);
	variable R4_64_mult_sat_1, R4_64_mult_sat_2, R4_64_mult_sat_3,R4_64_mult_sat_4, R4_64_add_sat_1, R4_64_add_sat_2, R4_64_add_sat_3, R4_64_add_sat_4 , R4_64_sub_sat_1, R4_64_sub_sat_2, R4_64_sub_sat_3, R4_64_sub_sat_4: integer;	
	

--R3 VARIABLES________________________________________________________________________________________________
	variable AU_unsigned_add1, AU_unsigned_add2, AU_unsigned_add3, AU_unsigned_add4: unsigned(31 downto 0);
    variable AU_temp_result: std_logic_vector(127 downto 0); 
	
	variable shift_amount : integer;
    variable SHRHI_shifted_1,SHRHI_shifted_2,SHRHI_shifted_3,SHRHI_shifted_4,SHRHI_shifted_5,SHRHI_shifted_6,SHRHI_shifted_7,SHRHI_shifted_8 : std_logic_vector(15 downto 0);	
	
	variable CNTH_counter_1,CNTH_counter_2,CNTH_counter_3,CNTH_counter_4,CNTH_counter_5,CNTH_counter_6,CNTH_counter_7,CNTH_counter_8: integer := 0; 
	variable CNTH_index_contr : integer := 0;
	variable CNTH_counter_1_vector, CNTH_counter_2_vector, CNTH_counter_3_vector, CNTH_counter_4_vector, CNTH_counter_5_vector, CNTH_counter_6_vector, CNTH_counter_7_vector, CNTH_counter_8_vector : std_logic_vector(15 downto 0);
	
	
	variable R3_16_add_1: signed(15 downto 0);	  
	variable R3_16_add_2: signed(15 downto 0);
	variable R3_16_add_3: signed(15 downto 0);
	variable R3_16_add_4: signed(15 downto 0);
	variable R3_16_add_5: signed(15 downto 0);
	variable R3_16_add_6: signed(15 downto 0);
	variable R3_16_add_7: signed(15 downto 0);
	variable R3_16_add_8: signed(15 downto 0); 
	
	
	variable R3_16_sub_1: signed(15 downto 0);	  
	variable R3_16_sub_2: signed(15 downto 0);
	variable R3_16_sub_3: signed(15 downto 0);
	variable R3_16_sub_4: signed(15 downto 0);
	variable R3_16_sub_5: signed(15 downto 0);
	variable R3_16_sub_6: signed(15 downto 0);
	variable R3_16_sub_7: signed(15 downto 0);
	variable R3_16_sub_8: signed(15 downto 0); 	
	
	variable R3_32_sub_1: unsigned(31 downto 0);
	variable R3_32_sub_2: unsigned(31 downto 0);
	variable R3_32_sub_3: unsigned(31 downto 0);
	variable R3_32_sub_4: unsigned(31 downto 0);	 
	
	
	variable R3_16_add_sat_1,R3_16_add_sat_2,R3_16_add_sat_3,R3_16_add_sat_4,R3_16_add_sat_5,R3_16_add_sat_6,R3_16_add_sat_7,R3_16_add_sat_8 : integer;
	variable R3_16_sub_sat_1,R3_16_sub_sat_2,R3_16_sub_sat_3,R3_16_sub_sat_4,R3_16_sub_sat_5,R3_16_sub_sat_6,R3_16_sub_sat_7,R3_16_sub_sat_8 : integer;	
	variable r3_mult_sign_1,r3_mult_sign_2,r3_mult_sign_3,r3_mult_sign_4,r3_mult_sign_5,r3_mult_sign_6,r3_mult_sign_7,r3_mult_sign_8 : std_logic;
	variable r3_add_sign_1,r3_add_sign_2,r3_add_sign_3,r3_add_sign_4,r3_add_sign_5,r3_add_sign_6,r3_add_sign_7,r3_add_sign_8 : std_logic; 
	variable  r3_sub_sign_1,r3_sub_sign_2,r3_sub_sign_3,r3_sub_sign_4,r3_sub_sign_5,r3_sub_sign_6,r3_sub_sign_7,r3_sub_sign_8 : std_logic;
	
	
	variable R3_temp_result: signed(127 downto 0);																													 
	
	variable MAXWS_larger_value, MAXWS_rs1, MAXWS_rs2 : integer;
	
	variable MINWS_smaller_value,MINWS_rs1, MINWS_rs2  : integer;	  
	
	variable R3_32_mult_1,R3_32_mult_2,R3_32_mult_3,R3_32_mult_4 : unsigned(31 downto 0);
	
	
	variable R3_16_mult_1,R3_16_mult_2,R3_16_mult_3,R3_16_mult_4,R3_16_mult_5, R3_16_mult_6, R3_16_mult_7, R3_16_mult_8: signed(15 downto 0);	
     variable R3_16_mult_sat_1, R3_16_mult_sat_2, R3_16_mult_sat_3,R3_16_mult_sat_4, R3_16_mult_sat_5,R3_16_mult_sat_6,R3_16_mult_sat_7,R3_16_mult_sat_8	: integer;		 
	
	variable rotate_amount : integer; 
	variable ROTW_rotated_1,ROTW_rotated_2,ROTW_rotated_3,ROTW_rotated_4 : std_logic_vector(31 downto 0); 
	variable temp_rotated_out : std_logic_vector(31 downto 0);
	
	variable sign_before, sign_after: std_logic;
	
begin	


alu_opcode <= opcode;	
	
		

-- __________________________________________________________________________________________________________________________________	


	if (Valid_Instruction_In = '0') then	
			 
			 Valid_Instruction_Out <= '0';
			 
		  else
		  end if; 


if (Valid_Instruction_In ='1') then 
	
	 Valid_Instruction_Out <= '1';
	
	--LI Check and Arithmetic:	
 if OpCode(24) = '0' then
	  -- save input value ( How the hell do we know where the data from RD is coming from? input 1 or 2 or 3? Data forqwarding? )
    LI_TEMP_VAL := rs1; 
	-- start and end insertion values
	 LI_START_REPLACE_BT := 16 * (to_integer(unsigned(OpCode(23 downto 21))));
	 LI_endd_REPLACE_BT := 15+ (16 * (to_integer(unsigned(OpCode(23 downto 21)))));
    
  
	 
	  for i in 0 to 15 loop
      				immediate(i) := OpCode(20 - i);
    			 end loop;
	 
	 
	-- Step 2: Modify the specified range in Temp using OpCode (20 downto 5)
    LI_TEMP_VAL(LI_endd_REPLACE_BT downto LI_START_REPLACE_BT) := opcode(20 downto 5);
    
    -- Step 3: Assign Temp to the rd output
    rd <= LI_TEMP_VAL;
	--rest of operation.									 -- what way is daqta inserted is op coe least significant first?
end if;	 
-- __________________________________________________________________________________________________________________________________





-- __________________________________________________________________________________________________________________________________

--R4 Check and Arithmetic:
if OpCode(24 downto 23) = "10" then
	 
	 	  case OpCode(22 downto 20) is
       
			
--____________________________________________________________			   
			   when "000" =>
		-- SIMALwS	  
																										  
   
 -- Multiply low of the 4 different 32-bit slices
        R4_32_mult_1 := signed(rs3(15 downto 0)) * signed(rs2(15 downto 0));
        R4_32_mult_2 := signed(rs3(47 downto 32)) * signed(rs2(47 downto 32));
        R4_32_mult_3 := signed(rs3(79 downto 64)) * signed(rs2(79 downto 64));
        R4_32_mult_4 := signed(rs3(111 downto 96)) * signed(rs2(111 downto 96));
		
		 -- Perform saturation: If the result is larger than the maximum allowed value, set it to the maximum value
					  --MULT SATURATE
			 
			 --SEGMENENT ONE SATURATION	
		R4_32_mult_sat_1 := to_integer(signed(rs3(15 downto 0))) * to_integer(signed(rs2(15 downto 0)));
		if (R4_32_mult_sat_1 > 2147483647) then R4_32_mult_1 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_1 < -2147483648) then R4_32_mult_1 := "10000000000000000000000000000000";
        end if; 	
		
			--SEGMENENT TWO SATURATION
		R4_32_mult_sat_2 := to_integer(signed(rs3(47 downto 32))) * to_integer(signed(rs2(47 downto 32)));
		if (R4_32_mult_sat_2 > 2147483647) then R4_32_mult_2 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_2 < -2147483647) then R4_32_mult_2 := "10000000000000000000000000000000";
        end if; 		 
		
			--SEGMENENT THREE SATURATION
       	R4_32_mult_sat_3 := to_integer(signed(rs3(79 downto 64))) * to_integer(signed(rs2(79 downto 64)));
		if (R4_32_mult_sat_3 > 2147483647) then R4_32_mult_3 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_3 < -2147483647) then R4_32_mult_3 := "10000000000000000000000000000000";
        end if; 	  
		
			--SEGMENENT FOUR SATURATION	
       	R4_32_mult_sat_4 := to_integer(signed(rs3(111 downto 96))) * to_integer(signed(rs2(111 downto 96)));
		if (R4_32_mult_sat_4 > 2147483647) then R4_32_mult_4 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_4 < -2147483647) then R4_32_mult_4 := "10000000000000000000000000000000";
        end if; 
		
		
		
		 -- Perform additions based on the specified ranges
    R4_32_add_1 := R4_32_mult_1 + signed(rs1(31 downto 0));
    R4_32_add_2 := R4_32_mult_2 + signed(rs1(63 downto 32));
    R4_32_add_3 := R4_32_mult_3 + signed(rs1(95 downto 64));
    R4_32_add_4 := R4_32_mult_4 + signed(rs1(127 downto 96));
				  --ADD SATURATE
	
				  
														
			 		  -- 15,47,79,111
		--SEGMENENT ONE SATURATION
		r4_mult_sign_1 := rs2(15) xor rs3(15);  
		-- Saturation
if rs1(31) = r4_mult_sign_1 then
    if not (r4_mult_sign_1 = R4_32_add_1(31)) then 
        if r4_mult_sign_1 = '1' then
            R4_32_add_1 := "10000000000000000000000000000000";
        elsif r4_mult_sign_1 = '0' then
            R4_32_add_1 := "01111111111111111111111111111111";
        end if;
    else
        -- Concatenate later.
        null; -- placeholder for future code
    end if;
else
    -- Concatenate later.
   
end if;

									   
-- 15,47,79,111	   
	--31,63,95,127
		--SEGMENENT TWO SATURATION		
			r4_mult_sign_2 := rs2(47) xor rs3(47);          
			--saturation								  
			
		if (rs1(63) = r4_mult_sign_2) then
    if not(r4_mult_sign_2 = R4_32_add_2(31)) then 
        
            if (r4_mult_sign_2 = '1') then R4_32_add_2 := "10000000000000000000000000000000";
            elsif (r4_mult_sign_2 = '0') then R4_32_add_2 := "01111111111111111111111111111111";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if;

					   
-- 15,47,79,111	   						-- MUST CHANGE THESE NUMBERS FOR HIGH VS LOW RANGES, high slices are at 31,63,95,127.
	--31,63,95,127
			--SEGMENENT THREE SATURATION
	  r4_mult_sign_3 := rs2(79) xor rs3(79);          
			--saturation								  
			
		if (rs1(95) = r4_mult_sign_3) then
    if not(r4_mult_sign_3 = R4_32_add_3(31)) then 
       
            if (r4_mult_sign_3 = '1') then R4_32_add_3 := "10000000000000000000000000000000";
            elsif (r4_mult_sign_3 = '0') then R4_32_add_3 := "01111111111111111111111111111111";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
   
end if;				 	  
		
			--SEGMENENT FOUR SATURATION
		r4_mult_sign_4 := rs2(111) xor rs3(111);          
			--saturation								  
			
		if (rs1(127) = r4_mult_sign_4) then
    if not(r4_mult_sign_4 = R4_32_add_4(31)) then 
        
            if (r4_mult_sign_4 = '1') then R4_32_add_4 := "10000000000000000000000000000000";
            elsif (r4_mult_sign_4 = '0') then R4_32_add_4 := "01111111111111111111111111111111";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if;
	
	
	
    -- having checked for saturation, Combine the results into a single 128-bit vector
    R4_temp_result := (others => '0');
    R4_temp_result(31 downto 0) := R4_32_add_1(31 downto 0);
    R4_temp_result(63 downto 32) := R4_32_add_2(31 downto 0);
    R4_temp_result(95 downto 64) := R4_32_add_3(31 downto 0);
    R4_temp_result(127 downto 96) := R4_32_add_4(31 downto 0);

    -- Assign the result to rd
    rd <= std_logic_vector(R4_temp_result);	
--____________________________________________________________
	
	
	
	
	
--____________________________________________________________	
        when "001" =>
			  -- SIMAHwS	  
	
   
 -- Multiply HIGH of the 4 different 32-bit slices
        R4_32_mult_1 := signed(rs3(31 downto 16)) * signed(rs2(31 downto 16));
        R4_32_mult_2 := signed(rs3(63 downto 48)) * signed(rs2(63 downto 48));
        R4_32_mult_3 := signed(rs3(95 downto 80)) * signed(rs2(95 downto 80));
        R4_32_mult_4 := signed(rs3(127 downto 112)) * signed(rs2(127 downto 112));
		
		 -- Perform saturation: If the result is larger than the maximum allowed value, set it to the maximum value
					  --MULT SATURATE
			 
			 --SEGMENENT ONE SATURATION	
		R4_32_mult_sat_1 := to_integer(signed(rs3(31 downto 16))) * to_integer(signed(rs2(31 downto 16)));
		if (R4_32_mult_sat_1 > 2147483647) then R4_32_mult_1 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_1 < -2147483648) then R4_32_mult_1 := "10000000000000000000000000000000";
        end if; 				 
		
			--SEGMENENT TWO SATURATION
		R4_32_mult_sat_2 := to_integer(signed(rs3(63 downto 48))) * to_integer(signed(rs2(63 downto 48)));
		if (R4_32_mult_sat_2 > 2147483647) then R4_32_mult_2 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_2 < -2147483647) then R4_32_mult_2 := "10000000000000000000000000000000";
        end if; 		 
		
			--SEGMENENT THREE SATURATION
       	R4_32_mult_sat_3 := to_integer(signed(rs3(95 downto 80))) * to_integer(signed(rs2(95 downto 80)));
		if (R4_32_mult_sat_3 > 2147483647) then R4_32_mult_3 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_3 < -2147483647) then R4_32_mult_3 := "10000000000000000000000000000000";
        end if; 	  
		
			--SEGMENENT FOUR SATURATION
       	R4_32_mult_sat_4 := to_integer(signed(rs3(127 downto 112))) * to_integer(signed(rs2(127 downto 112)));
		if (R4_32_mult_sat_4 > 2147483647) then R4_32_mult_4 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_4 < -2147483647) then R4_32_mult_4 := "10000000000000000000000000000000";
        end if; 
			
		
		
		 -- Perform additions based on the specified ranges
    R4_32_add_1 := R4_32_mult_1 + signed(rs1(31 downto 0));
    R4_32_add_2 := R4_32_mult_2 + signed(rs1(63 downto 32));
    R4_32_add_3 := R4_32_mult_3 + signed(rs1(95 downto 64));
    R4_32_add_4 := R4_32_mult_4 + signed(rs1(127 downto 96));
				  --ADD SATURATE
	
	
													
			 		  -- 31, 63, 95,127
		--SEGMENENT ONE SATURATION
		
			r4_mult_sign_1 := rs2(31) xor rs3(31);          
			--saturation								  
			
		if (rs1(31) = r4_mult_sign_1) then
    if not(r4_mult_sign_1 = R4_32_add_1(31)) then 
       
            if (r4_mult_sign_1 = '1') then R4_32_add_1 := "10000000000000000000000000000000";
            elsif (r4_mult_sign_1 = '0') then R4_32_add_1 := "01111111111111111111111111111111";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
    
end if;

		

									   
-- 15,47,79,111	   
	--31,63,95,127
		--SEGMENENT TWO SATURATION		
			r4_mult_sign_2 := rs2(63) xor rs3(63);          
			--saturation								  
			
		if (rs1(63) = r4_mult_sign_2) then
    if not(r4_mult_sign_2 = R4_32_add_2(31)) then 
        
            if (r4_mult_sign_2 = '1') then R4_32_add_2 := "10000000000000000000000000000000";
            elsif (r4_mult_sign_2 = '0') then R4_32_add_2 := "01111111111111111111111111111111";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
    
end if;

					   
-- 15,47,79,111	   						-- MUST CHANGE THESE NUMBERS FOR HIGH VS LOW RANGES, high slices are at 31,63,95,127.
	--31,63,95,127
			--SEGMENENT THREE SATURATION
	  r4_mult_sign_3 := rs2(95) xor rs3(95);          
			--saturation								  
			
		if (rs1(95) = r4_mult_sign_3) then
    if not(r4_mult_sign_3 = R4_32_add_3(31)) then 
        
            if (r4_mult_sign_3 = '1') then R4_32_add_3 := "10000000000000000000000000000000";
            elsif (r4_mult_sign_3 = '0') then R4_32_add_3 := "01111111111111111111111111111111";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
    
end if;				 	  
		
			--SEGMENENT FOUR SATURATION
		r4_mult_sign_4 := rs2(127) xor rs3(127);          
			--saturation								  
			
		if (rs1(127) = r4_mult_sign_4) then
    if not(r4_mult_sign_4 = R4_32_add_4(31)) then 
        
            if (r4_mult_sign_4 = '1') then R4_32_add_4 := "10000000000000000000000000000000";
            elsif (r4_mult_sign_4 = '0') then R4_32_add_4 := "01111111111111111111111111111111";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
    
end if;
	
				  
				  
	
	
	
    -- having checked for saturation, Combine the results into a single 128-bit vector
    R4_temp_result := (others => '0');
    R4_temp_result(31 downto 0) := R4_32_add_1(31 downto 0);
    R4_temp_result(63 downto 32) := R4_32_add_2(31 downto 0);
    R4_temp_result(95 downto 64) := R4_32_add_3(31 downto 0);
    R4_temp_result(127 downto 96) := R4_32_add_4(31 downto 0);

    -- Assign the result to rd
    rd <= std_logic_vector(R4_temp_result);	
--____________________________________________________________		
		
		
		
		
		
		
		
		
		
--____________________________________________________________		
        when "010" =>
		-- SIMSLwS		
		
	 -- Multiply low of the 4 different 32-bit slices
        R4_32_mult_1 := signed(rs3(15 downto 0)) * signed(rs2(15 downto 0));
		R4_32_mult_2 := signed(rs3(47 downto 32)) * signed(rs2(47 downto 32));
        R4_32_mult_3 := signed(rs3(79 downto 64)) * signed(rs2(79 downto 64));
        R4_32_mult_4 := signed(rs3(111 downto 96)) * signed(rs2(111 downto 96));
		
		 -- Perform saturation: If the result is larger than the maximum allowed value, set it to the maximum value
					  --MULT SATURATE
			 
			 --SEGMENENT ONE SATURATION	
		R4_32_mult_sat_1 := to_integer(signed(rs3(15 downto 0))) * to_integer(signed(rs2(15 downto 0)));
		if (R4_32_mult_sat_1 > 2147483647) then R4_32_mult_1 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_1 < -2147483648) then R4_32_mult_1 := "10000000000000000000000000000000";
        end if; 				 
		
			--SEGMENENT TWO SATURATION
		R4_32_mult_sat_2 := to_integer(signed(rs3(47 downto 32))) * to_integer(signed(rs2(47 downto 32)));
		if (R4_32_mult_sat_2 > 2147483647) then R4_32_mult_2 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_2 < -2147483647) then R4_32_mult_2 := "10000000000000000000000000000000";
        end if; 		 
		
			--SEGMENENT THREE SATURATION	
       	R4_32_mult_sat_3 := to_integer(signed(rs3(79 downto 64))) * to_integer(signed(rs2(79 downto 64)));
		if (R4_32_mult_sat_3 > 2147483647) then R4_32_mult_3 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_3 < -2147483647) then R4_32_mult_3 := "10000000000000000000000000000000";
        end if; 	  
		
			--SEGMENENT FOUR SATURATION	
       	R4_32_mult_sat_4 := to_integer(signed(rs3(111 downto 96))) * to_integer(signed(rs2(111 downto 96)));
		if (R4_32_mult_sat_4 > 2147483647) then R4_32_mult_4 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_4 < -2147483647) then R4_32_mult_4 := "10000000000000000000000000000000";
        end if; 
			
		
		
		 -- Perform subtractions based on the specified ranges
    R4_32_sub_1:= signed(rs1(31 downto 0)) - R4_32_mult_1;
    R4_32_sub_2:= signed(rs1(63 downto 32)) - R4_32_mult_2;
    R4_32_sub_3:= signed(rs1(95 downto 64)) - R4_32_mult_3;
    R4_32_sub_4:= signed(rs1(127 downto 96)) - R4_32_mult_4 ;
				  --sub SATURATE
	
	 --SEGMENENT ONE SATURATION
	
				  
			r4_mult_sign_1 := rs2(15) xor rs3(15);         --XORs the sign bits of the multiplicands together to find the sign of the product    
				   
  									   					   
-- 15,47,79,111			
	--31,63,95,127
	           -- Saturation testing
if (rs1(31) = r4_mult_sign_1) then
    if not(r4_mult_sign_1 = R4_32_sub_1(31)) then
        if (r4_mult_sign_1 = '1') then
            R4_32_sub_1 := "01111111111111111111111111111111";
        elsif (r4_mult_sign_1 = '0') then
            R4_32_sub_1 := "10000000000000000000000000000000"; 
        end if;
    else 
        -- Concatenate later.
       
    end if;
else 
    -- Concatenate later.
    
end if;

	
	
			
	 
			--SEGMENENT TWO SATURATION
		
			
					  
			r4_mult_sign_2 := rs2(47) xor rs3(47);         --XORs the sign bits of the multiplicands together to find the sign of the product    
				   
	   							   					   
-- 15,47,79,111					
	--31,63,95,127
	           -- Saturation testing
if (rs1(63) = r4_mult_sign_2) then
    if not(r4_mult_sign_2 = R4_32_sub_2(31)) then
        if (r4_mult_sign_2 = '1') then
            R4_32_sub_2 := "01111111111111111111111111111111";
        elsif (r4_mult_sign_2 = '0') then
            R4_32_sub_2 := "10000000000000000000000000000000"; 
        end if;
    else 
        -- Concatenate later.
       
    end if;
else 
    -- Concatenate later.
    
end if;
		
			--SEGMENENT THREE SATURATION
	
			
					  
			r4_mult_sign_3 := rs2(79) xor rs3(79);         --XORs the sign bits of the multiplicands together to find the sign of the product    
				   
									   					   
-- 15,47,79,111	   						
	--31,63,95,127
	           -- Saturation testing
if (rs1(95) = r4_mult_sign_3) then
    if not(r4_mult_sign_3 = R4_32_sub_3(31)) then
        if (r4_mult_sign_3 = '1') then
            R4_32_sub_3 := "01111111111111111111111111111111";
        elsif (r4_mult_sign_3 = '0') then
            R4_32_sub_3 := "10000000000000000000000000000000"; 
        end if;
    else 
        -- Concatenate later.
       
    end if;
else 
    -- Concatenate later.
    
end if;




								   					   
-- 15,47,79,111	  



		--SEGMENENT FOUR SATURATION
		 	 
			r4_mult_sign_4 := rs2(111) xor rs3(111);         --XORs the sign bits of the multiplicands together to find the sign of the product    
					
	--31,63,95,127
	           -- Saturation testing
if (rs1(127) = r4_mult_sign_4) then
    if not(r4_mult_sign_4 = R4_32_sub_4(31)) then
        if (r4_mult_sign_4 = '1') then R4_32_sub_4 := "01111111111111111111111111111111";
        elsif (r4_mult_sign_4 = '0') then R4_32_sub_4 := "10000000000000000000000000000000"; 
        end if;
    else 
        -- Concatenate later.
       
    end if;
else 
    -- Concatenate later.
    
end if;
			
	
    -- having checked for saturation, Combine the results into a single 128-bit vector
    R4_temp_result := (others => '0');
    R4_temp_result(31 downto 0) := R4_32_sub_1(31 downto 0);
    R4_temp_result(63 downto 32) := R4_32_sub_2(31 downto 0);
    R4_temp_result(95 downto 64) := R4_32_sub_3(31 downto 0);
    R4_temp_result(127 downto 96) := R4_32_sub_4(31 downto 0);

    -- Assign the result to rd
    rd <= std_logic_vector(R4_temp_result);	
--____________________________________________________________	

        
		

		
		
		
--____________________________________________________________		
		
		
        when "011" =>
            -- SIMSHwS
         
			
-- Multiply high of the 4 different 32-bit slices
        R4_32_mult_1 := signed(rs3(31 downto 16)) * signed(rs2(31 downto 16));
        R4_32_mult_2 := signed(rs3(63 downto 48)) * signed(rs2(63 downto 48));
        R4_32_mult_3 := signed(rs3(95 downto 80)) * signed(rs2(95 downto 80));
        R4_32_mult_4 := signed(rs3(127 downto 112)) * signed(rs2(127 downto 112));
		
		  -- Perform saturation: If the result is larger than the maximum allowed value, set it to the maximum value
					  --MULT SATURATE
			 
			 --SEGMENENT ONE SATURATION	
		R4_32_mult_sat_1 := to_integer(signed(rs3(31 downto 16))) * to_integer(signed(rs2(31 downto 16)));
		if (R4_32_mult_sat_1 > 2147483647) then R4_32_mult_1 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_1 < -2147483648) then R4_32_mult_1 := "10000000000000000000000000000000";
        end if; 				 
		
			--SEGMENENT TWO SATURATION
		R4_32_mult_sat_2 := to_integer(signed(rs3(63 downto 48))) * to_integer(signed(rs2(63 downto 48)));
		if (R4_32_mult_sat_2 > 2147483647) then R4_32_mult_2 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_2 < -2147483647) then R4_32_mult_2 := "10000000000000000000000000000000";
        end if; 		 
		
			--SEGMENENT THREE SATURATION
       	R4_32_mult_sat_3 := to_integer(signed(rs3(95 downto 80))) * to_integer(signed(rs2(95 downto 80)));
		if (R4_32_mult_sat_3 > 2147483647) then R4_32_mult_3 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_3 < -2147483647) then R4_32_mult_3 := "10000000000000000000000000000000";
        end if; 	  
		
			--SEGMENENT FOUR SATURATION	
       	R4_32_mult_sat_4 := to_integer(signed(rs3(127 downto 112))) * to_integer(signed(rs2(127 downto 112)));
		if (R4_32_mult_sat_4 > 2147483647) then R4_32_mult_4 := "01111111111111111111111111111111";
        elsif (R4_32_mult_sat_4 < -2147483647) then R4_32_mult_4 := "10000000000000000000000000000000";
        end if; 
			
		
		
		 -- Perform subtractions based on the specified ranges
		R4_32_sub_1:= signed(rs1(31 downto 0)) - R4_32_mult_1;
		R4_32_sub_2:= signed(rs1(63 downto 32)) - R4_32_mult_2;
		R4_32_sub_3:= signed(rs1(95 downto 64)) - R4_32_mult_3;
		R4_32_sub_4:= signed(rs1(127 downto 96)) - R4_32_mult_4;
				  --sub SATURATE
	
				  
	 --SEGMENENT ONE SATURATION
	
				  
			r4_mult_sign_1 := rs2(31) xor rs3(31);         --XORs the sign bits of the multiplicands together to find the sign of the product    
				   
  									   					   
-- 15,47,79,111			
	--31,63,95,127
	           -- Saturation testing
if (rs1(31) = r4_mult_sign_1) then
    if not(r4_mult_sign_1 = R4_32_sub_1(31)) then
        if (r4_mult_sign_1 = '1') then
            R4_32_sub_1 := "01111111111111111111111111111111";
        elsif (r4_mult_sign_1 = '0') then
            R4_32_sub_1 := "10000000000000000000000000000000"; 
        end if;
    else 
        -- Concatenate later.
       
    end if;
else 
    -- Concatenate later.
    
end if;

	
	
			
	 
			--SEGMENENT TWO SATURATION
		
			
					  
			r4_mult_sign_2 := rs2(63) xor rs3(63);         --XORs the sign bits of the multiplicands together to find the sign of the product    
				   
	   							   					   
-- 15,47,79,111					
	--31,63,95,127
	           -- Saturation testing
if (rs1(63) = r4_mult_sign_2) then
    if not(r4_mult_sign_2 = R4_32_sub_2(31)) then
        if (r4_mult_sign_2 = '1') then
            R4_32_sub_2 := "01111111111111111111111111111111";
        elsif (r4_mult_sign_2 = '0') then
            R4_32_sub_2 := "10000000000000000000000000000000"; 
        end if;
    else 
        -- Concatenate later.
       
    end if;
else 
    -- Concatenate later.
    
end if;
		
			--SEGMENENT THREE SATURATION
	
			
					  
			r4_mult_sign_3 := rs2(95) xor rs3(95);         --XORs the sign bits of the multiplicands together to find the sign of the product    
				   
									   					   
-- 15,47,79,111	   						
	--31,63,95,127
	           -- Saturation testing
if (rs1(95) = r4_mult_sign_3) then
    if not(r4_mult_sign_3 = R4_32_sub_3(31)) then
        if (r4_mult_sign_3 = '1') then
            R4_32_sub_3 := "01111111111111111111111111111111";
        elsif (r4_mult_sign_3 = '0') then
            R4_32_sub_3 := "10000000000000000000000000000000"; 
        end if;
    else 
        -- Concatenate later.
       
    end if;
else 
    -- Concatenate later.
    
end if;




								   					   
-- 15,47,79,111	  



		--SEGMENENT FOUR SATURATION
		 	 
			r4_mult_sign_4 := rs2(127) xor rs3(127);         --XORs the sign bits of the multiplicands together to find the sign of the product    
					
	--31,63,95,127
	           -- Saturation testing
if (rs1(127) = r4_mult_sign_4) then
    if not(r4_mult_sign_4 = R4_32_sub_4(31)) then
        if (r4_mult_sign_4 = '1') then R4_32_sub_4 := "01111111111111111111111111111111";
        elsif (r4_mult_sign_4 = '0') then R4_32_sub_4 := "10000000000000000000000000000000"; 
        end if;
    else 
        -- Concatenate later.
       
    end if;
else 
    -- Concatenate later.
    
end if;
			
	
	
    -- having checked for saturation, Combine the results into a single 128-bit vector
    R4_temp_result := (others => '0');
    R4_temp_result(31 downto 0) := R4_32_sub_1(31 downto 0);
    R4_temp_result(63 downto 32) := R4_32_sub_2(31 downto 0);
    R4_temp_result(95 downto 64) := R4_32_sub_3(31 downto 0);
    R4_temp_result(127 downto 96) := R4_32_sub_4(31 downto 0);

    -- Assign the result to rd
    rd <= std_logic_vector(R4_temp_result);	
--____________________________________________________________	


			
			
--____________________________________________________________				
		when "100" =>
            -- SLIMALwS
			
-- Multiply low of the 2 different 64-bit slices
        R4_64_mult_1 := signed(rs3(31 downto 0)) * signed(rs2(31 downto 0));
        R4_64_mult_2 := signed(rs3(95 downto 64)) * signed(rs2(95 downto 64));		
		
		
-- Perform saturation: If the result is larger than the maximum allowed value, set it to the maximum value
					  --MULT SATURATE
			 
			 --SEGMENENT ONE SATURATION	
		R4_64_mult_sat_1 := to_integer(signed(rs3(31 downto 0))) * to_integer(signed(rs2(31 downto 0)));
		if (R4_64_mult_sat_1 >     signed(compare_high)    ) then R4_64_mult_1 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (R4_64_mult_sat_1 <  signed(compare_low)     ) then R4_64_mult_1 := "1000000000000000000000000000000000000000000000000000000000000000";	  
		else R4_64_mult_1 :=   signed(rs3(31 downto 0)) * signed(rs2(31 downto 0));		
        end if; 				 
		
			--SEGMENENT TWO SATURATION
		R4_64_mult_sat_2 := to_integer(signed(rs3(95 downto 64))) * to_integer(signed(rs2(95 downto 64)));
		if (R4_64_mult_sat_2 >  signed(compare_high) ) then R4_64_mult_2 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (R4_64_mult_sat_2 < signed(compare_low) ) then R4_64_mult_2 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 		 			
		 
		 -- Perform additions based on the specified ranges
		R4_64_add_1:= signed(rs1(63 downto 0)) + R4_64_mult_1;
		R4_64_add_2:= signed(rs1(127 downto 64)) + R4_64_mult_2;		 
		 
				--add SATURATE
	
	 --SEGMENENT ONE SATURATION

			r4_mult_sign_1 := rs2(31) xor rs3(31);          
			--saturation								  
			
		if (rs1(63) = r4_mult_sign_1) then
    if not(r4_mult_sign_1 = R4_64_add_1(63)) then 
       
            if (r4_mult_sign_1 = '1') then R4_64_add_1 := X"8000000000000000";
            elsif (r4_mult_sign_1 = '0') then R4_64_add_1 := X"7FFFFFFFFFFFFFFF";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
   
end if;
				 
		
			--SEGMENENT TWO SATURATION
	
			r4_mult_sign_2 := rs2(95) xor rs3(95);          
			--saturation								  
			
		if (rs1(127) = r4_mult_sign_2) then
    if not(r4_mult_sign_2 = R4_64_add_2(63)) then 
      
            if (r4_mult_sign_2 = '1') then R4_64_add_2 := X"8000000000000000";
            elsif (r4_mult_sign_2 = '0') then R4_64_add_2 := X"7FFFFFFFFFFFFFFF";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
    
end if;


	 -- having checked for saturation, Combine the results into a single 128-bit vector
    R4_temp_result := (others => '0');
    R4_temp_result(63 downto 0) := R4_64_add_1(63 downto 0);
    R4_temp_result(127 downto 64) := R4_64_add_2(63 downto 0);	 
		 
	  -- Assign the result to rd
    rd <= std_logic_vector(R4_temp_result);		 
--____________________________________________________________	



--____________________________________________________________	
		when "101" =>
            -- SLIMAHwS
        
	
			
-- Multiply high of the 4 different 64-bit slices
        R4_64_mult_1 := signed(rs3(63 downto 32)) * signed(rs2(63 downto 32));
        R4_64_mult_2 := signed(rs3(127 downto 96)) * signed(rs2(127 downto 96));		
		
		
-- Perform saturation: If the result is larger than the maximum allowed value, set it to the maximum value
					  --MULT SATURATE
			 
			 --SEGMENENT ONE SATURATION	
		R4_64_mult_sat_1 := to_integer(signed(rs3(63 downto 32))) * to_integer(signed(rs2(63 downto 32)));
		if (R4_64_mult_sat_1 >  signed(compare_high) ) then R4_64_mult_1 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (R4_64_mult_sat_1 <  signed(compare_low)) then R4_64_mult_1 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 				 
		
			--SEGMENENT TWO SATURATION
		R4_64_mult_sat_2 := to_integer(signed(rs3(127 downto 96))) * to_integer(signed(rs2(127 downto 96)));
		if (R4_64_mult_sat_2 >  signed(compare_high) ) then R4_64_mult_2 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (R4_64_mult_sat_2 <  signed(compare_low)) then R4_64_mult_2 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 		 			
		 
		 -- Perform additions based on the specified ranges
		R4_64_add_1:= signed(rs1(63 downto 0)) + R4_64_mult_1;
		R4_64_add_2:= signed(rs1(127 downto 64)) + R4_64_mult_2;		 
		 
				--add SATURATE
	
					
	 --SEGMENENT ONE SATURATION

			r4_mult_sign_1 := rs2(63) xor rs3(63);          
			--saturation								  
			
		if (rs1(63) = r4_mult_sign_1) then
    if not(r4_mult_sign_1 = R4_64_add_1(63)) then 
       
            if (r4_mult_sign_1 = '1') then R4_64_add_1 := X"8000000000000000";
            elsif (r4_mult_sign_1 = '0') then R4_64_add_1 := X"7FFFFFFFFFFFFFFF";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
   
end if;
				 
		
			--SEGMENENT TWO SATURATION
	
			r4_mult_sign_2 := rs2(127) xor rs3(127);          
			--saturation								  
			
		if (rs1(127) = r4_mult_sign_2) then
    if not(r4_mult_sign_2 = R4_64_add_2(63)) then 
      
            if (r4_mult_sign_2 = '1') then R4_64_add_2 := X"8000000000000000";
            elsif (r4_mult_sign_2 = '0') then R4_64_add_2 := X"7FFFFFFFFFFFFFFF";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
    
end if;

				
				 
	 -- having checked for saturation, Combine the results into a single 128-bit vector
    R4_temp_result := (others => '0');
    R4_temp_result(63 downto 0) := R4_64_add_1(63 downto 0);
    R4_temp_result(127 downto 64) := R4_64_add_2(63 downto 0);	 
		 
	  -- Assign the result to rd
    rd <= std_logic_vector(R4_temp_result);		
			
			
			
			
			
--____________________________________________________________				


--____________________________________________________________	

		when "110" =>
            -- SLIMSLwS
          
			
		
			
-- Multiply low of the 2 different 64-bit slices
        R4_64_mult_1 := signed(rs3(31 downto 0)) * signed(rs2(31 downto 0));
        R4_64_mult_2 := signed(rs3(95 downto 64)) * signed(rs2(95 downto 64));		
		
		
-- Perform saturation: If the result is larger than the maximum allowed value, set it to the maximum value
					  --MULT SATURATE
			 
			 --SEGMENENT ONE SATURATION	
		R4_64_mult_sat_1 := to_integer(signed(rs3(31 downto 0))) * to_integer(signed(rs2(31 downto 0)));
		
		
		
		
		if (R4_64_mult_sat_1 > signed(compare_high) ) then R4_64_mult_1 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (R4_64_mult_sat_1 < signed(compare_low)) then R4_64_mult_1 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 				 
		
			--SEGMENENT TWO SAT URATION
		R4_64_mult_sat_2 := to_integer(signed(rs3(95 downto 64))) * to_integer(signed(rs2(95 downto 64)));
		
		
		
		
		if (R4_64_mult_sat_2 >  signed(compare_high)) then R4_64_mult_2 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (R4_64_mult_sat_2 < signed(compare_low)) then R4_64_mult_2 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 		 			
		 
		 -- Perform subtractions based on the specified ranges
		R4_64_sub_1:= signed(rs1(63 downto 0)) - R4_64_mult_1;
		R4_64_sub_2:= signed(rs1(127 downto 64)) - R4_64_mult_2;		 
		 
				--sub SATURATE
	
	 --SEGMENENT ONE SATURATION
	
	 
	 
			r4_mult_sign_1 := rs2(31) xor rs3(31);          
			--saturation								  
			
		if (rs1(63) = r4_mult_sign_1) then
    if not(r4_mult_sign_1 = R4_64_sub_1(63)) then 
        
            if (r4_mult_sign_1 = '1') then R4_64_sub_1 :=  X"7FFFFFFFFFFFFFFF";
            elsif (r4_mult_sign_1 = '0') then R4_64_sub_1 := X"8000000000000000";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
  
end if;
				
	 
			--SEGMENENT TWO SATURATION
		 r4_mult_sign_2 := rs2(95) xor rs3(95);          
			--saturation								  
			
		if (rs1(127) = r4_mult_sign_2) then
    if not(r4_mult_sign_2 = R4_64_sub_2(63)) then 
        
            if (r4_mult_sign_2 = '1') then R4_64_sub_2 := 	 X"7FFFFFFFFFFFFFFF";
            elsif (r4_mult_sign_2 = '0') then R4_64_sub_2 := X"8000000000000000";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
    
end if;

	 -- having checked for saturation, Combine the results into a single 128-bit vector
    R4_temp_result := (others => '0');
    R4_temp_result(63 downto 0) := R4_64_sub_1(63 downto 0);
    R4_temp_result(127 downto 64) := R4_64_sub_2(63 downto 0);	 
		 
	  -- Assign the result to rd
    rd <= std_logic_vector(R4_temp_result);		
			
			
	
--____________________________________________________________	

		when "111" =>
            -- SLIMSHwS
          		
		
			
-- Multiply high of the 4 different 64-bit slices
        R4_64_mult_1 := signed(rs3(63 downto 32)) * signed(rs2(63 downto 32));
        R4_64_mult_2 := signed(rs3(127 downto 96)) * signed(rs2(127 downto 96));		
		
		
-- Perform saturation: If the result is larger than the maximum allowed value, set it to the maximum value
					  --MULT SATURATE
			 
			 --SEGMENENT ONE SATURATION	
		R4_64_mult_sat_1 := to_integer(signed(rs3(63 downto 32))) * to_integer(signed(rs2(63 downto 32)));
		if (R4_64_mult_sat_1 > signed(compare_high)) then R4_64_mult_1 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (R4_64_mult_sat_1 < signed(compare_low)) then R4_64_mult_1 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 				 
		
			--SEGMENENT TWO SATURATION
		R4_64_mult_sat_2 := to_integer(signed(rs3(127 downto 96))) * to_integer(signed(rs2(127 downto 96)));
		if (R4_64_mult_sat_2 > signed(compare_high)) then R4_64_mult_2 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (R4_64_mult_sat_2 < signed(compare_low)) then R4_64_mult_2 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 		 			
		 
		 -- Perform subtractions based on the specified ranges
		R4_64_sub_1:= signed(rs1(63 downto 0)) - R4_64_mult_1;
		R4_64_sub_2:= signed(rs1(127 downto 64)) - R4_64_mult_2;		 
		 
				--sub SATURATE
	

				
				
--SEGMENENT ONE SATURATION
	
	 
	 
			r4_mult_sign_1 := rs2(63) xor rs3(63);          
			--saturation								  
			
		if (rs1(63) = r4_mult_sign_1) then
    if not(r4_mult_sign_1 = R4_64_sub_1(63)) then 
        
            if (r4_mult_sign_1 = '1') then R4_64_sub_1 :=  X"7FFFFFFFFFFFFFFF";
            elsif (r4_mult_sign_1 = '0') then R4_64_sub_1 := X"8000000000000000";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
  
end if;
				
	 
			--SEGMENENT TWO SATURATION
		 r4_mult_sign_2 := rs2(127) xor rs3(127);          
			--saturation								  
			
		if (rs1(127) = r4_mult_sign_2) then
    if not(r4_mult_sign_2 = R4_64_sub_2(63)) then 
        
            if (r4_mult_sign_2 = '1') then R4_64_sub_2 := 	 X"7FFFFFFFFFFFFFFF";
            elsif (r4_mult_sign_2 = '0') then R4_64_sub_2 := X"8000000000000000";
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
        
    
end if;
	
				
				
	 -- having checked for saturation, Combine the results into a single 128-bit vector
    R4_temp_result := (others => '0');
    R4_temp_result(63 downto 0) := R4_64_sub_1(63 downto 0);
    R4_temp_result(127 downto 64) := R4_64_sub_2(63 downto 0);	 
		 
	  -- Assign the result to rd
    rd <= std_logic_vector(R4_temp_result);		
			
			
				
			
			
--____________________________________________________________	



        when others =>
            rd <= (others => '0'); -- Default behavior when condition is not met
    end case;
	
end if;	-- R4 END
-- __________________________________________________________________________________________________________________________________	
	
	
-- __________________________________________________________________________________________________________________________________	
	
	--R3 Check and Arithmetic:
if OpCode(24 downto 23) = "11" then
	 
	-- check opcode field to determine operation
	 	case OpCode(18 downto 15) is
        when "0000" =>
            -- NOP 
			 rd <= (others => '0'); 
        when "0001" =>
            -- SHRHI 
          	
			-- Extract bits 4 to 0 from OpCode and cast to integer for shift amount
        shift_amount := to_integer(unsigned(OpCode(13 downto 10)));
        
			--SLICE 1
            -- Extract 16-bit slice from rs1
            
            SHRHI_shifted_1 := rs1(0 * 16 + 15 downto 0 * 16);
            
            -- Shift the slice by shift_amount and fill shifted-in bits with zeros
            SHRHI_shifted_1 := std_logic_vector(shift_right(unsigned(SHRHI_shifted_1), shift_amount));
            
            -- Save the shifted slice into relative slices of rd and output
        --    rd(15 downto 0) <= SHRHI_shifted_1(15 downto 0);
			
			
			
			--SLICE 2
            -- Extract 16-bit slice from rs1
            
            SHRHI_shifted_2 := rs1(1 * 16 + 15 downto 1 * 16);
            
            -- Shift the slice by shift_amount and fill shifted-in bits with zeros
            SHRHI_shifted_2 := std_logic_vector(shift_right(unsigned(SHRHI_shifted_2), shift_amount));
            
            -- Save the shifted slice into relative slices of rd and output
       --     rd(1 * 16 + 15 downto 1 * 16) <= SHRHI_shifted_2;
			
		   
		    --SLICE 3
            -- Extract 16-bit slice from rs1
            
            SHRHI_shifted_3 := rs1(2 * 16 + 15 downto 2 * 16);
            
            -- Shift the slice by shift_amount and fill shifted-in bits with zeros
            SHRHI_shifted_3 := std_logic_vector(shift_right(unsigned(SHRHI_shifted_3), shift_amount));
            
            -- Save the shifted slice into relative slices of rd and output
        --    rd(2 * 16 + 15 downto 2 * 16) <= SHRHI_shifted_3;
				
				
			
			--SLICE 4
            -- Extract 16-bit slice from rs1
            
            SHRHI_shifted_4 := rs1(3 * 16 + 15 downto 3 * 16);
            
            -- Shift the slice by shift_amount and fill shifted-in bits with zeros
            SHRHI_shifted_4 := std_logic_vector(shift_right(unsigned(SHRHI_shifted_4), shift_amount));
            
            -- Save the shifted slice into relative slices of rd and output
        --    rd(3 * 16 + 15 downto 3 * 16) <= SHRHI_shifted_4;		   
				
			
			--SLICE 5
            -- Extract 16-bit slice from rs1
            
            SHRHI_shifted_5 := rs1(4 * 16 + 15 downto 4 * 16);
            
            -- Shift the slice by shift_amount and fill shifted-in bits with zeros
            SHRHI_shifted_5 := std_logic_vector(shift_right(unsigned(SHRHI_shifted_5), shift_amount));
            
            -- Save the shifted slice into relative slices of rd and output
        --    rd(4 * 16 + 15 downto 4 * 16) <= SHRHI_shifted_5;		   
			
			
			
			--SLICE 6
            -- Extract 16-bit slice from rs1
            
            SHRHI_shifted_6 := rs1(5 * 16 + 15 downto 5 * 16);
            
            -- Shift the slice by shift_amount and fill shifted-in bits with zeros
            SHRHI_shifted_6 := std_logic_vector(shift_right(unsigned(SHRHI_shifted_6), shift_amount));
            
            -- Save the shifted slice into relative slices of rd and output
           -- rd(5 * 16 + 15 downto 5 * 16) <= SHRHI_shifted_6;		   
		   
			
       	   --SLICE 7
            -- Extract 16-bit slice from rs1
            SHRHI_shifted_7 := rs1(6 * 16 + 15 downto 6 * 16);
            
            -- Shift the slice by shift_amount and fill shifted-in bits with zeros
            SHRHI_shifted_7 := std_logic_vector(shift_right(unsigned(SHRHI_shifted_7), shift_amount));
            
            -- Save the shifted slice into relative slices of rd and output
          --  rd(6 * 16 + 15 downto 6 * 16) <= SHRHI_shifted_7;		   
		   		
			
			--SLICE 8
            -- Extract 16-bit slice from rs1
            
            SHRHI_shifted_8 := rs1(7 * 16 + 15 downto 7 * 16);
            
            -- Shift the slice by shift_amount and fill shifted-in bits with zeros
            SHRHI_shifted_8 := std_logic_vector(shift_right(unsigned(SHRHI_shifted_8), shift_amount));
            
            -- Save the shifted slice into relative slices of rd and output
         --   rd(7 * 16 + 15 downto 7 * 16) <= SHRHI_shifted_8;		   
		 
		 
	
	
    -- shifting complete now output
    R3_temp_result := (others => '0');
    R3_temp_result(15 downto 0) := signed(SHRHI_shifted_1 (15 downto 0));
    R3_temp_result(31 downto 16) := signed(SHRHI_shifted_2 (15 downto 0));
    R3_temp_result(47 downto 32)  := signed(SHRHI_shifted_3 (15 downto 0));
    R3_temp_result(63 downto 48) := signed(SHRHI_shifted_4 (15 downto 0));
    R3_temp_result(79 downto 64) := signed(SHRHI_shifted_5 (15 downto 0));
    R3_temp_result(95 downto 80)  := signed(SHRHI_shifted_6 (15 downto 0));
    R3_temp_result(111 downto 96) := signed(SHRHI_shifted_7 (15 downto 0));
    R3_temp_result(127 downto 112)  := signed(SHRHI_shifted_8 (15 downto 0));


       -- Assign the result to rd
    rd <= std_logic_vector(R3_temp_result);	
		 
		 
		  
		  
		  when "0010" =>	
		
		
		    -- AU: add word unsigned: packed 32-bit unsigned addition of the contents of registers rs1 and rs2 (Comments: 4 separate 32-bit values in each 128-bit register)
		
	AU_unsigned_add1 := unsigned(rs1(31 downto 0)) + unsigned(rs2(31 downto 0));
	AU_unsigned_add2 := unsigned(rs1(63 downto 32)) + unsigned(rs2(63 downto 32));
	AU_unsigned_add3 := unsigned(rs1(95 downto 64)) + unsigned(rs2(95 downto 64));				 -- 4 diff ranges added, 
	AU_unsigned_add4 := unsigned(rs1(127 downto 96)) + unsigned(rs2(127 downto 96));
	
	-- Combine the unsigned addition results into a single 128-bit vector
	AU_temp_result := (others => '0');
	AU_temp_result(31 downto 0) := std_logic_vector(AU_unsigned_add1);
	AU_temp_result(63 downto 32) := std_logic_vector(AU_unsigned_add2);
	AU_temp_result(95 downto 64) := std_logic_vector(AU_unsigned_add3);								-- values concatented
	AU_temp_result(127 downto 96) := std_logic_vector(AU_unsigned_add4);
	
	-- Assign the result to rd
	rd <= std_logic_vector(AU_temp_result);													  -- output
		
		
           
            
        when "0011" =>
            -- CNT1H
         
		CNTH_counter_1:= 0;
		 CNTH_counter_2:= 0;
		 CNTH_counter_3:= 0;
		 CNTH_counter_4:= 0;
		 CNTH_counter_5:= 0;
		 CNTH_counter_6:= 0;
		 CNTH_counter_7:= 0;
		 CNTH_counter_8:= 0;
			 
		--start at index 1.	  
		CNTH_index_contr := 0;
        -- rs1 first slice
        for i in 0 to 15 loop
            if rs1(CNTH_index_contr) = '1' then
                CNTH_counter_1 := CNTH_counter_1 + 1;  -- Increment the counter for each '1' bit
          		CNTH_index_contr := CNTH_index_contr + 1;									  
		 	   else
			CNTH_index_contr := CNTH_index_contr + 1;  
				end if;
        end loop;	
				   
		
		
		--start at index 2.
		CNTH_index_contr := 16;
		  for i in 0 to 15 loop
            if rs1(CNTH_index_contr) = '1' then
                CNTH_counter_2 := CNTH_counter_2 + 1;  -- Increment the counter for each '1' bit
          		CNTH_index_contr := CNTH_index_contr + 1;
				   else
			CNTH_index_contr := CNTH_index_contr + 1; 
				end if;
        end loop;
		
		
		--start at index 3.
		CNTH_index_contr := 32;
		  for i in 0 to 15 loop
            if rs1(CNTH_index_contr) = '1' then
                CNTH_counter_3 := CNTH_counter_3 + 1;  -- Increment the counter for each '1' bit
          		CNTH_index_contr := CNTH_index_contr + 1; 
				   else
			CNTH_index_contr := CNTH_index_contr + 1; 
				end if;
        end loop;	
		
	      --start at index 4.
		CNTH_index_contr := 48;
		  for i in 0 to 15 loop
            if rs1(CNTH_index_contr) = '1' then
                CNTH_counter_4 := CNTH_counter_4 + 1;  -- Increment the counter for each '1' bit
          		CNTH_index_contr := CNTH_index_contr + 1;  
				   else
			CNTH_index_contr := CNTH_index_contr + 1; 
				end if;
        end loop;	 
		
		--start at index 5.
		CNTH_index_contr := 64;
		  for i in 0 to 15 loop
            if rs1(CNTH_index_contr) = '1' then
                CNTH_counter_5 := CNTH_counter_5 + 1;  -- Increment the counter for each '1' bit
          		CNTH_index_contr := CNTH_index_contr + 1; 
				   else
			CNTH_index_contr := CNTH_index_contr + 1; 
				end if;
        end loop;	
		
		
		--start at index 6.
		CNTH_index_contr := 80;
		  for i in 0 to 15 loop
            if rs1(CNTH_index_contr) = '1' then
                CNTH_counter_6 := CNTH_counter_6 + 1;  -- Increment the counter for each '1' bit
          		CNTH_index_contr := CNTH_index_contr + 1;
				   else
			CNTH_index_contr := CNTH_index_contr + 1; 
				end if;
        end loop;	
		
		
		--start at index 7.
		CNTH_index_contr := 96;
		  for i in 0 to 15 loop
            if rs1(CNTH_index_contr) = '1' then
                CNTH_counter_7 := CNTH_counter_7 + 1;  -- Increment the counter for each '1' bit
         		CNTH_index_contr := CNTH_index_contr + 1;  
				  else
			CNTH_index_contr := CNTH_index_contr + 1; 
				end if;
        end loop;	
	  
	  
		--start at index 8.
		CNTH_index_contr := 112;
		  for i in 0 to 15 loop
            if rs1(CNTH_index_contr) = '1' then
                CNTH_counter_8 := CNTH_counter_8 + 1;  -- Increment the counter for each '1' bit
          		CNTH_index_contr := CNTH_index_contr + 1;  
				   else
			CNTH_index_contr := CNTH_index_contr + 1; 
				end if;
      	 end loop;	
		
		
	  --for 1-8 slices.	  
		  
		  
		  
		 -- Cast the generic integer to a 16-bit std_logic_vector
        CNTH_counter_1_vector := std_logic_vector(to_unsigned(CNTH_counter_1, 16));
		CNTH_counter_2_vector := std_logic_vector(to_unsigned(CNTH_counter_2, 16));
		CNTH_counter_3_vector := std_logic_vector(to_unsigned(CNTH_counter_3, 16));
		CNTH_counter_4_vector := std_logic_vector(to_unsigned(CNTH_counter_4, 16));
		CNTH_counter_5_vector := std_logic_vector(to_unsigned(CNTH_counter_5, 16));
		CNTH_counter_6_vector := std_logic_vector(to_unsigned(CNTH_counter_6, 16));	  
		CNTH_counter_7_vector := std_logic_vector(to_unsigned(CNTH_counter_7, 16));		
		CNTH_counter_8_vector := std_logic_vector(to_unsigned(CNTH_counter_8, 16));
		
		
		
        -- Set bits in rd based off the proper ranges counter values.
        rd(15 downto 0) <= CNTH_counter_1_vector;
		rd(31 downto 16) <= CNTH_counter_2_vector;
		rd(47 downto 32) <= CNTH_counter_3_vector;
		rd(63 downto 48) <= CNTH_counter_4_vector;
		rd(79 downto 64) <= CNTH_counter_5_vector;
		rd(95 downto 80) <= CNTH_counter_6_vector;
		rd(111 downto 96) <= CNTH_counter_7_vector;
		rd(127 downto 112) <= CNTH_counter_8_vector;

		
			
			
		when "0100" =>
            -- AHS
       
			
		
	
		 -- Perform additions based on the specified ranges
    R3_16_add_1 := signed(rs1(15 downto 0)) + signed(rs2(15 downto 0));
    R3_16_add_2 := signed(rs1(31 downto 16)) + signed(rs2(31 downto 16));
    R3_16_add_3 := signed(rs1(47 downto 32)) + signed(rs2(47 downto 32));
    R3_16_add_4 := signed(rs1(63 downto 48)) + signed(rs2(63 downto 48));	
    R3_16_add_5 := signed(rs1(79 downto 64)) + signed(rs2(79 downto 64));
    R3_16_add_6 := signed(rs1(95 downto 80)) + signed(rs2(95 downto 80));
    R3_16_add_7 := signed(rs1(111 downto 96)) + signed(rs2(111 downto 96));
    R3_16_add_8 := signed(rs1(127 downto 112)) + signed(rs2(127 downto 112));


 	 --ADD SATURATE CHECK
							 --15,31,47,63,79,95,111,127
	  
		--SEGMENENT 1 SATURATION		
			r3_add_sign_1 := rs1(15) xor rs2(15);          
			--saturation								  
			 --use rs1 for reference
		if (rs1(15) = r3_add_sign_1) then
    		if not(r3_add_sign_1 = R3_16_add_1(15)) then 
            if (r3_add_sign_1 = '1') then R3_16_add_1 := 	"1000000000000000";
            elsif (r3_add_sign_1 = '0') then R3_16_add_1 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if; 

  --SEGMENENT 2 SATURATION	--15,31,47,63,79,95,111,127	
			r3_add_sign_2 := rs1(31) xor rs2(31);          
			--saturation								  
			 --use rs1 for reference
		if (rs1(31) = r3_add_sign_2) then
    if not(r3_add_sign_2 = R3_16_add_2(15)) then 
            if (r3_add_sign_2 = '1') then R3_16_add_2 := "1000000000000000";
            elsif (r3_add_sign_2 = '0') then R3_16_add_2 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if;

   --SEGMENENT 3 SATURATION	--15,31,47,63,79,95,111,127	
			r3_add_sign_3 := rs1(47) xor rs2(47);          
			--saturation								  
			 --use rs1 for reference
		if (rs1(47) = r3_add_sign_3) then
    if not(r3_add_sign_3 = R3_16_add_3(15)) then 
            if (r3_add_sign_3 = '1') then R3_16_add_3 := "1000000000000000";
            elsif (r3_add_sign_3 = '0') then R3_16_add_3 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if;	  



   --SEGMENENT 4 SATURATION	--15,31,47,63,79,95,111,127	
			r3_add_sign_4 := rs1(63) xor rs2(63);          
			--saturation								  
			 --use rs1 for reference
		if (rs1(63) = r3_add_sign_4) then
    if not(r3_add_sign_4 = R3_16_add_4(15)) then 
            if (r3_add_sign_4 = '1') then R3_16_add_4 := "1000000000000000";
            elsif (r3_add_sign_4 = '0') then R3_16_add_4 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if;



   --SEGMENENT 5 SATURATION	--15,31,47,63,79,95,111,127	
			r3_add_sign_5 := rs1(79) xor rs2(79);          
			--saturation								  
			 --use rs1 for reference
		if (rs1(79) = r3_add_sign_5) then
    if not(r3_add_sign_5 = R3_16_add_5(15)) then 
            if (r3_add_sign_5 = '1') then R3_16_add_5 := "1000000000000000";
            elsif (r3_add_sign_5 = '0') then R3_16_add_5 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if;


   --SEGMENENT 6 SATURATION	--15,31,47,63,79,95,111,127	
			r3_add_sign_6 := rs1(95) xor rs2(95);          
			--saturation								  
			 --use rs1 for reference
		if (rs1(95) = r3_add_sign_6) then
    if not(r3_add_sign_6 = R3_16_add_6(15)) then 
            if (r3_add_sign_6 = '1') then R3_16_add_6 := "1000000000000000";
            elsif (r3_add_sign_6 = '0') then R3_16_add_6 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if;


   --SEGMENENT 7 SATURATION	--15,31,47,63,79,95,111,127	
			r3_add_sign_7 := rs1(111) xor rs2(111);          
			--saturation								  
			 --use rs1 for reference
		if (rs1(111) = r3_add_sign_7) then
    if not(r3_add_sign_7 = R3_16_add_7(15)) then 
            if (r3_add_sign_7 = '1') then R3_16_add_7 := "1000000000000000";
            elsif (r3_add_sign_7 = '0') then R3_16_add_7 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if;

   --SEGMENENT 8 SATURATION	--15,31,47,63,79,95,111,127	
			r3_add_sign_8 := rs1(127) xor rs2(127);          
			--saturation								  
			 --use rs1 for reference
		if (rs1(127) = r3_add_sign_8) then
    if not(r3_add_sign_8 = R3_16_add_8(15)) then 
            if (r3_add_sign_8 = '1') then R3_16_add_8 := "1000000000000000";
            elsif (r3_add_sign_8 = '0') then R3_16_add_8 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
            -- Concatenate later.
           
        end if;
    else
        -- Concatenate later.
   
end if;


	  --FINISH THE AHS SATUARTE CHECK!!!

	
    -- having checked for saturation, Combine the results into a single 128-bit vector
    R3_temp_result := (others => '0');
    R3_temp_result(15 downto 0) := R3_16_add_1 (15 downto 0);
    R3_temp_result(31 downto 16) := R3_16_add_2 (15 downto 0);
    R3_temp_result(47 downto 32)  := R3_16_add_3 (15 downto 0);
    R3_temp_result(63 downto 48) := R3_16_add_4 (15 downto 0);
    R3_temp_result(79 downto 64) := R3_16_add_5 (15 downto 0);
    R3_temp_result(95 downto 80)  := R3_16_add_6 (15 downto 0);
    R3_temp_result(111 downto 96) := R3_16_add_7 (15 downto 0);
    R3_temp_result(127 downto 112)  := R3_16_add_8 (15 downto 0);


       -- Assign the result to rd
    rd <= std_logic_vector(R3_temp_result);		

 	
			
			
		when "0101" =>
            -- OR
         
			rd <= rs1 or rs2;

			
			
		when "0110" =>
            -- BCW
         
			-- most signofocant 32 bits of rs1 are cast to every 32 bit slice of rd
			
	rd(31 downto 0) <= std_logic_vector(rs1(31 downto 0));
    rd(63 downto 32) <= std_logic_vector(rs1(31 downto 0));
    rd(95 downto 64) <= std_logic_vector(rs1(31 downto 0));
    rd(127 downto 96) <= std_logic_vector(rs1(31 downto 0));
	
	
		when "0111" =>
		-- MAXWS	  
		
		
		--compare rs1 and rs2 slice 1 
		
		MAXWS_rs1 := to_integer(signed(rs1(31 downto 0)));
		MAXWS_rs2 := to_integer(signed(rs2(31 downto 0)));
		
		 if MAXWS_rs1 >= MAXWS_rs2 then
        -- Store rs1 value in rd
        rd(31 downto 0) <= std_logic_vector(to_signed(MAXWS_rs1, 32));
    else
        -- Store rs2 value in rd
        rd(31 downto 0) <= std_logic_vector(to_signed(MAXWS_rs2, 32));
    end if;
    
		
		--compare rs1 and rs2 slice 2 
		
		MAXWS_rs1 := to_integer(signed(rs1(63 downto 32)));
		MAXWS_rs2 := to_integer(signed(rs2(63 downto 32)));
		
		 if MAXWS_rs1 >= MAXWS_rs2 then
        -- Store rs1 value in rd
        rd(63 downto 32) <= std_logic_vector(to_signed(MAXWS_rs1, 32));
    else
        -- Store rs2 value in rd
        rd(63 downto 32) <= std_logic_vector(to_signed(MAXWS_rs2, 32));
    end if;   
			
			
		
		--compare rs1 and rs2 slice 3 
		
		MAXWS_rs1 := to_integer(signed(rs1(95 downto 64)));
		MAXWS_rs2 := to_integer(signed(rs2(95 downto 64)));
		
		 if MAXWS_rs1 >= MAXWS_rs2 then
        -- Store rs1 value in rd
        rd(95 downto 64) <= std_logic_vector(to_signed(MAXWS_rs1, 32));
    else
        -- Store rs2 value in rd
        rd(95 downto 64) <= std_logic_vector(to_signed(MAXWS_rs2, 32));
    end if;   
				
			   
	   
		--compare rs1 and rs2 slice 4 
		
		MAXWS_rs1 := to_integer(signed(rs1(127 downto 96)));
		MAXWS_rs2 := to_integer(signed(rs2(127 downto 96)));
		
		 if MAXWS_rs1 >= MAXWS_rs2 then
        -- Store rs1 value in rd
        rd(127 downto 96) <= std_logic_vector(to_signed(MAXWS_rs1, 32));
    else
        -- Store rs2 value in rd
        rd(127 downto 96) <= std_logic_vector(to_signed(MAXWS_rs2, 32));
    end if;   
				
			   
	
			
		when "1001" =>
            -- MLHU
        
			
		
   
 -- Multiply low of the 4 different 32-bit slices
        R3_32_mult_1 := unsigned(rs2(15 downto 0)) * unsigned(rs1(15 downto 0));
        
		R3_32_mult_2 := unsigned(rs2(47 downto 32)) * unsigned(rs1(47 downto 32));
        R3_32_mult_3 := unsigned(rs2(79 downto 64)) * unsigned(rs1(79 downto 64));
        R3_32_mult_4 := unsigned(rs2(111 downto 96)) * unsigned(rs1(111 downto 96));
			
		
    -- Combine the results into a single 128-bit vector
    R3_temp_result := (others => '0');
    R3_temp_result(31 downto 0) :=  signed(R3_32_mult_1(31 downto 0));
    R3_temp_result(63 downto 32) :=  signed(R3_32_mult_2(31 downto 0));
    R3_temp_result(95 downto 64) :=  signed(R3_32_mult_3(31 downto 0));
    R3_temp_result(127 downto 96) :=  signed(R3_32_mult_4(31 downto 0));

    -- Assign the result to rd
    rd <= std_logic_vector(R3_temp_result);		
			
		
			
		when "1010" =>
            -- MLHSS
		
 -- Multiply 16 bit slices of the 4 different 16-bit slices
 
 --MLHSS: multiply by sign saturated: each of the eight signed 16-bit halfword values in register rs1 is multiplied by the sign of the corresponding signed 16-bit halfword value in register rs2 with saturation, 
 --and the result placed in register rd . If a value in a 16-bit register rs2 field is zero, the corresponding 16-bit field in rd will also be zero. (Comments: 8 separate 16-bit values in each 128-bit register)
		
	
 ----NEED TO REWRITE THIS WHOLE THING MULTPLY BY SIGN!
 ---IF ZERO SET TO ZERO!
	
	 
	 	   --SEGMENT 1
	 if (rs2(15 downto 0) = "0000000000000000") then
      -- Case 1: rs2 is zero, result should be set to 0
      R3_16_mult_1 := (others => '0');
    else
      -- Case 2: rs2 is non-zero, result is the product with the sign adjustment
      if rs2(15) = '0' then
        R3_16_mult_1 := signed(rs1(15 downto 0));
      else
         R3_16_mult_1 := -signed(rs1(15 downto 0));
      end if;
    end if;
	 
	  
	 	   --SEGMENT 2
	 if (rs2(31 downto 16) = "0000000000000000") then
      -- Case 1: rs2 is zero, result should be set to 0
      R3_16_mult_2 := (others => '0');
    else
      -- Case 2: rs2 is non-zero, result is the product with the sign adjustment
      if rs2(31) = '0' then
        R3_16_mult_2 := signed(rs1(31 downto 16));
      else
         R3_16_mult_2 := -signed(rs1(31 downto 16));
      end if;
    end if;
	
	 
	 	   --SEGMENT 3
	 if (rs2(47 downto 32) = "0000000000000000") then
      -- Case 1: rs2 is zero, result should be set to 0
      R3_16_mult_3 := (others => '0');
    else
      -- Case 2: rs2 is non-zero, result is the product with the sign adjustment
      if rs2(47) = '0' then
        R3_16_mult_3 := signed(rs1(47 downto 32));
      else
         R3_16_mult_3 := -signed(rs1(47 downto 32));
      end if;
    end if;
	
	 
	 	   --SEGMENT 4
	 if (rs2(63 downto 48) = "0000000000000000") then
      -- Case 1: rs2 is zero, result should be set to 0
      R3_16_mult_4 := (others => '0');
    else
      -- Case 2: rs2 is non-zero, result is the product with the sign adjustment
      if rs2(63) = '0' then
        R3_16_mult_4 := signed(rs1(63 downto 48));
      else
         R3_16_mult_4 := -signed(rs1(63 downto 48));
      end if;
    end if;
	
	 
	 	   --SEGMENT 5
	 if (rs2(79 downto 64) = "0000000000000000") then
      -- Case 1: rs2 is zero, result should be set to 0
      R3_16_mult_5 := (others => '0');
    else
      -- Case 2: rs2 is non-zero, result is the product with the sign adjustment
      if rs2(79) = '0' then
        R3_16_mult_5 := signed(rs1(79 downto 64));
      else
         R3_16_mult_5 := -signed(rs1(79 downto 64));
      end if;
    end if;
	
	 
	 	   --SEGMENT 6
	 if (rs2(95 downto 80) = "0000000000000000") then
      -- Case 1: rs2 is zero, result should be set to 0
      R3_16_mult_6 := (others => '0');
    else
      -- Case 2: rs2 is non-zero, result is the product with the sign adjustment
      if rs2(95) = '0' then
        R3_16_mult_6 := signed(rs1(95 downto 80));
      else
         R3_16_mult_6 := -signed(rs1(95 downto 80));
      end if;
    end if;
	
	 
	 	   --SEGMENT 7
	 if (rs2(111 downto 96) = "0000000000000000") then
      -- Case 1: rs2 is zero, result should be set to 0
      R3_16_mult_7 := (others => '0');
    else
      -- Case 2: rs2 is non-zero, result is the product with the sign adjustment
      if rs2(111) = '0' then
        R3_16_mult_7 := signed(rs1(111 downto 96));
      else
         R3_16_mult_7 := -signed(rs1(111 downto 96));
      end if;
    end if;

	  
	 	   --SEGMENT 8
	 if (rs2(127 downto 112) = "0000000000000000") then
      -- Case 1: rs2 is zero, result should be set to 0
      R3_16_mult_8 := (others => '0');
    else
      -- Case 2: rs2 is non-zero, result is the product with the sign adjustment
      if rs2(127) = '0' then
        R3_16_mult_8 := signed(rs1(127 downto 112));
      else
         R3_16_mult_8 := -signed(rs1(127 downto 112));
      end if;
    end if;
		
			
	-- Combine the results into a single 128-bit vector
		R3_temp_result := (others => '0');
		R3_temp_result(15 downto 0) := R3_16_mult_1 (15 downto 0);
		R3_temp_result(31 downto 16) := R3_16_mult_2 (15 downto 0);
		R3_temp_result(47 downto 32)  := R3_16_mult_3 (15 downto 0);
		R3_temp_result(63 downto 48) := R3_16_mult_4 (15 downto 0);
		R3_temp_result(79 downto 64) := R3_16_mult_5 (15 downto 0);
		R3_temp_result(95 downto 80)  := R3_16_mult_6 (15 downto 0);
		R3_temp_result(111 downto 96) := R3_16_mult_7 (15 downto 0);
		R3_temp_result(127 downto 112)  := R3_16_mult_8 (15 downto 0);


       -- Assign the result to rd
    rd <= std_logic_vector(R3_temp_result);		
		
			
			
			
			
		when "1011" =>
            -- AND
      
			
		 rd <= rs1 and rs2;

			
		when "1100" =>
            -- INVB
        
		rd <= not rs1;
	
			
			
		when "1101" =>
            -- ROTW
         
			
				-- Extract bits from OpCode and cast to integer for shift amount
        rotate_amount := to_integer(unsigned(rs2(4 downto 0)));   
		
		
		 -- Rotate rs1(31 downto 0) to the right by rotation_amount
		temp_rotated_out (rotate_amount-1 downto 0) := rs1(rotate_amount-1 downto 0)  ;
		ROTW_rotated_1 :=  std_logic_vector(shift_right(unsigned(rs1(31 downto 0)), rotate_amount)); 
		ROTW_rotated_1 (31 downto (31-rotate_amount+1)) := temp_rotated_out (rotate_amount-1 downto 0);
		
		
		rotate_amount := to_integer(unsigned(rs2(36 downto 32))); 
		
		 -- Rotate rs1(31 downto 0) to the right by rotation_amount
		temp_rotated_out (rotate_amount-1 downto 0) := rs1( 32 + rotate_amount -1  downto 32)  ;
		ROTW_rotated_2 :=  std_logic_vector(shift_right(unsigned(rs1(63 downto 32)), rotate_amount)); 
		ROTW_rotated_2 (31 downto (31-rotate_amount+1)) := temp_rotated_out (rotate_amount -1 downto 0);
		
		
		rotate_amount := to_integer(unsigned(rs2(68 downto 64))); 
		
		
		 -- Rotate rs1(31 downto 0) to the right by rotation_amount
		temp_rotated_out (rotate_amount-1 downto 0) := rs1(64 + rotate_amount -1 downto 64)  ;  
		ROTW_rotated_3 :=  std_logic_vector(shift_right(unsigned(rs1(95 downto 64)), rotate_amount)); 	
		ROTW_rotated_3 (31 downto (31-rotate_amount+1)) := temp_rotated_out (rotate_amount-1 downto 0);
		
		
		rotate_amount := to_integer(unsigned(rs2(100 downto 96))); 
		
		
		-- Rotate rs1(31 downto 0) to the right by rotation_amount
		temp_rotated_out (rotate_amount-1 downto 0) := rs1(96 + rotate_amount -1 downto 96)  ;	  
		ROTW_rotated_4 :=  std_logic_vector(shift_right(unsigned(rs1(127 downto 96)), rotate_amount));
		ROTW_rotated_4 (31 downto (31-rotate_amount+1)) := temp_rotated_out (rotate_amount-1 downto 0);
		
						
    -- Store the rotated value in rd(31 downto 0)
    rd(31 downto 0) <= ROTW_rotated_1;
	rd(63 downto 32) <= ROTW_rotated_2;
	rd(95 downto 64) <= ROTW_rotated_3;
	rd(127 downto 96) <= ROTW_rotated_4;
			
			
			
		when "1110" =>
            -- SFWU
			
			 -- Perform subtractions based on the specified ranges
    R3_32_sub_1:= unsigned(rs2(31 downto 0)) - unsigned(rs1(31 downto 0)) ;
    R3_32_sub_2:= unsigned(rs2(63 downto 32)) - unsigned(rs1(63 downto 32)) ;
    R3_32_sub_3:= unsigned(rs2(95 downto 64)) - unsigned(rs1(95 downto 64))	 ;
    R3_32_sub_4:= unsigned(rs2(127 downto 96)) - unsigned(rs1(127 downto 96)) ;
				 
	
    -- having checked for saturation, Combine the results into a single 128-bit vector
    R3_temp_result := (others => '0');
    R3_temp_result(31 downto 0) := signed(R3_32_sub_1(31 downto 0));
    R3_temp_result(63 downto 32) := signed(R3_32_sub_2(31 downto 0));
    R3_temp_result(95 downto 64) := signed(R3_32_sub_3(31 downto 0));
    R3_temp_result(127 downto 96) := signed(R3_32_sub_4(31 downto 0));

    -- Assign the result to rd
    rd <= std_logic_vector(R3_temp_result);	
			
			
			
		when "1111" =>
            -- SFHS
          
			
	
		 -- Perform subtractions based on the specified ranges
    R3_16_sub_1 := signed(rs2(15 downto 0))- signed(rs1(15 downto 0));
    R3_16_sub_2 := signed(rs2(31 downto 16)) - signed(rs1(31 downto 16));
    R3_16_sub_3 := signed(rs2(47 downto 32)) -  signed(rs1(47 downto 32));
    R3_16_sub_4 := signed(rs2(63 downto 48)) - signed(rs1(63 downto 48)) ;	
    R3_16_sub_5 := signed(rs2(79 downto 64)) - signed(rs1(79 downto 64));
    R3_16_sub_6 := signed(rs2(95 downto 80)) - signed(rs1(95 downto 80));
    R3_16_sub_7 := signed(rs2(111 downto 96)) - signed(rs1(111 downto 96));
    R3_16_sub_8 := signed(rs2(127 downto 112)) - signed(rs1(127 downto 112));


 	 --SUB SATURATE CHECK

	
	  
	 
		--SEGMENENT 1 SATURATION		
		R3_16_sub_sat_1 := to_integer(signed(rs2(15 downto 0))) - to_integer(signed(rs1(15 downto 0)));	  
		if (R3_16_sub_sat_1 > 32767 )then R3_16_sub_1 := "0111111111111111";
        elsif (R3_16_sub_sat_1  < -32768 )then R3_16_sub_1 := "1000000000000000";
        end if; 		
			
	  					   
	  		
	--SEGMENENT TWO SATURATION
       	R3_16_sub_sat_2 := to_integer(signed(rs2(31 downto 16))) - to_integer(signed(rs1(31 downto 16)));	  
		if (R3_16_sub_sat_2 > 32767  ) then R3_16_sub_2 := "0111111111111111";
        elsif (R3_16_sub_sat_2  < -32768 ) then R3_16_sub_2 := "1000000000000000" ;
        end if; 
	
	--SEGMENENT THREE SATURATION
       	R3_16_sub_sat_3 := to_integer(signed(rs2(47 downto 32))) - to_integer(signed(rs1(47 downto 32)));	  
		if (R3_16_sub_sat_3 > 32767 )then R3_16_sub_3 := "0111111111111111";
        elsif (R3_16_sub_sat_3  < -32768 )then R3_16_sub_3 := "1000000000000000";
        end if; 

	--SEGMENENT FOUR SATURATION
       	R3_16_sub_sat_4 := to_integer(signed(rs2(63 downto 48))) - to_integer(signed(rs1(63 downto 48)));	  
		if (R3_16_sub_sat_4 > 32767 ) then R3_16_sub_4 := "0111111111111111" ;
        elsif (R3_16_sub_sat_4  < -32768 ) then R3_16_sub_4 := "1000000000000000"  ;
        end if; 

		
	--SEGMENENT FIVE SATURATION
       	R3_16_sub_sat_5 := to_integer(signed(rs2(79 downto 64))) - to_integer(signed(rs1(79 downto 64)));	  
		if (R3_16_sub_sat_5 > 32767 ) then R3_16_sub_5 := "0111111111111111" ;
        elsif (R3_16_sub_sat_5  < -32768 ) then R3_16_sub_5 := "1000000000000000"  ;
        end if; 	
	
	--SEGMENENT SIX SATURATION
       	R3_16_sub_sat_6 := to_integer(signed(rs2(95 downto 80))) - to_integer(signed(rs1(95 downto 80)));	  
		if (R3_16_sub_sat_6 > 32767 ) then R3_16_sub_6 := "0111111111111111" ;
        elsif (R3_16_sub_sat_6  < -32768 ) then R3_16_sub_6 := "1000000000000000"  ;
        end if; 	
		
	--SEGMENENT SEVEN SATURATION
       	R3_16_sub_sat_7 := to_integer(signed(rs2(111 downto 96))) - to_integer(signed(rs1(111 downto 96)));	  
		if (R3_16_sub_sat_7 > 32767 ) then R3_16_sub_7 := "0111111111111111" ;
        elsif (R3_16_sub_sat_7  < -32768 ) then R3_16_sub_7 := "1000000000000000"  ;
        end if; 	
		
	--SEGMENENT EIGHT SATURATION
       	R3_16_sub_sat_8 := to_integer(signed(rs2(127 downto 112))) - to_integer(signed(rs1(127 downto 112)));	  
		if (R3_16_sub_sat_8 > 32767 ) then R3_16_sub_8 := "0111111111111111" ;
        elsif (R3_16_sub_sat_8  < -32768 ) then R3_16_sub_8 := "1000000000000000"  ;
        end if; 	



							  --FINISH THIS 

	
    -- having checked for saturation, Combine the results into a single 128-bit vector
    R3_temp_result := (others => '0');
    R3_temp_result(15 downto 0) := R3_16_sub_1 (15 downto 0);
    R3_temp_result(31 downto 16) := R3_16_sub_2 (15 downto 0);
    R3_temp_result(47 downto 32)  := R3_16_sub_3 (15 downto 0);
    R3_temp_result(63 downto 48) := R3_16_sub_4 (15 downto 0);
    R3_temp_result(79 downto 64) := R3_16_sub_5 (15 downto 0);
    R3_temp_result(95 downto 80)  := R3_16_sub_6 (15 downto 0);
    R3_temp_result(111 downto 96) := R3_16_sub_7 (15 downto 0);
    R3_temp_result(127 downto 112)  := R3_16_sub_8 (15 downto 0);


       -- Assign the result to rd
    rd <= std_logic_vector(R3_temp_result);		

 	
			
			
        when others =>
            -- 
            rd <= (others => '0'); -- Default behavior when condition is not met
    end case;
	
	
		  -- extraneous case for the one 5 bit instrcution label
case OpCode(19 downto 15) is
	when "01000" =>
            -- MINWS
			
			
			  
		--compare rs1 and rs2 slice 1 
		
		MINWS_rs1 := to_integer(signed(rs1(31 downto 0)));
		MINWS_rs2 := to_integer(signed(rs2(31 downto 0)));
		
		 if MINWS_rs1 <= MINWS_rs2 then
        -- Store rs1 value in rd
        rd(31 downto 0) <= std_logic_vector(to_signed(MINWS_rs1, 32));
    else
        -- Store rs2 value in rd
        rd(31 downto 0) <= std_logic_vector(to_signed(MINWS_rs2, 32));
    end if;
    
		
		--compare rs1 and rs2 slice 2 
		
		MAXWS_rs1 := to_integer(signed(rs1(63 downto 32)));
		MAXWS_rs2 := to_integer(signed(rs2(63 downto 32)));
		
		
		 if MINWS_rs1 <= MINWS_rs2 then
        -- Store rs1 value in rd
        rd(63 downto 32) <= std_logic_vector(to_signed(MINWS_rs1, 32));
    else
        -- Store rs2 value in rd
        rd(63 downto 32) <= std_logic_vector(to_signed(MINWS_rs2, 32));
    end if;
		

		
		--compare rs1 and rs2 slice 3 
		
		MINWS_rs1 := to_integer(signed(rs1(95 downto 64)));
		MINWS_rs2 := to_integer(signed(rs2(95 downto 64)));
		
		 if MINWS_rs1 <= MINWS_rs2 then
        -- Store rs1 value in rd
        rd(95 downto 64) <= std_logic_vector(to_signed(MINWS_rs1, 32));
    else
        -- Store rs2 value in rd
        rd(95 downto 64) <= std_logic_vector(to_signed(MINWS_rs2, 32));
    end if;
				
			   
	   
		--compare rs1 and rs2 slice 4 
		
		MINWS_rs1 := to_integer(signed(rs1(127 downto 96)));
		MINWS_rs2 := to_integer(signed(rs2(127 downto 96)));
		
		  if MINWS_rs1 <= MINWS_rs2 then
        -- Store rs1 value in rd
        rd(127 downto 96) <= std_logic_vector(to_signed(MINWS_rs1, 32));
    else
        -- Store rs2 value in rd
        rd(127 downto 96) <= std_logic_vector(to_signed(MINWS_rs2, 32));
    end if;
			
 			
	when others =>
          
            
   	 end case;
	
	
	
	end if;	
-- R3 END 
 	else 
		   
				--Valid_Instruction_Out <= '0';	
		
	 end if;	 
	 
	 
	
	 

  end process;
	
end architecture behavioral;