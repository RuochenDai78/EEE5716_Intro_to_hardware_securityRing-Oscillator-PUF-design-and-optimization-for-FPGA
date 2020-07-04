library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity puf is
  generic (
    INPUT_WIDTH    : integer := 64;
    OUTPUT_WIDTH   : integer := 64;
    RING_OSC_DEPTH : integer := 20);
  port (
    clk             : in  std_logic;
    rstn            : in  std_logic;
    ena             : in  std_logic;
    done            : out std_logic;
    challenge_input : in  std_logic_vector(63 downto 0);
    response_output : out std_logic_vector(63 downto 0));
end entity puf;

architecture rtl of puf is
  constant OSC_NUM        : integer := 256;
  constant COUNTER_NUM    : integer := 256;
  constant COMPARATOR_NUM : integer := 128;
  constant MUX_LVL_1_NUM  : integer := 64;
  constant MUX_LVL_2_NUM  : integer := 64;
  component ring_oscillator is
    generic (
      CHAIN_WIDTH : positive);
    port (
      rstn   : in  std_logic;
      output : out std_logic);
  end component ring_oscillator;
  component comparator is
    generic (
      WIDTH : integer);
    port (
      val_a    : in  std_logic_vector(63 downto 0);
      val_b    : in  std_logic_vector(63 downto 0);
      solution : out std_logic);
  end component comparator;
  component counter is
    generic (
      WIDTH : integer);
    port (
      clk      : in  std_logic;
      rstn     : in  std_logic;
      ena      : in  std_logic;
      finished : out std_logic;
      count    : out std_logic_vector(63 downto 0));
  end component counter;
  component mux is
    port (
      in0  : in  std_logic;
      in1  : in  std_logic;
      sel  : in  std_logic;
      out0 : out std_logic);
  end component mux;
  type count_t is array (COUNTER_NUM-1 downto 0) of std_logic_vector(63 downto 0);
  signal count         : count_t;
  type osc_output_t is array (OSC_NUM-1 downto 0) of std_logic;
  signal osc_output    : osc_output_t;
  type solution_t is array (COMPARATOR_NUM-1 downto 0) of std_logic;
  signal solution      : solution_t;
  type mux_lvl_1_out_t is array (MUX_LVL_1_NUM-1 downto 0) of std_logic;
  signal mux_lvl_1_out : mux_lvl_1_out_t;
  type finished_t is array (COUNTER_NUM-1 downto 0) of std_logic;
  signal finished      : finished_t;
begin
  U0_GEN_RING_OSC : for i in 0 to OSC_NUM-1
  generate
    U0_OSC : ring_oscillator
      generic map (
        CHAIN_WIDTH => RING_OSC_DEPTH)
      port map (
        rstn   => rstn,
        output => osc_output(i));
  end generate;

  U1_GEN_COUNTER : for i in 0 to COUNTER_NUM-1
  generate
    U1_COUNTER : counter
      generic map (
        WIDTH => 64)
      port map (
        clk      => osc_output(i),
        rstn     => rstn,
        ena      => ena,
        finished => finished(i),
        count    => count(i));
  end generate;

  done <= (finished(0));

  U2_GEN_COMPARATOR : for i in 0 to COMPARATOR_NUM-1
  generate
    U2_COMPARATOR : comparator
      generic map (
        WIDTH => 64)
      port map (
        val_a    => count(i*2),
        val_b    => count(i*2+1),
        solution => solution(i));
  end generate;

  U3_GEN_MUX_LVL_1 : for i in 0 to MUX_LVL_1_NUM-1
  generate
    U3_MUX_LVL_1 : mux
      port map (
        in0  => solution(i*2),
        in1  => solution(i*2+1),
        sel  => challenge_input(i),
        out0 => mux_lvl_1_out(i));
  end generate;

  U4_GEN_MUX_LVL_2 : for i in 0 to MUX_LVL_2_NUM-1
  generate
    U4_MUX_LVL_2 : mux
      port map (
        in0  => mux_lvl_1_out(i),
        in1  => solution(i*2),
        sel  => challenge_input(i),
        out0 => response_output(i));
  end generate;
end architecture rtl;