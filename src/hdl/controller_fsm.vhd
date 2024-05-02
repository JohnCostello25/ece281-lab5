----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2024 03:31:28 PM
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture Behavioral of controller_fsm is

    type state is (s_clear, s_A, s_B, s_result);

    signal f_Q_next: state;
    signal f_Q : state := s_clear;

begin

    --Next State
    f_Q_next <= s_clear when ((i_adv = '1') and (f_Q = s_result)) else
                s_A when ((i_adv = '1') and (f_Q = s_clear)) else
                s_B when ((i_adv = '1') and (f_Q = s_A)) else
                s_result when ((i_adv = '1') and (f_Q = s_B)) else
                
                f_Q; -- default
    
    --Output
    with f_Q select
        o_cycle <=  "1000" when s_clear,
                    "0100" when s_A,
                    "0010" when s_B,
                    "0001" when s_result,
                    
                    "1000" when others;
                    
                    
                    
    register_proc : process (i_adv)
    begin 
    
        if i_reset = '1' then
            f_Q <= s_clear;
        elsif(rising_edge(i_adv)) then
            f_Q <= f_Q_next;
        end if;
    
    end process register_proc;
      

end Behavioral;
