	-------------------------------------------------------------------------------
	--
	-- Title       : register_file
	-- Design      : Register File
	-- Author      : Uma
	-- Company     : Stony Brook
	--
	-------------------------------------------------------------------------------
	--
	-- File        : E:\ESE 345\ESE345_Project\Register File\src\register_file.vhd
	-- Generated   : Thu Nov  9 05:59:45 2023
	-- From        : interface description file
	-- By          : Itf2Vhdl ver. 1.22
	--
	-------------------------------------------------------------------------------
	--
	-- Description : This is the register file for the ESE 345 Project. On any cycle there can 
		-- only be 3 READS and 1 WRITE
	--
	-------------------------------------------------------------------------------

	library ieee;
	use ieee.std_logic_1164.all; 
	use ieee.numeric_std.all;
	
	entity RF is
		port(
			
		reg_A, reg_B, reg_C: out std_logic_vector(127 downto 0); --registers (128 bits long)  
		opcode_out: out std_logic_vector(24 downto 0);
			wb_reg_data: in std_logic_vector(127 downto 0); --register input (what data is being stored)   
			register_write: in std_logic;
			IB_empty: in std_logic;
			hold: in std_logic;
			clk, reset_bar: in std_logic;
			opcode: in std_logic_vector(24 downto 0);
			wb_opcodedata: in std_logic_vector(24 downto 0);
			Valid_Instruction_In: in std_logic;
			Valid_Instruction_In_WB: in std_logic;
			Valid_Instruction_Out: out std_logic;
			reg_0_out: out std_logic_vector(127 downto 0); 
			reg_1_out: out std_logic_vector(127 downto 0);
			reg_2_out: out std_logic_vector(127 downto 0);
			reg_3_out: out std_logic_vector(127 downto 0);
			reg_4_out: out std_logic_vector(127 downto 0);
			reg_5_out: out std_logic_vector(127 downto 0);
			reg_6_out: out std_logic_vector(127 downto 0);
			reg_7_out: out std_logic_vector(127 downto 0);
			reg_8_out: out std_logic_vector(127 downto 0);
			reg_9_out: out std_logic_vector(127 downto 0);
			reg_10_out: out std_logic_vector(127 downto 0);
			reg_11_out: out std_logic_vector(127 downto 0);
			reg_12_out: out std_logic_vector(127 downto 0);
			reg_13_out: out std_logic_vector(127 downto 0);
			reg_14_out: out std_logic_vector(127 downto 0);
			reg_15_out: out std_logic_vector(127 downto 0);
			reg_16_out: out std_logic_vector(127 downto 0);
			reg_17_out: out std_logic_vector(127 downto 0);
			reg_18_out: out std_logic_vector(127 downto 0);
			reg_19_out: out std_logic_vector(127 downto 0);
			reg_20_out: out std_logic_vector(127 downto 0);
			reg_21_out: out std_logic_vector(127 downto 0);
			reg_22_out: out std_logic_vector(127 downto 0);
			reg_23_out: out std_logic_vector(127 downto 0);
			reg_24_out: out std_logic_vector(127 downto 0);
			reg_25_out: out std_logic_vector(127 downto 0);
			reg_26_out: out std_logic_vector(127 downto 0);
			reg_27_out: out std_logic_vector(127 downto 0);
			reg_28_out: out std_logic_vector(127 downto 0);
			reg_29_out: out std_logic_vector(127 downto 0);
			reg_30_out: out std_logic_vector(127 downto 0);
			reg_31_out: out std_logic_vector(127 downto 0);
			reg_out_all: out std_logic_vector(4095 downto 0)-- new port to access the entire 'reg'
			);
	end RF;
	
	architecture behavioral of RF is	 
	type RF is array (0 to 31) of std_logic_vector(127 downto 0); --making register file into an array where each reg = 128 bits
	signal reg : RF;  
	signal reg_sel_A, reg_sel_B, reg_sel_c: std_logic_vector(4 downto 0); --decoder part to pick which register is being read from
	begin
		process(clk, reset_bar, register_write, opcode, wb_reg_data, wb_opcodedata) 
		begin 
			
			if ( opcode(24) = '0' ) then
				reg_sel_A <= opcode(4 downto 0); --if li only case we use this directory
				
			else
			
			reg_sel_A <= opcode(9 downto 5);
			reg_sel_B <= opcode(14 downto 10);
			reg_sel_C <= opcode(19 downto 15); 
			
			end if;
			
			
			if reset_bar = '0' then  --if reset is 0, then all inputs will have 0s
				reg_A <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
				reg_B <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
				reg_C <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"; 
			    reg <= (others => (others => '0'));
			reg (0) <= (others => '0');
			else
				
			end if;
			
				
		--elsif rising_edge(clk) then 
			----------------------reading from the registers---------------------------	  
			
			--[reg_sel_A is picking from registers 0 to 31 to be used from rs1]	
			--[reg_sel_B is picking from registers 0 to 31 to be used from rs2]
			--[reg_sel_C is picking from registers 0 to 31 to be used from rs3]
		if ( IB_empty = '1' ) then	
			
				reg_A <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
				reg_B <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";		 -- when the IB is empty, we should force through NOP into the system.
				reg_C <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
			   	opcode_out <= "1100000000000000000000000" ;
				   Valid_Instruction_Out <= '0';
			
		else 
		 if (Valid_Instruction_In = '1') then	
			 
			 Valid_Instruction_Out <= '1';
			--condition for LI: 
			if opcode(24) = '0' then
				reg_A <= reg(to_integer(unsigned(reg_sel_A))); --if li, then we only need to read rs1	
					
		--check for R4: 
			elsif opcode(24 downto 23) = "10" then
				reg_A <= reg(to_integer(unsigned(reg_sel_A))); --rs1
				reg_B <= reg(to_integer(unsigned(reg_sel_B))); --rs2
				reg_C <= reg(to_integer(unsigned(reg_sel_C)));--rs3	   
				
		--check for R3:
			elsif opcode(24 downto 23) = "11" then
				case opcode(18 downto 15) is																														 --checking and outoputting based on memeory addresses.
					when "0000" =>
						--then do nothing because it is "nop" ???????????
					when "0001"| "0010" | "0100" | "0101" | "0111" | "1001" | "1010" | "1011" | "1101" | "1110" | "1111" =>
						reg_A <= reg(to_integer(unsigned(reg_sel_A))); 	 --rs1
						reg_B <= reg(to_integer(unsigned(reg_sel_B)));	 --rs2	
					when "0011" | "0110" | "1100" =>
						reg_A <= reg(to_integer(unsigned(reg_sel_A))); 	 --rs1
					when others =>
					--do nothing 
				end case;
				
				case opcode (19 downto 15) is
					when "01000" =>
						reg_A <= reg(to_integer(unsigned(reg_sel_A))); 	 --rs1
						reg_B <= reg(to_integer(unsigned(reg_sel_B)));	 --rs2
					when others =>
						--do nothing
				end case;
			end if;
			
			 
		end if;
		
		
end if; 		
		
		
		if (Valid_Instruction_In = '0') then	
			 
			 Valid_Instruction_Out <= '0';
			 
		  else
		  end if;
		  
		  
		  
		  
		  
		  
	if ( (register_write = '1')  and ( hold = '0' ) and (Valid_Instruction_In_WB = '1') ) then   
			
		 if not ( (wb_reg_data(127) = 'U' or wb_opcodedata(24) = 'U') and  (wb_opcodedata /= "1100000000000000000000000")  ) then
			
			--if enable is on, we can write to the register	 
				
				reg(to_integer(unsigned(wb_opcodedata(4 downto 0)))) <= wb_reg_data; --the register data will go to the register 
			-------------on rising edge,registers A, B, and C are being read----------------------------- 
			if reg_sel_A = wb_opcodedata(4 downto 0) then
				reg_A <= wb_reg_data;
			end if;
			if reg_sel_B = wb_opcodedata(4 downto 0) then																												-- ensuring writing the registers occurs first, then outputting either recenrtly caluktaed or last valid result.
				reg_B <= wb_reg_data;
			end if;
			if reg_sel_c = wb_opcodedata(4 downto 0) then
				reg_C <= wb_reg_data;
			end if;
			
			
			else 
				
			end if;	
			
			
	   
			else 
		   
				--Valid_Instruction_Out <= '0';	
		
			end if;
			   
		  
		
		opcode_out <= opcode;
		
		            -- update the output port with the entire 'reg'
        reg_out_all <= reg(0) & reg(1) & reg(2) & reg(3) & reg(4) & reg(5) & reg(6) & reg(7) &
                       reg(8) & reg(9) & reg(10) & reg(11) & reg(12) & reg(13) & reg(14) & reg(15) &
                       reg(16) & reg(17) & reg(18) & reg(19) & reg(20) & reg(21) & reg(22) & reg(23) &
                       reg(24) & reg(25) & reg(26) & reg(27) & reg(28) & reg(29) & reg(30) & reg(31);																	  --outputting the opcode again down the line, 	  and debug port fot all the memroy
	  
			reg_0_out <= reg(0); 
			reg_1_out <= reg(1);
			reg_2_out <= reg(2);
			reg_3_out <= reg(3);
			reg_4_out <= reg(4);
			reg_5_out <= reg(5);
			reg_6_out <= reg(6);
			reg_7_out <= reg(7);
			reg_8_out <= reg(8);
			reg_9_out <= reg(9);
			reg_10_out <= reg(10);
			reg_11_out <= reg(11);
			reg_12_out <= reg(12);
			reg_13_out <= reg(13);
			reg_14_out <= reg(14);
			reg_15_out <= reg(15);
			reg_16_out <= reg(16);
			reg_17_out <= reg(17);
			reg_18_out <= reg(18);
			reg_19_out <= reg(19);
			reg_20_out <= reg(20);
			reg_21_out <= reg(21);
			reg_22_out <= reg(22);
			reg_23_out <= reg(23);
			reg_24_out <= reg(24);
			reg_25_out <= reg(25);
			reg_26_out <= reg(26);
			reg_27_out <= reg(27);
			reg_28_out <= reg(28);
			reg_29_out <= reg(29);
			reg_30_out <= reg(30);
			reg_31_out <= reg(31);
								
		end process; 
			--process(
	end behavioral;
			
	
			
			
		
		
		
		
	