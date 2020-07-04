library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
  generic (
    WIDTH : integer := 64);
  port (
    clk      : in  std_logic;
    rstn     : in  std_logic;
    ena      : in  std_logic;
    finished : out std_logic;
    count    : out std_logic_vector(WIDTH-1 downto 0));
end entity counter;

architecture rtl of counter is
  signal count_r        : std_logic_vector(WIDTH-1 downto 0);
  signal count_ena      : std_logic;
  signal base_count     : std_logic_vector(WIDTH/2-1 downto 0);
  signal base_count_ena : std_logic;
begin
  U0_PROC : process(clk, rstn)
  begin
    if rstn = '0' then
      count_r <= (others => '0');
    else
      if rising_edge(clk) then
        if count_ena = '1' then
          count_r <= std_logic_vector(unsigned(count_r) + 1);
        end if;
      end if;
    end if;
  end process;

  U1_PROC : process(clk, rstn)
  begin
    if rstn = '0' then
      base_count <= (others => '0');
    else
      if rising_edge(clk) then
        if base_count_ena = '1' then
          base_count <= std_logic_vector(unsigned(base_count) + 1);
        else
          base_count <= (others => '0');
        end if;
      end if;
    end if;
  end process;

  U2_PROC : process(clk, rstn)
  begin
    if rstn = '0' then
      base_count_ena <= '0';
    else
      if rising_edge(clk) then
        if ena = '1' then
          base_count_ena <= '1';
        else
          if ((unsigned(base_count) > 0) and (unsigned(base_count) < 100000)) then
            base_count_ena <= '1';
          else
            base_count_ena <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;

  count_ena <= '1' when ((unsigned(base_count) > 0) and (unsigned(base_count) < 100000)) else '0';
  count     <= count_r;
end architecture rtl;