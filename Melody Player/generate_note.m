function y = generate_note(frequency, duration, fs, n)
   t = 0 : 1/fs : duration;
   f = sin(2 * pi * frequency * t); 
   for i=2:n
       f1 = (1/i)*sin(2 * pi * (frequency * i) * t); 
       f = f + f1;
   end
   fadein = 0:8/fs:1;
   fadeout = 1:-8/fs:0;
   
   middle = ones(1, length(f) - length(fadein) - length(fadeout));
   sound = [fadein middle fadeout];

   f = sound.*f;

   f = f / ( 1.01 * max( max(f), -min(f)) );

   y=f;