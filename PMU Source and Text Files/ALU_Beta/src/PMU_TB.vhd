library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use work.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;		   
use std.textio.all;	


entity PMU_TB is 

end PMU_TB;


architecture testbench of PMU_TB is	 


-- Internal signal to hold the value read from the file
  signal read_in_value  : std_logic_vector(127 downto 0);
  signal success : boolean := true;	  
	

file ResultsFile : text;

--signals 
--loop control and misc	
	signal reg_count  : integer := 0;
	signal count : integer := 0;
	signal cycle_count : integer := 0; 
	signal INDEX_BITS  : integer := 0;
 	 signal reg_image : std_logic_vector(127 downto 0);
	
---INTO the PMU------------------------------

signal clk, hold            :  std_logic;-- system clock
signal reset_bar      :  std_logic;-- system reset
signal PMU_INSTRUCTION_IN		 :  std_logic_vector(24 downto 0);
signal Instruction_Number_Programming :  std_logic_vector(6 downto 0); 


---OUT OF the PMU----------------------------

--S1
signal S1_PC  :  std_logic_vector(5 downto 0);
signal ProgramMemoryIB:  std_logic_vector (1650 downto 0); 	
signal S1_NextInstruction :  std_logic_vector(24 downto 0);

--S2
signal S2_Instruction:  std_logic_vector(24 downto 0);	
signal RegisterfFileData :  std_logic_vector (4095 downto 0);
signal S2_RF_rs1:  std_logic_vector(127 downto 0);
signal S2_RF_rs2:  std_logic_vector(127 downto 0);
signal S2_RF_rs3:  std_logic_vector(127 downto 0); 
signal S2_RF_opcode:  std_logic_vector(24 downto 0);

--S3
signal S3_IDEXregrs1_to_EX: std_logic_vector(127 downto 0);
signal S3_IDEXregrs2_to_EX:  std_logic_vector(127 downto 0);
signal S3_IDEXregrs3_to_EX:  std_logic_vector(127 downto 0); 
signal S3_IDEXregopcode_to_EX:  std_logic_vector(24 downto 0);	   
signal S3_rd_alu:  std_logic_vector(127 downto 0); 
signal S3_op_alu:  std_logic_vector(24 downto 0);	   
signal S3_ForwardedData:  std_logic_vector(127 downto 0); 
signal S3_ForwardedOpCode:  std_logic_vector(24 downto 0);

--S4
signal S4_EX_WBreg_rd:  std_logic_vector(127 downto 0); 
signal S4_EX_WBreg_op:  std_logic_vector(24 downto 0);	   
signal S4_Write_Enable:  std_logic;

--RF
signal			reg_0_out: std_logic_vector(127 downto 0); 
signal			reg_1_out: std_logic_vector(127 downto 0);
signal			reg_2_out: std_logic_vector(127 downto 0);
signal			reg_3_out: std_logic_vector(127 downto 0);
signal			reg_4_out: std_logic_vector(127 downto 0);
signal			reg_5_out: std_logic_vector(127 downto 0);
signal			reg_6_out: std_logic_vector(127 downto 0);
signal			reg_7_out: std_logic_vector(127 downto 0);
signal			reg_8_out: std_logic_vector(127 downto 0);
signal			reg_9_out: std_logic_vector(127 downto 0);
signal			reg_10_out: std_logic_vector(127 downto 0);
signal			reg_11_out: std_logic_vector(127 downto 0);
signal			reg_12_out: std_logic_vector(127 downto 0);
signal			reg_13_out: std_logic_vector(127 downto 0);
signal			reg_14_out: std_logic_vector(127 downto 0);
signal			reg_15_out: std_logic_vector(127 downto 0);
signal			reg_16_out: std_logic_vector(127 downto 0);
signal			reg_17_out: std_logic_vector(127 downto 0);
signal			reg_18_out: std_logic_vector(127 downto 0);
signal			reg_19_out: std_logic_vector(127 downto 0);
signal			reg_20_out: std_logic_vector(127 downto 0);
signal			reg_21_out: std_logic_vector(127 downto 0);
signal			reg_22_out: std_logic_vector(127 downto 0);
signal			reg_23_out: std_logic_vector(127 downto 0);
signal			reg_24_out: std_logic_vector(127 downto 0);
signal			reg_25_out: std_logic_vector(127 downto 0);
signal			reg_26_out: std_logic_vector(127 downto 0);
signal			reg_27_out: std_logic_vector(127 downto 0);
signal			reg_28_out: std_logic_vector(127 downto 0);
signal			reg_29_out: std_logic_vector(127 downto 0);
signal			reg_30_out: std_logic_vector(127 downto 0);
signal			reg_31_out: std_logic_vector(127 downto 0);
			
			
			
begin
	
	 -- Instantiate the ALU
    PMU_Instance: entity work.PMU
        port map (	
	   clk => clk , reset_bar => reset_bar, hold => hold , Instruction_Number_Programming => Instruction_Number_Programming, PMU_INSTRUCTION_IN => PMU_INSTRUCTION_IN,  S1_PC => S1_PC, 
	   ProgramMemoryIB => ProgramMemoryIB, S1_NextInstruction => S1_NextInstruction, S2_Instruction => S2_Instruction, RegisterfFileData => RegisterfFileData , S2_RF_rs1 => S2_RF_rs1, 
	   S2_RF_rs2 => S2_RF_rs2, S2_RF_rs3 => S2_RF_rs3,  S2_RF_opcode => S2_RF_opcode, S3_IDEXregrs1_to_EX => S3_IDEXregrs1_to_EX ,  S3_IDEXregrs2_to_EX => S3_IDEXregrs2_to_EX, 
	   S3_IDEXregrs3_to_EX => S3_IDEXregrs3_to_EX, S3_IDEXregopcode_to_EX =>S3_IDEXregopcode_to_EX , S3_rd_alu => S3_rd_alu, S3_op_alu => S3_op_alu,  S3_ForwardedData => S3_ForwardedData, 
	   S3_ForwardedOpCode => S3_ForwardedOpCode, S4_EX_WBreg_rd => S4_EX_WBreg_rd, S4_EX_WBreg_op => S4_EX_WBreg_op , S4_Write_Enable => S4_Write_Enable, reg_0_out=>reg_0_out, reg_1_out=>reg_1_out, reg_2_out=>reg_2_out, reg_3_out=>reg_3_out, reg_4_out=>reg_4_out, reg_5_out=>reg_5_out, reg_6_out=>reg_6_out, reg_7_out=>reg_7_out, 
	reg_8_out=>reg_8_out, reg_9_out=>reg_9_out, reg_10_out=>reg_10_out, reg_11_out=>reg_11_out, reg_12_out=>reg_12_out, reg_13_out=>reg_13_out, reg_14_out=>reg_14_out, reg_15_out=>reg_15_out, 
	reg_16_out=>reg_16_out, reg_17_out=>reg_17_out, reg_18_out=>reg_18_out, reg_19_out=>reg_19_out, reg_20_out=>reg_20_out, reg_21_out=>reg_21_out, reg_22_out=>reg_22_out, reg_23_out=>reg_23_out, 
	reg_24_out=>reg_24_out, reg_25_out=>reg_25_out, reg_26_out=>reg_26_out, reg_27_out=>reg_27_out, reg_28_out=>reg_28_out, reg_29_out=>reg_29_out, reg_30_out=>reg_30_out, reg_31_out=>reg_31_out 
	   	);
										 

  
  -- start of programming and then start the system process
  stimulus_process: process
 
  -- File handling variables
  file input_file : text open read_mode is "input_data.txt";
  file expected : text open read_mode is "expectedresults.txt";  
  	
  
  
  
   
  variable out_line : line;
  variable bit_string : string(1 to 25);  
  variable long_bit_string : string(1 to 128);
  
  	variable reg_count  : integer := 0;
  begin			  
			  
  -- Open the file for writing
    file_open(ResultsFile, "results.txt", write_mode); 
 -- Open the file for reading
  file_open(expected, "expectedresults.txt", read_mode);	
    -- Write "hello" to the file
   -- write(out_line, "hello");
   -- writeline(ResultsFile, out_line);
	
	reset_bar <= '0';			--reset data inside any memory elements 
	
	wait for 10ns;	  
	
	count <= -1;
	hold <= '1';			    --conditions for program stage
	reset_bar <= '1'; 
	clk <= '1';
	 
	  
 while not endfile(input_file) loop
      -- Read a line from the file
      readline(input_file, out_line);

      -- Convert the line to a bit vector
      read(out_line, bit_string);
	  
	  count <= count+1;
	  Instruction_Number_Programming <= std_logic_vector(to_unsigned(count, 7));

	  
			
			for i in 1 to 25 loop 
				
			  if bit_string(i) = '0' then
			    PMU_INSTRUCTION_IN(i - 1) <= '0';				   -- right name?
			  elsif bit_string(i) = '1' then
			    PMU_INSTRUCTION_IN(i - 1) <= '1';
			  else
			    -- Handle error or default case	, it should never get this with proper copiled assembly code.					--BITS TO INPUT
			    PMU_INSTRUCTION_IN(i - 1) <= '0'; -- Default to '0' for an undefined case
			  end if;
			  
			end loop;
	

      -- Apply the data to your entity
      -- (Assuming there's a clocked process)
     
      wait for 10 ns;  -- Adjust the delay as needed
end loop; 

	count <= count+1;
	Instruction_Number_Programming <= std_logic_vector(to_unsigned(count, 7));
	PMU_INSTRUCTION_IN <= "0000000000000010000000011";
	
	wait for 10 ns;  -- Adjust the delay as needed

	hold <= '0'; --end programmer mode
	
	 
	
	for i in 1 to 140 loop							 --enough of a buffer room to execute all prorgams. 
													 --finished loading the program resume normal clock
		clk<= not clk;	
		wait for 10ns;								 
		
		if (clk = '1') then	   -- only after a positive edge i want the results file updated.
		  
  --
--  -- Write to the file   


 -- write(out_line, "hello");
   -- writeline(ResultsFile, out_line);



 write(out_line , "-- " & integer'image(cycle_count) & " Clock Cycles----------------------------", right, 0);
 writeline(ResultsFile, out_line);
 write(out_line, " ", right, 0 );
 writeline(ResultsFile, out_line);
 
--	--S1
		write(out_line, "-- S1");
		writeline(ResultsFile, out_line);
		write(out_line, "S1_PC:                  " & to_string(S1_PC) & "       [6]");
		writeline(ResultsFile, out_line);
--		write(out_line, "ProgramMemoryIB:        " & to_string(ProgramMemoryIB) & " [1624]");
--		writeline(ResultsFile, out_line);
		write(out_line, "S1_NextInstruction:     " & to_string(S1_NextInstruction) & " [25]");
		writeline(ResultsFile, out_line);
		
	-- S2
		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line, "-- S2");
		writeline(ResultsFile, out_line);
		write(out_line, "S2_Instruction:         " & to_string(S2_Instruction) & " [25]");
		writeline(ResultsFile, out_line);

		
--		write(ResultsFile, "RegisterfFileData:      " & to_string(RegisterfFileData) & " [4096]");		 --not this data.
--		writeline(ResultsFile, out_line);
     
	   	-- RF
		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line, "-- RF");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_0_out:              " & to_string(reg_0_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_1_out:              " & to_string(reg_1_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_2_out:              " & to_string(reg_2_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_3_out:              " & to_string(reg_3_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_4_out:              " & to_string(reg_4_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_5_out:              " & to_string(reg_5_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_6_out:              " & to_string(reg_6_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_7_out:              " & to_string(reg_7_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_8_out:              " & to_string(reg_8_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_9_out:              " & to_string(reg_9_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_10_out:             " & to_string(reg_10_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_11_out:             " & to_string(reg_11_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_12_out:             " & to_string(reg_12_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_13_out:             " & to_string(reg_13_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_14_out:             " & to_string(reg_14_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_15_out:             " & to_string(reg_15_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_16_out:             " & to_string(reg_16_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_17_out:             " & to_string(reg_17_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_18_out:             " & to_string(reg_18_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_19_out:             " & to_string(reg_19_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_20_out:             " & to_string(reg_20_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_21_out:             " & to_string(reg_21_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_22_out:             " & to_string(reg_22_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_23_out:             " & to_string(reg_23_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_24_out:             " & to_string(reg_24_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_25_out:             " & to_string(reg_25_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_26_out:             " & to_string(reg_26_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_27_out:             " & to_string(reg_27_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_28_out:             " & to_string(reg_28_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_29_out:             " & to_string(reg_29_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_30_out:             " & to_string(reg_30_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_31_out:             " & to_string(reg_31_out) & " [128]");
		writeline(ResultsFile, out_line);
		

		 write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);

		write(out_line, "S2_RF_rs1:              " & to_string(S2_RF_rs1) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S2_RF_rs2:              " & to_string(S2_RF_rs2) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S2_RF_rs3:              " & to_string(S2_RF_rs3) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S2_RF_opcode:           " & to_string(S2_RF_opcode) & " [25]");
		writeline(ResultsFile, out_line);


--		
--	-- S3
		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line, " S3");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_IDEXregrs1_to_EX:    " & to_string(S3_IDEXregrs1_to_EX) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_IDEXregrs2_to_EX:    " & to_string(S3_IDEXregrs2_to_EX) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_IDEXregrs3_to_EX:    " & to_string(S3_IDEXregrs3_to_EX) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_IDEXregopcode_to_EX: " & to_string(S3_IDEXregopcode_to_EX) & " [25]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_rd_alu:              " & to_string(S3_rd_alu) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_op_alu:              " & to_string(S3_op_alu) & " [25]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_ForwardedData:       " & to_string(S3_ForwardedData) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_ForwardedOpCode:     " & to_string(S3_ForwardedOpCode) & " [25]");
		writeline(ResultsFile, out_line);



--		
--	-- S4
		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line, "-- S4");
		writeline(ResultsFile, out_line);
		write(out_line, "S4_EX_WBreg_rd:         " & to_string(S4_EX_WBreg_rd) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S4_EX_WBreg_op:         " & to_string(S4_EX_WBreg_op) & " [25]");
		writeline(ResultsFile, out_line);
		write(out_line, "S4_Write_Enable:        " & to_string(S4_Write_Enable));
		writeline(ResultsFile, out_line);


		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		
	   cycle_count <= cycle_count +1;
			
		else 
			
		end if;
		
		
		
							  
	end loop;	
	
	
	
	   --GRAB FINAL STATES OF THE REGISTERS AND ASSSERTS THOSE ONLY THE PROPER SLICES OF THE RF. 
		-- Read values from the file until the end
        while not endfile(expected) loop
           
			
			-- Read a line from the file
            readline(expected, out_line);

            -- Convert the line to a bit vector
            read(out_line, long_bit_string);

            -- Assign values to read_in_value
            for t in 1 to 128 loop
                if long_bit_string(t) = '0' then
                    read_in_value(t - 1) <= '0';
                elsif long_bit_string(t) = '1' then
                    read_in_value(t - 1) <= '1';
                else
                    -- Handle error or default case
                    read_in_value(t - 1) <= '0'; -- Default to '0' for an undefined case
                end if;
            end loop; 
			
			wait for 10 ns;  -- Adjust the delay as needed
			
					   for i in 0 to 127 loop
      				reg_image(i) <= read_in_value(127 - i);
    			 end loop;	 
			wait for 10 ns;	 
			
			
         case reg_count is    
		   
			 
			when 0 =>
            -- Check reg_0_out, add your specific success criteria
            if reg_0_out /= reg_image then
                success <= false;
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;	
			when 1 =>
            
            if reg_1_out /= reg_image then
                success <= false;
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 2 =>
            
            if reg_2_out /= reg_image then
                success <= false; 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 3 =>
            
            if reg_3_out /= reg_image then
                success <= false;  
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 4 =>
            
            if reg_4_out /= reg_image then
                success <= false;  
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 5 =>
            
            if reg_5_out /= reg_image then
                success <= false;	
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 6 =>
            
            if reg_6_out /= reg_image then
                success <= false;  
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 7 =>
            
            if reg_7_out /= reg_image then
                success <= false;	
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 8 =>
            
            if reg_8_out /= reg_image then
                success <= false; 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 9 =>
            
            if reg_9_out /= reg_image then
                success <= false; 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 10 =>
            
            if reg_10_out /= reg_image then
                success <= false;
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 11 =>
            
            if reg_11_out /= reg_image then
                success <= false; 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 12 =>
            
            if reg_12_out /= reg_image then
                success <= false;  
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 13 =>
            
            if reg_13_out /= reg_image then
                success <= false; 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 14 =>
            
            if reg_14_out /= reg_image then
                success <= false; 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 15 =>
            
            if reg_15_out /= reg_image then
                success <= false;	
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 16 =>
            
            if reg_16_out /= reg_image then
                success <= false;	
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 17 =>
            
            if reg_17_out /= reg_image then
                success <= false;	 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 18 =>
            
            if reg_18_out /= reg_image then
                success <= false;	
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 19 =>
            
            if reg_19_out /= reg_image then
                success <= false;	
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 20 =>
            
            if reg_20_out /= reg_image then
                success <= false;  
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 21 =>
            
            if reg_21_out /= reg_image then
                success <= false; 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 22 =>
            
            if reg_22_out /= reg_image then
                success <= false;  
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 23 =>
            
            if reg_23_out /= reg_image then
                success <= false;  
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 24 =>
            
            if reg_24_out /= reg_image then
                success <= false;		
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 25 =>
            
            if reg_25_out /= reg_image then
                success <= false;	 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 26 =>
            
            if reg_26_out /= reg_image then
                success <= false;  
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 27 =>
            
            if reg_27_out /= reg_image then
                success <= false;	 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 28 =>
            
            if reg_28_out /= reg_image then
                success <= false;	
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 29 =>
            
            if reg_29_out /= reg_image then
                success <= false;  
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 30 =>
            
            if reg_30_out /= reg_image then
                success <= false;	 
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
			when 31 =>
            
            if reg_31_out /= reg_image then
                success <= false;	
				report "Reg " & integer'image(reg_count) & " unexpected value." severity error;

            end if;
	   when others =>
        null; -- Do nothing for other cases
    end case; 	   
	
	
	
		reg_count := reg_count+1;
        
		
			
			
        end loop;
		
		    -- Display success or failure message
            if success then
                report "Overall Test Passed." severity note;
            else
                report "Overall Test Failed" severity error;
            end if;
	
	   -- Close the file when done
   -- file_close(input_file);
	 -- Close the file
    file_close(ResultsFile);
	     -- Close the file
  file_close(expected);
		
		
		--stop
		wait;
  end process stimulus_process;		
		
	
		
      
   
end testbench;


