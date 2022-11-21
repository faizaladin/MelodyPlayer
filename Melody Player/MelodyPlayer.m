% finding frequency and amplitude variation using the spectrogram function
%function fft_5

%2-----------------------------------------------------------------------

[x, fs] = audioread("Guitar.wav");

fft_size = 2^11;
noverlap = floor(fft_size/1.1);
[S, F, T] = spectrogram( x, hanning(fft_size), noverlap, fft_size, fs );
S = abs(S);

%3-----------------------------------------------------------------------

figure(1);
imagesc( S.^0.5 );
set(gca, 'YDir', 'normal' );  % make the y axis run bottom up

%4-----------------------------------------------------------------------


FUND =[];
for i=fft_size+1:length(x)-fft_size-1
    FUND(end+1) = find_fund_auto(x(i-fft_size:i+fft_size), fs, fft_size);
end


%5-----------------------------------------------------------------------

figure(2);
time = 1/fs:1/fs:length(FUND)/fs;
plot(time, FUND, 'o')

%6-----------------------------------------------------------------------

MIDI = zeros(1, length(FUND));

for i=1:length(FUND)
    MIDI(i) = round(12*(log(FUND(i)/220)/log(2))+57);

end


%7-----------------------------------------------------------------------

mid = median(MIDI);

for i=2:length(MIDI)-1
    if MIDI(i-1) ~= MIDI(i) && MIDI(i) ~= MIDI(i+1) || MIDI(i) == inf || MIDI(i) < mid - 12 || MIDI(i) > mid + 12
        MIDI(i) = 0;
    end
end
figure(3);
plot(time, MIDI, "+");

%8-----------------------------------------------------------------------
starttime = 0;
endtime = 0;
currentVal = 0;
values = [];
i = 1;
while i < length(MIDI)
    if MIDI(i) ~= 0 && MIDI(i) ~= inf         
        currentVal = MIDI(i);
        starttime = i;
        while MIDI(i) == currentVal
            i = i + 1;
        end
        i = i - 1;
        endtime = i;
        if endtime-starttime > 1548
            starttime = time(starttime);
            endtime = time(endtime);
            values = [values; currentVal starttime (endtime-starttime)/4];
        end
    end
    i = i + 1;
end
values

%9-----------------------------------------------------------------------

Notes = [];
count = 0;
tempo = 74;
velocity = 127;

[Notes, count] = genNotes(values, Notes, count, tempo, velocity);

midi = matrix2midi(Notes);
[s, fs] = midi2audio(midi);
soundsc(s, fs);
writemidi(midi, 'melody.mid');



%-------------------------------------------------------------------------
function frequency_estimate = find_fund_auto (note, fs, win_size)

    r = xcorr(note, win_size, 'coeff'); 

    r = r( win_size+1 : end );

    threshold = 0.9 * max(r);

    fr_list = [];

    index = 0;

    for i=2:length(r)-1
        if r(i) > r(i-1) && r(i) > r(i+1) && r(i) > threshold
            index = i;
            break
        end
    end

    frequency_estimate = 1/(index/fs);

    
end