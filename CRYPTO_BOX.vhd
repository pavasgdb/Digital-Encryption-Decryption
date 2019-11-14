LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;

entity CRYPTO_BOX is


port( C : in std_logic;
		rx_in : in std_logic;
		LED : out std_logic_vector(15 downto 0);
		mode : in std_logic_vector(1 downto 0);
        cathode : out std_logic_vector(0 to 6);
        A : out std_logic_vector(3 downto 0);
		tx_out : out std_logic;
		key_user : in std_logic_vector(7 downto 0);
		PB0 : in std_logic;
		PB1 : in std_logic
		); 


end CRYPTO_BOX;

architecture Behavioral of CRYPTO_BOX is

signal rx_full:std_logic;
signal tx_empty:std_logic;
signal wen:std_logic;
signal clk:std_logic :='1';	
signal ld_tx:std_logic;
signal rd_addr: integer;
signal wr_addr: integer;
signal tx:std_logic_vector(7 downto 0);
signal count_16_1: integer range 0 to 16;
signal count_16_2: integer range 0 to 16;
signal reset:std_logic;

signal rx_reg : std_logic_vector(7 downto 0);

signal tx_start : std_logic;
signal m : integer range 0 to 651;
  
TYPE State_type IS (idle,start,stop); 
SIGNAL state : State_Type;  
type timing_state_type is(t0,t1,t2,t3,t4,t5,t6,t7);
signal state_timing : timing_state_type;

signal encrypted : std_logic_vector(7 downto 0);
signal private_encrypted : std_logic_vector(7 downto 0);
 --- count is the variable counting 8 cosecutive 0
 --- count16 is the variable counting 16 cycles of rx_clk
 --- tmp is the variable counting number of input bits taken
 
 begin 
 memory1 : entity work.memory(Behavioral)
         port map(clk,wen,wr_addr,private_encrypted,clk,ld_tx,rd_addr,tx);
private1 : entity work.private_encryption(Behavioral)
         port map(rx_reg,private_encrypted);
 transmitter1 : entity work.transmitter(Behavioral)
        port map(clk,tx_empty,ld_tx,reset,tx_out,encrypted);
 public1 : entity work.public_encryption(Behavioral)
         port map(tx,encrypted,rd_addr,key_user,mode);
receiver1 : entity work.receiver(Behavioral)
        port map(clk,rx_in,rx_reg,reset,rx_full);  
display : entity work.display_key(Behavioral)
        port map(C,reset,A,key_user,cathode);
----- Generating 9600*16 clk -------

 process(C)
    begin
    if(C'event and C='1') then
           m <= m + 1;
              if(m=651) then
              m <=0;
              end if;
				  if(m<326) then
				  clk <= '1';
				  else
				  clk <='0';
				  end if;
    end if;
    end process;

--- Debouncing -----

process(clk)
begin
if (clk'event and clk='1') then
count_16_2<=count_16_2+1;
    if(count_16_2=15) then 
    count_16_2<=0;
		tx_start <= PB1;
		reset<=PB0;
		end if;
		end if;
end process;

-----  Timing Circuit -----
process(clk,reset)
begin
if (reset='1') then
	state_timing <= t0;
	wr_addr<=0;
	else
	if (clk'event and clk='1') then
	count_16_1<=count_16_1+1;
    if(count_16_1=15) then 
    count_16_1<=0;
	
		case state_timing is
			when t0 =>
			state_timing <= t1;
			wen<='0';
			when t1 => 
			
			if( tx_start='1') then
			state_timing <= t2;
			rd_addr<=0;
			else
				if(rx_full='0') then
				state_timing <= t3;
				end if;
			end if;
			
			when t2 =>
			if(rd_addr>=wr_addr) then
                state_timing <= t7;
            else
            state_timing <=t5;
			ld_tx <= '1';
            rd_addr <= rd_addr+1;
			end if;
			
			when t3 =>
			if(rx_full='1') then
			state_timing <= t4;
			wr_addr <= wr_addr+1;
            wen <='1';
			
			end if;
				
			when t4 =>
			wen <='0';
			state_timing <= t1;
			
			when t5 =>
			
			state_timing <= t6;
			ld_tx <= '0';
			
			when t6 =>
			
			if(tx_empty='1') then
				if(rd_addr>=wr_addr) then
				state_timing <= t7;
				else
				state_timing <= t5;
				ld_tx <= '1';
                rd_addr <= rd_addr+1;
				end if;
			
			end if;
			
			when t7 =>
			if(tx_start='0') then
			state_timing <= t1;
			wen<='0';
			end if;
			
		end case;
		end if;
		end if;
	end if;
		
end process;
	

LED <= rx_reg&tx(7 downto 0);


end Behavioral;
