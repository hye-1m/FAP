function [R,af]=measure(Freq)
    %1 : Range of frquency
    set_freq=unique(Freq);
    R=0.15*(set_freq(end)-set_freq(1)+1);

    %2 : Number of used frequency
    af=size(set_freq,2);
end