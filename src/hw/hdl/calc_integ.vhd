library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calc_integ is
  Port ( 
    clk              : in  std_logic; 
    trig             : in  std_logic; 
    polarity         : in std_logic; 
    adc_data         : in  signed(15 downto 0); 
    baseline         : in  signed(31 downto 0); 
    integration      : out signed(31 downto 0)
  );
end calc_integ;

architecture Behavioral of calc_integ is

  -- FSM states
  type state_type is (IDLE, INTEGRATE);
  signal present_state : state_type:= IDLE;

  constant INTEG_LEN : integer := 40;  -- 6 bits = count to 40
  signal counter      : integer;

  signal accumulator  : signed(31 downto 0) := (others => '0');
  signal result,result_d      : signed(31 downto 0) := (others => '0');
  signal accum,adc_bs : signed(31 downto 0); 
  signal prev_trig    : std_logic; 

begin
  
  accum_val : process(clk) begin 
    if(rising_edge(clk)) then 
       adc_bs <= resize(adc_data, 32) - baseline;
       
       if(polarity = '0') then  -- positive pulse
           if(adc_bs <= 0) then --filter out any negative values; only add positive values above baseline
                accum <= 32d"0"; 
           else 
                accum <= adc_bs; 
           end if;
       else                     -- negative pulse
            if(adc_bs >= 0) then --filter out any positive values; only add negative values above baseline
                accum <= 32d"0"; 
           else 
                accum <= adc_bs; 
           end if;
       end if; 
    end if; 
  end process; 
  
  
  fsm: process(clk)
  begin
    if rising_edge(clk) then
    
      prev_trig    <= trig;
      
      case present_state is

        when IDLE =>
        
          if (prev_trig = '0' and trig = '1') then
            accumulator   <= 32d"0";
            counter       <= INTEG_LEN - 1;
            present_state <= INTEGRATE;
          end if;

        when INTEGRATE =>

          if counter = 0 then
            result  <= accumulator; 
            present_state <= IDLE; 
          else 
            counter <= counter - 1;
            accumulator <= signed(accumulator) + accum; 
          end if;
        
        when others => 
            present_state <= IDLE; 

      end case;
    end if;
  end process;

  -- Output stays stable after INTEGRATION
  integration    <= result;

end Behavioral;
