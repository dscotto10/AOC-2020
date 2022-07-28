use Moose;
#DCS Day 6, AOC 2020
use Data::Dumper qw(Dumper);

#file to import the text.
sub File_import
{
    my $data_input = $_[0];
    open INFILE, "$data_input";
    my @b = <INFILE> ;
    close INFILE ;
    return @b;
}

sub Day_6
{
     my $todays_data = 'dcs_day6_input.txt';
     my @data_import = File_import($todays_data);
     my @answer_array = Process_import(@data_import);
     my @set_of_answers = get_answer_hash(@answer_array);
     check_yes_answers(@set_of_answers);
}

sub check_yes_answers
{
     #Bring in the data as an array.
     my @answers = @_;
     #Initialize a few variables to do the problem answers.
     #6A asks for the number of distinct answers, roughly.
     my $letter_count = 0;
     #6B asks for the number of answers on which everyone agreed.
     my $total_consensus_people = 0;
     #iterate through each hash in the array.
     foreach my $item (@answers)
     {
        #For the 6A problem we're getting the number of keys in the array, minus 1 (for the people_count).
        $letter_count += scalar keys %{$item};
        $letter_count -= 1;
        #For 6B: we will iterate through each key in the array.
        #If the value in the key/value pair is equal to the value in the 'person_count' key/value pair, then increment.
        #We have to exclude the A = A case, or else we would get an overcount.
        my $consensus_people = 0;
        foreach my $key (keys %{$item})
        {
            #Note the syntax for calling the hash: %{$x}{$y}.
            if ($key ne 'person_count' && %{$item}{$key} == %{$item}{'person_count'})
            {
                $consensus_people += 1;
            }
        }
    #print $consensus_people ."\n";
    #Then just add the consensus people up to get the total.
    $total_consensus_people += $consensus_people;
    #Reset consensus_people for the next go around.
    $consensus_people = 0;
     }
     #Return your answers. Done and done.
     print "6A: " . $letter_count . "\n";
     print "6B: " . $total_consensus_people . "\n"
}


sub get_answer_hash
{
    #bringing in data from the main procedure.
    my @answers = @_;
    #need to create a hash record and an array record for the hashes.
    my %answer_hash = ();
    my @answer_hash_array = ();
    #iterate through every string in @answers.
    foreach my $item (@answers)
    {
       #clear the hash.
       %answer_hash = ();
       #split the comma-separated string into a list.
       #note that we could have done this earlier in the process and passed @answers as an array of arrays.
       my @listified_item = split(/[,]/,$item);
        #now we need to iterate through every record in the @listified_item.
        foreach my $char (@listified_item)
        {
            #three possible scenarios here.
            #one is the standard "letter case" that exists already in the hash as a key.
            #if so, increment the value in the key/value pair.
            if (exists $answer_hash{$char} && $char =~ m/[a-z]/)
            {
                $answer_hash{$char} += 1;
            }
            #option two is the person_count. If it's a numeric string, set that as person_count in the hash.
            elsif ($char =~ m/[0-9]/)
            {
                $answer_hash{'person_count'} = $char;
            }
            else
            #otherwise, we're dealing with a new key. Just add it.
            {
                $answer_hash{$char} = 1;
            }
        }
        #Then push %answer_hash into the @answer_hash_array.
        push(@answer_hash_array,{%answer_hash});
    }
    #bring back your array of hashes.
    return @answer_hash_array;
}

sub Process_import
{
    #Get the input as an array.
    my @input_list = @_;
    #Set a counter for a while loop.
    my $x = 0;
    #Set up a list for making answer records.
    my @answer_list = ();
    #Go through every item in the array.
    my $answer = '';
    my $person_count = 0;
    while ($x <= scalar @input_list)
    {
        #Some of the records are just a single character long, so this IF statement pair handles it.
        #The single character records serve as decent breakpoints.
        #If we're longer than a single character, we should append that value to the "$answer."
        #We also need to increment a person count there.
        #If not, remove the new line, add it to @answer_list, and wipe $answer for the next one.        
        if ((length($input_list[$x]) > 1))
        {
            $answer = $answer . " " . $input_list[$x];
            $person_count += 1;
        }
        else
        {
            #Remove the leading space.
            $answer =~ s/\s+//g;
            #Useful syntax here: splits into list of characters, then rejoins as comma-separated string.
            $answer = join(",",split(//,$answer));
            #Prepend the person count to $answer.
            $answer = $person_count . "," . $answer;
            #Add the $answer to the @answer_list.
            push(@answer_list,$answer);
            #Clear out $answer and $person_count for the next round.
            $answer = '';
            $person_count = 0;
        }
        #Increment the counter.
        $x++;
    }
    #We're done, so we can return @answer_list.
    return @answer_list;
}


Day_6()
