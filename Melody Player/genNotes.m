function [Note, notes_count] = genNotes(score, empty_Note, notes_count, tempo, velocity)
    for i=1:size(score,1)
        notes_count = notes_count + 1;
        empty_Note(notes_count, 1) = 1;
        empty_Note(notes_count, 2) = 0;
        empty_Note(notes_count, 3) = score(i,1);
        empty_Note(notes_count, 4) = velocity;
        empty_Note(notes_count, 5) = score(i,2)*(60/tempo);
        empty_Note(notes_count, 6) = score(i,2) + (score(i,3)*(60/tempo));


    end
    Note = empty_Note;
    notes_count = notes_count;
end