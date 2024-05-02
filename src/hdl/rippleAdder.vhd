----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2024 08:52:11 PM
-- Design Name: 
-- Module Name: rippleAdder - Behavioral
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

entity rippleAdder is
    Port (  d_A, d_B  : in std_logic_vector(7 downto 0);
            d_result  : out std_logic_vector(7 downto 0);
            d_carry_in   : in std_logic;
            d_carry_out   : out std_logic);            
end rippleAdder;

architecture Behavioral of rippleAdder is

    component fullAdder is
        Port (
        a, b, cin   : in std_logic;
        s, cout     : out std_logic
         );
         end component fullAdder;
     
     signal w_carry1, w_carry2, w_carry3, w_carry4, 
            w_carry5, w_carry6, w_carry7, w_carry8    : std_logic;

begin

    fullAdder1_inst: fullAdder
    port map(
        a   => d_A(0),
        b   => d_B(0),
        cin => d_carry_in,
        
        s   => d_result(0),
        cout=> w_carry1
    );
    
    fullAdder2_inst: fullAdder
    port map(
        a   => d_A(1),
        b   => d_B(1),
        cin => w_carry1,
        
        s   => d_result(1),
        cout=> w_carry2
    );
    
    fullAdder3_inst: fullAdder
    port map(
        a   => d_A(2),
        b   => d_B(2),
        cin => w_carry2,
        
        s   => d_result(2),
        cout=> w_carry3
    );
    
    fullAdder4_inst: fullAdder
    port map(
        a   => d_A(3),
        b   => d_B(3),
        cin => w_carry3,
        
        s   => d_result(3),
        cout=> w_carry4
    );
    
    fullAdder5_inst: fullAdder
    port map(
        a   => d_A(4),
        b   => d_B(4),
        cin => w_carry4,
        
        s   => d_result(4),
        cout=> w_carry5
    );
    
    fullAdder6_inst: fullAdder
    port map(
        a   => d_A(5),
        b   => d_B(5),
        cin => w_carry5,
        
        s   => d_result(5),
        cout=> w_carry6
    );
    
    fullAdder7_inst: fullAdder
    port map(
        a   => d_A(6),
        b   => d_B(6),
        cin => w_carry6,
        
        s   => d_result(6),
        cout=> w_carry7
    );
    
    fullAdder8_inst: fullAdder
    port map(
        a   => d_A(7),
        b   => d_B(7),
        cin => w_carry7,
        
        s   => d_result(7),
        cout=> w_carry8
    );

    d_carry_out <= w_carry8;

end Behavioral;
