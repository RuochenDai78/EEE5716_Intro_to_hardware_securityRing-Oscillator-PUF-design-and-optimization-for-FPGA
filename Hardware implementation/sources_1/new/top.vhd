library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
  port (
  ---ports for PUF_top
    clk           : in  std_logic;
    rstn          : in  std_logic;
    -- Avalon Slave Signals
    PUF_address   : in  std_logic_vector(11 downto 0);
    PUF_write     : in  std_logic;
    PUF_writedata : in  std_logic_vector(63 downto 0);
    PUF_read      : in  std_logic;
    
    
  ---ports for BRAM
    top_address   : in std_logic_vector(10 downto 0);
    ena           : in std_logic;
    ena_in        : in std_logic;
    wea           : in std_logic_vector(0 DOWNTO 0);
    wea_in        : in std_logic_vector(0 DOWNTO 0);
    addr_out         : in std_logic_vector(8 DOWNTO 0);
    douta         : out std_logic_vector(63 DOWNTO 0)
    );
 end entity top;

architecture Behavioral of top is

  component RAM_in is
    generic (
      INPUT_WIDTH    : integer;
      OUTPUT_WIDTH   : integer;
      RING_OSC_DEPTH : integer);
    port (
    clka : in std_logic;
    ena : in std_logic;
    wea : in std_logic_vector(0 DOWNTO 0);
    addra : in std_logic_vector(10 DOWNTO 0);
    dina : in std_logic_vector(63 DOWNTO 0);
    douta : OUT std_logic_vector(63 DOWNTO 0)
  );
  end component RAM_in; 

  component puf_top is
    generic (
      INPUT_WIDTH    : integer;
      OUTPUT_WIDTH   : integer;
      RING_OSC_DEPTH : integer);
    port (
      clk           : in  std_logic;
      rstn          : in  std_logic;
    -- Avalon Slave Signals
      PUF_address   : in  std_logic_vector(11 downto 0);
      PUF_write     : in  std_logic;
      PUF_writedata : in  std_logic_vector(63 downto 0);
      PUF_read      : in  std_logic;
      PUF_readdata  : out std_logic_vector(63 downto 0));
  end component puf_top;
  
  component RAM64 is
    generic (
      INPUT_WIDTH    : integer;
      OUTPUT_WIDTH   : integer;
      RING_OSC_DEPTH : integer);
    port (
    clka : IN std_logic;
    ena : IN std_logic;
    wea : IN std_logic_vector(0 DOWNTO 0);
    addra : IN std_logic_vector(8 DOWNTO 0);
    dina : IN std_logic_vector(63 DOWNTO 0);
    douta : OUT std_logic_vector(63 DOWNTO 0)
  );
  end component RAM64;  

  signal temp : std_logic_vector(63 downto 0);
  signal temp_data : std_logic_vector(63 downto 0);
  
begin
  U0_RAM : RAM_in
    generic map (
      INPUT_WIDTH    => 64,
      OUTPUT_WIDTH   => 64,
      RING_OSC_DEPTH => 20)
    port map (
      clka             => clk,
      ena              => ena_in,
      wea              => wea_in,
      addra            => top_address,
      dina             => PUF_writedata,
      douta            => temp_data
      );
      
  U1_PUF_TOP : puf_top
    generic map (
      INPUT_WIDTH    => 64,
      OUTPUT_WIDTH   => 64,
      RING_OSC_DEPTH => 20)
    port map (
      clk             => clk,
      rstn            => rstn,
      PUF_address     => PUF_address,
      PUF_write       => PUF_write,
      PUF_writedata   => temp_data,
      PUF_read        => PUF_read,
      PUF_readdata    => temp);
      
  U2_RAM : RAM64
    generic map (
      INPUT_WIDTH    => 64,
      OUTPUT_WIDTH   => 64,
      RING_OSC_DEPTH => 20)
    port map (
      clka             => clk,
      ena              => ena,
      wea              => wea,
      addra            => addr_out,
      dina             => temp,
      douta            => douta
      );
      

end Behavioral;
