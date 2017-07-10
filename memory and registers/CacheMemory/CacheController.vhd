library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity CacheController is
    port (
        clk : in std_logic;
        read : in std_logic;
        write : in std_logic;
        hit : in std_logic;
        match1_notMatch0 : in std_logic;

        dataArray_writeEnable0 : out std_logic;
        dataArray_writeEnable1 : out std_logic;

        tagValid_writeEnable0 : out std_logic;
        tagValid_writeEnable1 : out std_logic;

        invalidate0 : out std_logic;
        invalidate1 : out std_logic;

        resetCounters : out std_logic;
        resetCounter0 : out std_logic;
        incrementCounter0 : out std_logic;
        resetCounter1 : out std_logic;
        incrementCounter1 : out std_logic;

        replace1_notReplace0 : in std_logic;

        readMem : out std_logic;
        writeMem : out std_logic;

        cacheDataReady : out std_logic
    );
end entity;

architecture CacheController_ARCH of CacheController is
    type state is (wait_before_start, start, invalidate_cache, read_from_cache, read_from_memory, wait_for_mem_data, write_to_cache);
    signal currrentState : state := wait_before_start;
    signal nextState : state;
begin
    process (clk)
    begin
        if(clk'event and clk = '1') then
          currrentState <= nextState;  
        end if;
    end process;

    process (currrentState)
    begin
        dataArray_writeEnable0 <= '0';
        dataArray_writeEnable1 <= '0';
        tagValid_writeEnable0 <= '0';
        tagValid_writeEnable1 <= '0';
        invalidate0 <= '0';
        invalidate1 <= '0';
        resetCounters <= '0';
        resetCounter0 <= '0';
        incrementCounter0 <= '0';
        resetCounter1 <= '0';
        incrementCounter1 <= '0';
        readMem <= '0';
        writeMem <= '0';
        cacheDataReady <= '0';

        case currrentState is
            when wait_before_start => 
                cacheDataReady <= '1';
                nextState <= start;
            when start =>
                if(read = '1') then
                    nextState <= read_from_cache;
                elsif (write = '1') then
                    writeMem <= '1';
                    nextState <= invalidate_cache;
                else
                  nextState <= wait_before_start;
                end if;
            when invalidate_cache  =>
                if(hit = '1') then
                    if(match1_notMatch0 = '0') then
                        invalidate0 <= '1';
                        tagValid_writeEnable0 <= '1';
                    else
                        invalidate1 <= '1';
                        tagValid_writeEnable1 <= '1';
                    end if;
                end if;
                nextState <= wait_before_start;
            when read_from_cache => 
                if(hit = '1') then
                    cacheDataReady <= '1';
                    nextState <= wait_before_start;
                    if(match1_notMatch0 = '0') then
                        incrementCounter0 <= '1';
                    else
                        incrementCounter1 <= '1';
                    end if;
                else
                    readMem <= '1';
                    nextState <= read_from_memory;
                end if;
            when read_from_memory =>
                readMem <= '1';
                nextState <= wait_for_mem_data;
            when wait_for_mem_data =>
                readMem <= '1';
                nextState <= write_to_cache;
            when write_to_cache =>
                -- replacement
                if(replace1_notReplace0 = '1') then
                    invalidate1 <= '0';
                    tagValid_writeEnable1 <= '1';
                    dataArray_writeEnable1 <= '1';
                else
                    invalidate0 <= '0';
                    tagValid_writeEnable0 <= '1';
                    dataArray_writeEnable0 <= '1';
                end if;
                cacheDataReady <= '1';
                nextState <= wait_before_start;

            when OTHERS =>
                nextState <= wait_before_start;

        end case;
    end process;
end architecture;