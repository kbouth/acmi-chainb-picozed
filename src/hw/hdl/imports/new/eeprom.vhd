----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/22/2025 04:59:01 PM
-- Design Name: 
-- Module Name: eeprom - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity eeprom is
  Port (
  
  -------- DESIGN PORTS ----------
    sys_clk     : in std_logic;
    reset       : in std_logic; 
    opcode_in   : in std_logic_vector(7 downto 0); 
    address     : in std_logic_vector(15 downto 0);
    data_in     : in std_logic_vector(31 downto 0);
    n_bytes     : in std_logic_vector(2 downto 0);  
    trig        : in std_logic; 
    
    rddata      : out std_logic_vector(31 downto 0); 
    
    ------ EEPROM SPI PORTS ----------
    sdo         : in std_logic; 
    csn         : out std_logic; 
    holdn       : out std_logic; 
    sclk        : out std_logic; 
    sdi         : out std_logic;
    wpn         : out std_logic; 
    
    spi_done  : out std_logic
     );
end eeprom;

architecture Behavioral of eeprom is

    

    signal clk_div_count : integer := 0;
    signal sclk_int   : std_logic := '0';

    type spi_state is (IDLE, OPCODE, WREN, WRDI, RDSR, WRSR, READ, WRITE, DONE);
    
    signal present_state      : spi_state := IDLE;
    signal next_state      : spi_state := IDLE;
    signal delay_cnt      : integer := 2; 
    

    signal bit_count      : integer := 0;
    signal shift_register : std_logic_vector(55 downto 0) := (others => '0');
    signal cs_int       : std_logic := '1';
    signal sdi_int       : std_logic := '0';
    signal sdo_buffer_temp   : std_logic_vector(31 downto 0) := (others => '0');
    signal sdo_buffer   : std_logic_vector(31 downto 0) := (others => '0');
    
    signal clk_enable     : std_logic := '0';
    signal clk_count      : integer := 0;
    signal clk_pulses     : integer := 0; 
    signal rd_data_2s_temp: std_logic_vector(15 downto 0); 
    signal sclk_int_buf   : std_logic_vector(10 downto 0):= (others => '0'); 
    signal adc_pipeline_cnt : integer := 7; 
    signal clk_count_temp  : integer := 0; 
    signal latency_flag    : std_logic:= '0'; 
    signal start          : std_logic:= '0'; 
    
begin
    
        -- Generate SPI clock
    process(sys_clk) begin
        if rising_edge(sys_clk) then
            if reset = '1' then
                clk_div_count <= 0;
            else
                if clk_count = 9 then
                    clk_count_temp <= 0; 
                    clk_enable <= not(clk_enable);
                else
                    clk_count_temp <= clk_count_temp + 1;
                end if;
                
                clk_count <= clk_count_temp;
           end if; 
        end if;
    end process;
    
    spi_clk: process(sys_clk) begin -- 10 MHz SCLK
        if(rising_edge(sys_clk)) then
            if reset = '1' then 
                sclk <= '0'; 
            else 
                if cs_int = '1' or present_state = IDLE or present_state = OPCODE or present_state = DONE then 
                        sclk <= '0';
                        sclk_int <= clk_enable;
                else
                    sclk_int_buf(10 downto 1) <= sclk_int_buf(9 downto 0); 
                    sclk_int_buf(0) <= clk_enable;   
                    sclk <= sclk_int_buf(10); 
                    sclk_int <= clk_enable; 
                end if;     
            end if; 
        end if; 
    end process;
     
    holdn <= '1';
    wpn <= '1'; 
    
    
    fsm: process(sclk_int) begin 
        if rising_edge(sclk_int) then 
            if(reset = '1') then 
                spi_done <= '0'; 
                sdi <= '0'; 
                clk_pulses <= 8;
                bit_count <= 0;  
                shift_register <= (others => '0');
                rddata <= (others => '0');  
                present_state <= IDLE; 
            else
            
                case present_state is
                    when IDLE =>
                        spi_done <= '0'; 
                        sdi <= '0'; 
                        clk_pulses <= 8;
                        bit_count <= 0;   
                        if trig = '1' then 
                            present_state <= OPCODE; 
                        else 
                            present_state <= IDLE; 
                        end if; 
                        
                    when OPCODE =>
                        
                     
                            case opcode_in is
                                when "00000110" => 
                                   
                                    clk_pulses <= 8;  
                                    shift_register(55 downto 48) <= opcode_in; 
                                    present_state <= WREN;
                                   
                                when "00000100" => 
                                
                                    clk_pulses <= 8;  
                                    shift_register(55 downto 48) <= opcode_in; 
                                    present_state <= WRDI;
                                
                                when "00000101" => 
                                    
                                    clk_pulses <= 16; 
                                    shift_register(55 downto 48) <= opcode_in; 
                                    present_state <= RDSR; 
                                    
                                when "00000001" => 
                                    
                                    clk_pulses <= 16;
                                    shift_register(55 downto 48) <= opcode_in; 
                                    shift_register(47 downto 40) <= data_in(7 downto 0);
                                    shift_register(39 downto 0) <= (others => '0');  
                                    present_state <= WRSR;
                                     
                                when "00000011" =>
                                 
                                    clk_pulses <= ((to_integer(unsigned(n_bytes)-1)) * 8) + 32; 
                                    shift_register(55 downto 48) <= opcode_in; 
                                    shift_register(47 downto 32) <= address;
                                    present_state <= READ; 
                                    
                                when "00000010" => 
                                    clk_pulses <= ((to_integer(unsigned(n_bytes)-1)) * 8) + 32;
                                    shift_register(55 downto 48) <= opcode_in; 
                                    shift_register(47 downto 32) <= address; 
                                    shift_register(31 downto (32 - to_integer(unsigned(n_bytes))*8)) <= data_in((to_integer(unsigned(n_bytes))*8 - 1) downto 0);                        
                                    present_state <= WRITE;
                                when others => present_state <= IDLE;    
                            end case; 
                        
                    when WREN =>
                       
                        
                        if clk_pulses - 1 = 0 then
                            spi_done <= '1'; 
                            present_state <= DONE; 
                        else
                            sdi <= shift_register(54 - bit_count); 
                            bit_count <= bit_count + 1;
                            clk_pulses <= clk_pulses - 1;  
                            present_state <= WREN; 
                        end if; 
                       
                    when WRDI =>
                        
                        
                        if clk_pulses - 1 = 0 then 
                            spi_done <= '1';
                            present_state <= DONE; 
                        else
                            sdi <= shift_register(54 - bit_count); 
                            bit_count <= bit_count + 1;
                            clk_pulses <= clk_pulses - 1;  
                            present_state <= WRDI; 
                        end if; 
                        
                    when RDSR =>
                    
                        
                        if clk_pulses -1  = 0 then 
                            spi_done <= '1';
                            present_state <= DONE; 
                        else
                            sdi <= shift_register(54 - bit_count); 
                            bit_count <= bit_count + 1;
                            clk_pulses <= clk_pulses - 1;  
                            present_state <= RDSR; 
                        end if; 
                        
                   when WRSR =>
                    
                         
                        if clk_pulses-1 = 0 then
                            spi_done <= '1'; 
                            present_state <= DONE; 
                        else
                            sdi <= shift_register(54 - bit_count); 
                            bit_count <= bit_count + 1;
                            clk_pulses <= clk_pulses - 1;  
                            present_state <= WRSR; 
                        end if; 
                   
                   when READ =>
                    
                        if clk_pulses -1= 0 then
                            spi_done <= '1';             
                            present_state <= DONE; 
                        else
                            sdi <= shift_register(54 - bit_count); 
                            bit_count <= bit_count + 1;
                            clk_pulses <= clk_pulses - 1;  
                            present_state <= READ; 
                        end if; 
                        
                   when WRITE =>
                                            
                        if clk_pulses-1 = 0 then
                            spi_done <= '1'; 
                            present_state <= DONE; 
                        else
                            sdi <= shift_register(54 - bit_count); 
                            bit_count <= bit_count + 1;
                            clk_pulses <= clk_pulses - 1;  
                            present_state <= WRITE; 
                        end if; 
                    
                    when DONE =>  
                        spi_done <= '0';
                        rddata <= sdo_buffer;
                        present_state <= IDLE; 
                        
                    when others => present_state <= IDLE; 
                end case; 
       
            end if;
        end if;  
    end process; 
    
   csb: process(reset,present_state) begin 
        if(reset = '1') then 
            cs_int <= '1'; 
        else
                case present_state is
                 when IDLE => cs_int <= '1';  
                 when others => cs_int <= '0'; 
                end case;
        end if; 
    end process; 
    
    sdo_read: process(reset, sclk_int) begin 
        if reset = '1' then 
          sdo_buffer <= (others => '0');   
        else
          if  falling_edge(sclk_int) then 
            case present_state is 
                when RDSR =>
                    if clk_pulses <= 8 then 
                        sdo_buffer(31 - (bit_count - 8)) <= sdo;
                    end if;
                when READ =>
                    if clk_pulses <= to_integer(unsigned(n_bytes))*8  then 
                          sdo_buffer(31 - (bit_count - 24)) <= sdo;
                    end if;
                when others => sdo_buffer <= sdo_buffer; 
            end case; 
          end if; 
        end if; 
    end process;
    
    csn <= cs_int;     
end Behavioral;
