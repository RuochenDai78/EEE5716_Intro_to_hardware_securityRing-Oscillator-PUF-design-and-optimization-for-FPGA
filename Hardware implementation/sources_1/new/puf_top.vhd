library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity puf_top is
  port (
    clk           : in  std_logic;
    rstn          : in  std_logic;
    PUF_address   : in  std_logic_vector(11 downto 0);
    PUF_write     : in  std_logic;
    PUF_writedata : in  std_logic_vector(63 downto 0);
    PUF_read      : in  std_logic;
    PUF_readdata  : out std_logic_vector(63 downto 0));
end entity puf_top;

architecture rtl of puf_top is
  component puf is
    generic (
      INPUT_WIDTH    : integer;
      OUTPUT_WIDTH   : integer;
      RING_OSC_DEPTH : integer);
    port (
      clk             : in  std_logic;
      rstn            : in  std_logic;
      ena             : in  std_logic;
      done            : out std_logic;
      challenge_input : in  std_logic_vector(63 downto 0);
      response_output : out std_logic_vector(63 downto 0));
  end component puf;
  signal control_reg : std_logic_vector(63 downto 0);
  signal input_reg   : std_logic_vector(63 downto 0);
  signal output_reg  : std_logic_vector(63 downto 0);
  signal puf_rstn    : std_logic;
  signal puf_ena     : std_logic;
  signal puf_done    : std_logic;
begin
  U0_PUF : puf
    generic map (
      INPUT_WIDTH    => 64,
      OUTPUT_WIDTH   => 64,
      RING_OSC_DEPTH => 20)
    port map (
      clk             => clk,
      rstn            => puf_rstn,
      ena             => puf_ena,
      done            => puf_done,
      challenge_input => input_reg,
      response_output => output_reg);

  U1_READ_PROC : process(clk, rstn)
  begin
    if rstn = '0' then
      PUF_readdata <= (others => '0');
    else
      if rising_edge(clk) then
        if PUF_read = '1' then
          case PUF_address is
            when x"000" =>
              PUF_readdata <= control_reg;
            when x"001" =>
              PUF_readdata <= output_reg(63 downto 0);
            when others =>
              PUF_readdata <= (others => 'X');
          end case;
        end if;
      end if;
    end if;
  end process;

  U2_WRITE_PROC : process(clk, rstn)
  begin
    if rising_edge(clk) then
      if PUF_write = '1' then
        case PUF_address is
          when x"000" =>
            control_reg(63 downto 0) <= PUF_writedata(63 downto 0);
          when x"001" =>
            input_reg(63 downto 32) <= PUF_writedata(31 downto 0);
            input_reg(31 downto 0)  <= PUF_writedata(63 downto 32);
          when x"002" =>
            input_reg(15 downto 0)  <= PUF_writedata(63 downto 48);
            input_reg(63 downto 48) <= PUF_writedata(47 downto 32);
            input_reg(47 downto 32) <= PUF_writedata(31 downto 16);
            input_reg(31 downto 16) <= PUF_writedata(15 downto 0);
                      when x"003" =>
            input_reg(63 downto 48) <= PUF_writedata(63 downto 48);
            input_reg(47 downto 32) <= PUF_writedata(47 downto 32);
            input_reg(31 downto 16) <= PUF_writedata(31 downto 16);
            input_reg(15 downto 0)  <= PUF_writedata(15 downto 0);
          when x"004" =>
            input_reg(47 downto 32) <= PUF_writedata(63 downto 48);
            input_reg(15 downto 0)  <= PUF_writedata(47 downto 32);
            input_reg(31 downto 16) <= PUF_writedata(31 downto 16);
            input_reg(63 downto 48) <= PUF_writedata(15 downto 0);
          when others =>
        end case;
      end if;
    end if;
  end process;

  --Assign the signal
  puf_rstn       <= not control_reg(63);
  puf_ena        <= control_reg(0);
  control_reg(1) <= puf_done;
end architecture rtl;