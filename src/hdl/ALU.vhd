--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|
--|
--|
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  


entity ALU is
-- TODO
    port(
        i_A     : in std_logic_vector(7 downto 0);
        i_B     : in std_logic_vector(7 downto 0);
        i_op    : in std_logic_vector(2 downto 0);
        
        o_flags : out std_logic_vector(2 downto 0);
        o_result: out std_logic_vector(7 downto 0)       
    );
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
	
	component rippleAdder is 
	   Port (  d_A, d_B  : in std_logic_vector(7 downto 0);
                d_result  : out std_logic_vector(7 downto 0);
                d_carry_in   : in std_logic;
                d_carry_out   : out std_logic);
        end component rippleAdder;
    
    component shifter is
        Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
               i_B : in STD_LOGIC_VECTOR (7 downto 0);
               i_inst : in STD_LOGIC;
               o_shift : out STD_LOGIC_VECTOR (7 downto 0));
       end component shifter;
	       
	
	
    signal w_result :   std_logic_vector(7 downto 0);
    
    signal w_A      :   std_logic_vector(7 downto 0);
    signal w_B      :   std_logic_vector(7 downto 0);
    signal w_B_add      :   std_logic_vector(7 downto 0);
    signal w_B_sub      :   std_logic_vector(7 downto 0);
    signal w_ripple_out : std_logic_vector(7 downto 0);
    signal w_carry  :   std_logic;
    signal w_shift_out  : std_logic_vector(7 downto 0);
  
begin
	-- PORT MAPS ----------------------------------------
    
    rippleAdder1_inst : rippleAdder
    port map(
        d_A => w_A,
        d_B => w_B,
        d_carry_in => i_op(0),
        d_result => w_ripple_out,
        d_carry_out => w_carry
    );
    
    shifter1_inst   : shifter
    port map(
        i_A => i_A,
        i_B => i_B,
        i_inst => i_op(0),
        o_shift => w_shift_out
        );
    
    
	o_result <= w_result;
	w_A <= i_A;
	w_B_add <= i_B;
	w_B_sub <= not i_B;
	
	w_B <= w_B_add when i_op(0) = '0' else
	       w_B_sub;
	
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	w_result <= w_ripple_out when i_op(2 downto 1) = "00" else
	            i_A or i_B when i_op(2 downto 1) = "01" else
	            i_A and i_B when i_op(2 downto 1) = "10" else
	            w_shift_out when i_op(2 downto 1) = "11" else
	            "00000000";
	
	o_flags(0) <= '1' when w_result(7) = '1' else '0';
	o_flags(1) <= '1' when w_result = "00000000" else '0';
	o_flags(2) <= w_carry and (not i_op(2)) and (not i_op(1));
	
end behavioral;
