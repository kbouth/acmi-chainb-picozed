library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calc_integ is
  Port ( 
    clk         : in  std_logic; 
    trig        : in  std_logic; 
    adc_data    : in  signed(15 downto 0); 
    baseline    : in  signed(31 downto 0); 
    integration : out signed(31 downto 0)
  );
end calc_integ;

architecture Behavioral of calc_integ is

  -- FSM states
  type state_type is (IDLE, INTEGRATE, DONE);
  signal present_state : state_type := IDLE;

  constant INTEG_LEN : unsigned(5 downto 0) := to_unsigned(40, 6);  -- 6 bits = count to 40
  signal counter      : unsigned(5 downto 0) := (others => '0');

  signal accumulator  : signed(31 downto 0) := (others => '0');
  signal result       : signed(31 downto 0) := (others => '0');

begin

  process(clk)
  begin
    if rising_edge(clk) then
      case present_state is

        when IDLE =>
          if trig = '1' then
            accumulator   <= (others => '0');
            counter       <= (others => '0');
            present_state <= INTEGRATE;
          end if;

        when INTEGRATE =>
          -- Subtract baseline, accumulate
          if(abs((resize(adc_data, 32) - baseline)) >= 1) then 
            accumulator <= accumulator + resize(adc_data, 32) - baseline;
          else 
            accumulator <= accumulator; 
          end if; 
          
          counter <= counter + 1;

          if counter = INTEG_LEN - 1 then
            present_state <= DONE;
          end if;

        when DONE =>
          result         <= accumulator;
          present_state  <= IDLE;
      end case;
    end if;
  end process;

  -- Output stays stable after DONE
  integration <= result;

end Behavioral;
