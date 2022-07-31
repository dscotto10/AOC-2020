#DCS day 8

use Data::Dumper qw(Dumper);

#how to import the file.
sub File_import
{
    $data_input = $_[0];
    open INFILE, "$data_input";
    @b = <INFILE> ;
    #quick FOR loop to get rid of the line breaks.
    for $item (@b)
    {
        $item =~ s/\n//gi;
    }
    close INFILE ;
    return @b;
}

sub Day_8
{
    $todays_data = 'dcs_day8_input.txt';
    @data_import = File_import($todays_data);
    #Convert the data import to a hash.
    #Keys = numerical position; Values = specific instructions.
    my %instructions = create_instruction_num_hash(@data_import);
    #For 8A we're just returning the accumulator value for our standard run. So turn_it_on does that.
    print "8A: " . turn_it_on(\%instructions) . "\n";
    #This FOR loop iterates through every key in the instruction (positions).
    #It then runs a "replacement" process for a single position ($i).
    #Then it runs the turn_it_on procedure. When it finds the path out, it prints it.
    #Then it re-runs the replacement to get it back to its normal state.
    for $i (keys %instructions)
    {
        %instructions = replace_one(\%instructions,$i);
        turn_it_on(\%instructions);
        %instructions = replace_one(\%instructions,$i);
    }
    
}

#Straightforward procedure to make a k/v pair, k:v::position:instruction.
sub create_instruction_num_hash
{
    my @source_data = @_;
    my %instruction_hash = ();
    my $x = 0;
    #For each record in the data source.
    foreach my $item (@source_data)
    {
        #Make a value in a hash with a key of just an incremented number.
        $instruction_hash{$x} = $item;
        $x += 1;
    }
    return %instruction_hash;
}

#The guts of the program.
sub turn_it_on
{
    my %instruction_hash = %{$_[0]};
    my %history_hash = ();
    my $accumulator = 0;
    my $current_position = 0;
    my $current_instruction = 0;
    my $x = 0;
    #This is basically a "while True" in Python.
    while ($x == $x)
    {
        #Note that we know that we've "finished" when we reach a position that DOES NOT exist in the instructions.
        #That's what this one does.
        #To get the 8B answer we just need to print the accumulator value at the time of finishing.
        #We're also done at that exact moment, so we can exit.
        if (exists $instruction_hash{$current_position} == 0)
        {
            print "8B: " . $accumulator . "\n";
            exit;
        }
        #Otherwise, we have some stuff to do.
        else
        {
            #Get the instruction from the hash.
            $current_instruction = $instruction_hash{$current_position};
            #Make it a list.
            @current_instruction_list = split(/ /,$current_instruction);
            #Make sure we have included it in our "history hash," which tells us how often we've been in a given position.
            $history_hash{$current_position} += 1;
            #If we've been there more than once...
            if ($history_hash{$current_position} > 1)
            {
                #This will be our 8A answer...
                #... and it means we're wrong on it as an 8B guess. So we should move on.
                return $accumulator;
                last;
            }
            #If it's 'nop' we just move up one.
            elsif ($current_instruction_list[0] eq 'nop')
            {
                $current_position += 1;
            }
            #If it's 'acc' we move up one AND we increase the accumulator value.
            elsif ($current_instruction_list[0] eq 'acc')
            {
                $accumulator += int($current_instruction_list[1]);
                $current_position += 1;
            }
            #If it's 'jmp' we just change the position based on the value.
            else
            {
                $current_position += int($current_instruction_list[1]);
            }
            
        }
    }
}

#Replacement algorithm. We run this twice per check.
sub replace_one
{
    #This input is the position to replace.
    my $replace_position = $_[1];
    #This is the instructions.
    my %instruction_hash = %{$_[0]};
    #This grabs the instruction we're going to replace.
    $replace_instruction = $instruction_hash{$replace_position};
    #This one splits it into a list on the space.
    @replace_instruction_list = split(/ /,$replace_instruction);
    #If it's "nop" it should be swapped to "jmp," so we do that with regex.
    if ($replace_instruction_list[0] eq 'nop')
    {
        $instruction_hash{$replace_position} =~ s/nop/jmp/gi;
    }
    #If it's "jmp" it should be swapped to "nop."
    #We have to use elsif here b/c we don't want to flip back too quickly.
    elsif ($replace_instruction_list[0] eq 'jmp')
    {
        $instruction_hash{$replace_position} =~ s/jmp/nop/gi;
    }
    return %instruction_hash;
}

Day_8()
