----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2024 02:34:42 PM
-- Design Name: 
-- Module Name: alu1_tb - Behavioral
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

entity alu1_tb is
--  Port ( );
end alu1_tb;

architecture Behavioral of alu1_tb is

    component alu is
        port(
            i_A     : in std_logic_vector(7 downto 0);
            i_B     : in std_logic_vector(7 downto 0);
            i_op    : in std_logic_vector(2 downto 0);
            
            o_flags : out std_logic_vector(2 downto 0);
            o_result: out std_logic_vector(7 downto 0)       
        );
    end component;
    
    
    signal w_A, w_B, w_result : std_logic_vector(7 downto 0) := "00000000";
    signal w_op, w_flags : std_logic_vector(2 downto 0);


begin

    alu_inst : alu 
        port map(   i_A => w_A,
                    i_b => w_B,
                    i_op => w_op, 
                    o_result => w_result,
                    o_flags => w_flags
                    
                );

    test_process : process
    begin 
    
    
        w_A <= "10000000"; w_B <= "10000000"; w_op <= "000"; wait for 10 ns;

        w_A <= "00000100"; w_B <= "00000010"; w_op <= "000"; wait for 10 ns;
                        
        w_A <= "10001100"; w_B <= "00110000"; w_op <= "000"; wait for 10 ns;
                            
        w_A <= "00000010"; w_B <= "00001000"; w_op <= "001"; wait for 10 ns;
                        
        w_A <= "10001100"; w_B <= "10000010"; w_op <= "001"; wait for 10 ns;
                
        w_A <= "00000000"; w_B <= "11000000"; w_op <= "001"; wait for 10 ns;
                    
        w_A <= "00000001"; w_B <= "00000011"; w_op <= "010"; wait for 10 ns;
                
        w_A <= "00001000"; w_B <= "00000010"; w_op <= "010"; wait for 10 ns;
        
        w_A <= "00000000"; w_B <= "00000000"; w_op <= "010"; wait for 10 ns;
        
        w_A <= "00001100"; w_B <= "00001000"; w_op <= "100"; wait for 10 ns;
                        
        w_A <= "00001000"; w_B <= "00000001"; w_op <= "100"; wait for 10 ns;
        
        w_A <= "00110000"; w_B <= "00110000"; w_op <= "100"; wait for 10 ns;
        
        w_A <= "00000100"; w_B <= "00000010"; w_op <= "110"; wait for 10 ns;
        
        w_A <= "00000100"; w_B <= "00000100"; w_op <= "110"; wait for 10 ns;
                        
        w_A <= "00000100"; w_B <= "00110000"; w_op <= "110"; wait for 10 ns;
        
        w_A <= "00001000"; w_B <= "00000001"; w_op <= "111"; wait for 10 ns;
        
        w_A <= "00001000"; w_B <= "00000010"; w_op <= "111"; wait for 10 ns;
                        
        w_A <= "00001000"; w_B <= "00000100"; w_op <= "111"; wait for 10 ns;
            
            
            
            
        wait;
    
    end process;


end Behavioral;
