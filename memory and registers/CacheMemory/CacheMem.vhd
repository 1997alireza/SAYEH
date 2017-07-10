library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity CacheMem is
    port (
        clk : in std_logic;
        address : in std_logic_vector(9 downto 0);
        data : inout std_logic_vector(15 downto 0);
        write : in std_logic;
        read : in std_logic;
        dataReady : out  std_logic
    );
end entity;

architecture CacheMem_ARCH of CacheMem is
    signal readMem, writeMem, memDataReady,
           
           dataArray_writeEnable0, dataArray_writeEnable1,
           tagValid_writeEnable0, tagValid_writeEnable1,
           invalidate0, invalidate1,
           resetCounters, resetCounter0, resetCounter1, incrementCounter0, incrementCounter1, 
           replace1_notReplace0,

           hit, match1_notMatch0 : std_logic;
    
    signal validTag0, validTag1 : std_logic_vector(4 downto 0); -- valid(1) & tag(4) ss
    signal dataArrayOut0, dataArrayOut1 : std_logic_vector(15 downto 0);
    signal counterOut0, counterOut1 : std_logic_vector(7 downto 0);
    signal index : std_logic_vector(5 downto 0);
    signal tag : std_logic_vector(3 downto 0); 
    signal memData : std_logic_vector(15 downto 0);
    signal memAddress : std_logic_vector(15 downto 0);

    signal ZERO : std_logic := '0';
                  
    component CacheController is
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
    end component;

    component CounterUnit is
        port (
            clk : in std_logic;
            resetAll : in std_logic;
            index : in std_logic_vector(5 downto 0);
            reset : in std_logic;
            increment : in std_logic;
            counterOut : out std_logic_vector(7 downto 0)
        );
    end component;

    component DataArray is 
        port (
            clk : in std_logic;
            index : in std_logic_vector(5 downto 0);
            writeEnable : in std_logic;
            dataIn : in std_logic_vector(15 downto 0);
            dataOut : out std_logic_vector(15 downto 0)
        );
    end component;

    component memory is
        generic (blocksize : integer := 1024);

        port (clk, readmem, writemem : in std_logic;
            addressbus: in std_logic_vector (15 downto 0);
            databus : inout std_logic_vector (15 downto 0);
            memdataready : out std_logic);
    end component;

    component MissHitLogic is
        port (
            tag : in std_logic_vector(3 downto 0);
            validTag0 : in std_logic_vector(4 downto 0);
            validTag1 : in std_logic_vector(4 downto 0);
            hit : out std_logic;
            match1_notMatch0 : out std_logic
        );
    end component;

    component ReplacementLogic is
        port (
            valid0 : in std_logic;
            valid1 : in std_logic;
            counter0 : in std_logic_vector(7 downto 0);
            counter1 : in std_logic_vector(7 downto 0);
            replace0_notReplace1 : out std_logic
        );
    end component;

    component TagValidArray is
        port (
            clk : in std_logic;
            reset : in std_logic;
            index : in std_logic_vector(5 downto 0);
            writeEnable : in std_logic;
            invalidate : in std_logic; -- it's working when writeEnable = '1'
            tagIn : in std_logic_vector(3 downto 0);
            tagValidOut : out std_logic_vector(4 downto 0)
        );
    end component;
begin
    memoryInstance : memory port map (clk, readMem, writeMem, memAddress, memData, memDataReady);
    tagValidate0 : TagValidArray port map (clk, ZERO, index, tagValid_writeEnable0, invalidate0, tag, validTag0);
    tagValidate1 : TagValidArray port map (clk, ZERO, index, tagValid_writeEnable1, invalidate1, tag, validTag1);
    MHL : MissHitLogic port map (tag, validTag0, validTag1, hit, match1_notMatch0);
    dataArray0 : DataArray port map (clk, index, dataArray_writeEnable0, data, dataArrayOut0);
    dataArray1 : DataArray port map (clk, index, dataArray_writeEnable1, data, dataArrayOut1);
    counterUnit0 : CounterUnit port map (clk, resetCounters, index, resetCounter0, incrementCounter0, counterOut0);
    counterUnit1 : CounterUnit port map (clk, resetCounters, index, resetCounter1, incrementCounter1, counterOut1);
    RL : ReplacementLogic port map (validTag0(4), validTag1(4), counterOut0, counterOut1, replace1_notReplace0);
    CC : CacheController port map (clk, read, write,
            hit, match1_notMatch0,
            dataArray_writeEnable0, dataArray_writeEnable1,
            tagValid_writeEnable0, tagValid_writeEnable1,
            invalidate0, invalidate1,
            resetCounters, resetCounter0, incrementCounter0, resetCounter1, incrementCounter1,
            replace1_notReplace0,
            readMem, writeMem,
            dataReady);

    index <= address(5 downto 0);
    tag <= address(9 downto 6);
    memAddress <= "000000" & address;

    process(clk) begin
        if(read = '1') then
            if(hit = '1') then
                if(match1_notMatch0 = '1') then
                    data <= dataArrayOut1;
                else
                    data <= dataArrayOut0;
                end if;
            else
                data <= memData;
            end if;
        else
            data <= (OTHERS => 'Z');

        end if;

        if(write = '1') then
            memData <= data;
        else
            memData <= (OTHERS => 'Z');
        end if;
    end process;

    
end architecture;