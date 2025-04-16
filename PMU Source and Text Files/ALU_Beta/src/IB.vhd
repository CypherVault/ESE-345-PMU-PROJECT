library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IB is
    port (
        INSTRUCTION_IN: in std_logic_vector(24 downto 0);
        instruction_number: in std_logic_vector(6 downto 0); 
		Current_PC_Count: out std_logic_vector(5 downto 0);
		ProgramMemory_OUT: out std_logic_vector(1650 downto 0);
        hold, reset_bar, clk: in std_logic;
		finish,IB_empty: out std_logic;
		Valid_Instruction_Out: out std_logic;
        next_opcode: out std_logic_vector(24 downto 0) 
		
    );
end IB;			  
	architecture behavioral of IB is
    signal ProgramMemory: std_logic_vector(1650 downto 0);
    signal PC, PC_max: integer := 0;
   --signal instruction : std_logic_vector(24 downto 0);
	

begin
    process(clk, reset_bar, INSTRUCTION_IN, instruction_number, hold)
	
    -- Variables to specify the range (x downto y) for insertion by LOAD INDEX VALUE
    variable PM_START_REPLACE_BT, PM_endd_REPLACE_BT: natural := 0;
	  variable instruction : std_logic_vector(24 downto 0);
    begin
        if reset_bar = '0' then
            -- Clear and reset mode
            -- Reset: clear program memory, PC, and PC_max
            ProgramMemory <= (others => '0');
            PC <= 0;
            PC_max <= 0;
            next_opcode <= (others => '0');
            finish <= '0';
            IB_empty <= '0';
        elsif (clk = '1') then
            if hold = '1' then
                -- LOAD PROGRAM MODE

                -- Step 1: Calculate the range for program memory update
                PM_START_REPLACE_BT := 25 * to_integer(unsigned(instruction_number(6 downto 0)));
                PM_endd_REPLACE_BT := 24 + (25 * to_integer(unsigned(instruction_number(6 downto 0))));
				
				 for i in 0 to 24 loop
      				instruction(i) := INSTRUCTION_IN(24 - i);
    			 end loop;	 
				 
				
                -- Step 2: Modify the specified range memory using range
                ProgramMemory(PM_endd_REPLACE_BT downto PM_START_REPLACE_BT) <= instruction(24 downto 0);

                -- Step 3: Handle sensing the MAX PC
                if PC_max = 0 then 
                    PC_max <= to_integer(unsigned(instruction_number(6 downto 0)));
                else
                    if to_integer(unsigned(instruction_number(6 downto 0))) > PC_max then	   
                        PC_max <= (to_integer(unsigned(instruction_number(6 downto 0))) + 1);
                    else 
                        -- null
                    end if;
				end if;
			
				
            elsif hold = '0' then
                -- Output program mode
                -- Additional code for program output can be added here
		
				   
					
                if PC /= PC_max + 1 then
                    next_opcode <= ProgramMemory(24 + (25 * PC) downto (25 * PC));
                    PC <= PC + 1;
					Valid_Instruction_Out <= '1';
                    if PC = PC_max then
                        finish <= '1';
                    else
                        -- null
                    end if;
                else
                    -- (PC = PC_max+1) we reached the end of buffer
                    IB_empty <= '1'; 
					Valid_Instruction_Out <= '0';
                end if;
            else
                -- No operation mode specified for this condition
                -- null
            end if;
        else
            -- If reset is high, don't do anything special
            -- null
        end if;	
		
		ProgramMemory_OUT <= ProgramMemory;	
		Current_PC_Count <= std_logic_vector(to_unsigned(PC, 6));
		
		
    end process;
end behavioral;
