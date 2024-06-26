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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
-- TODO
    port(
        clk     : in std_logic;
        btnU    : in std_logic;
        btnC    : in std_logic;
        sw      : in std_logic_vector(7 downto 0);
        
        led     : out std_logic_vector(15 downto 0);
        an      : out std_logic_vector(3 downto 0);
        seg     : out std_logic_vector(6 downto 0)
    );
end top_basys3;


architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
    component controller_fsm is
        Port ( i_reset : in STD_LOGIC;
               i_adv : in STD_LOGIC;
               o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
        end component controller_fsm;
        
    component alu is
        port(
            i_A     : in std_logic_vector(7 downto 0);
            i_B     : in std_logic_vector(7 downto 0);
            i_op    : in std_logic_vector(2 downto 0);
            
            o_flags : out std_logic_vector(2 downto 0);
            o_result: out std_logic_vector(7 downto 0)       
        );
        end component alu;
        
    component twoscomp_decimal is
        port (
            i_binary: in std_logic_vector(7 downto 0);
            o_negative: out std_logic_vector(3 downto 0);
            o_hundreds: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
        end component twoscomp_decimal;
        
    component clock_divider is 
        generic ( constant k_DIV : natural := 25000	);
                                                   
        port (     i_clk    : in std_logic;
                i_reset  : in std_logic;           
                o_clk    : out std_logic           
        );
        end component clock_divider;
        
    component tdm4 is
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_clk        : in  STD_LOGIC;
               i_reset        : in  STD_LOGIC; -- asynchronous
               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
        );
        end component TDM4;
        
    component sevenSegDecoder is
        Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
               o_S : out STD_LOGIC_VECTOR (6 downto 0)
               );
        end component sevenSegDecoder;
        
    
    signal w_cycle : std_logic_vector(3 downto 0);
    signal w_A : std_logic_vector(7 downto 0);
    signal w_B : std_logic_vector(7 downto 0);
    signal w_result : std_logic_vector(7 downto 0);
    signal w_MUX : std_logic_vector(7 downto 0);
    signal w_flags : std_logic_vector(2 downto 0);
    signal w_sign : std_logic_vector(3 downto 0);
    signal w_hund : std_logic_vector(3 downto 0);
    signal w_tens : std_logic_vector(3 downto 0);
    signal w_ones : std_logic_vector(3 downto 0);
    signal w_data : std_logic_vector(3 downto 0);
    signal w_sel : std_logic_vector(3 downto 0);
    signal w_clock : std_logic;
    
  
begin
	-- PORT MAPS ----------------------------------------
    controller_fsm1_inst: controller_fsm
    port map(
        i_reset => btnU,
        i_adv => btnC,
        o_cycle => w_cycle
        );
        
    alu1_inst: alu
    port map(
        i_A => w_A,
        i_B => w_B,
        i_op => sw(2 downto 0),
        o_flags => w_flags,
        o_result => w_result
        );
        
    twoscomp_decimal1_inst: twoscomp_decimal
    port map(
        i_binary => w_MUX,
        o_negative => w_sign,
        o_hundreds => w_hund,
        o_tens => w_tens,
        o_ones => w_ones
        );
    
    clock_divider1_inst: clock_divider
    port map(
        i_clk => clk,
        i_reset => btnU,
        o_clk => w_clock
        );
        
    tdm41_inst: tdm4
    port map(
        i_clk => w_clock,
        i_reset => btnU,
        i_D3 => w_sign,
        i_D2 => w_hund,
        i_D1 => w_tens,
        i_D0 => w_ones,
        o_sel => w_sel,
        o_data => w_data
        );
    
    sevenSegdecoder1_inst: sevenSegDecoder
    port map(
        i_D => w_data,
        o_S => seg
        );
       
	
	-- CONCURRENT STATEMENTS ---------------------------
	
	--D flip flops
	register_proc_A : process (w_cycle)
        begin
        if rising_edge(w_cycle(2)) then
                 w_A <= sw(7 downto 0);
            end if;
            end process register_proc_A;
   
   register_proc_B : process (w_cycle)
        begin
        if rising_edge(w_cycle(1)) then
                 w_B <= sw(7 downto 0);
            end if;
            end process register_proc_B;
   
   --MUX
   w_MUX <=     w_A when (w_cycle = "0100") else
                w_B when (w_cycle = "0010") else
                w_result when (w_cycle = "0001") else
                "00000000"; ------do not know what to set the default to
   
    --Anodes
	an <= "1111" when (w_cycle = "1000")
	       else w_sel;
	
	--Leds
	led(3 downto 0) <= w_cycle;
	led(15) <= '1' when w_flags(0)= '1' and w_cycle = "0001" else '0';
	led(14) <= '1' when w_flags(1)= '1' and w_cycle = "0001" else '0';
	led(13) <= '1' when w_flags(2)= '1' and w_cycle = "0001" else '0';
	
	
	
end top_basys3_arch;
