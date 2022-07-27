#DCS Day 4, AOC 2020
use Data::Dumper qw(Dumper);

#Note that this file has some really good regex examples, referencing/dereferencing, and using subroutines.
#Lots of important lessons therein. I will spend some time commenting it up.

#import the file.
sub File_import
{
    $data_input = $_[0];
    open INFILE, "$data_input";
    @b = <INFILE> ;
    close INFILE ;
    return @b;
}

#procedure to take input && make it a single array.
sub Process_import
{
    #Get the input as an array.
    my @input_list = @_;
    #Set a counter for a while loop.
    my $x = 0;
    #Set up a list for making passport records.
    my @passport_list = ();
    #Go through every item in the array.
    while ($x <= scalar @input_list)
    {
        #Some of the records are just a single character long, so this IF statement pair handles it.
        #The single character records serve as decent breakpoints.
        #If we're longer than a single character, we should append that value to the "$current_passport."
        #If not, remove the new line, add it to @passport_list, and wipe $current_passport for the next one.        
        if (length(@input_list[$x]) > 1)
        {
            $current_passport = $current_passport . " " . @input_list[$x];
        }
        else
        {
            $current_passport =~ s/\n//g;
            push(@passport_list,$current_passport);
            $current_passport = '';
        }
        #Increment the counter.
        $x++;
    }
    #We're done, so we can return @passport_list.
    return @passport_list;
}

#Converts input into an array of hashes called @passports.
sub Make_passport_hash
 {
    #Another array.
    my @details_array = @_;
    
    #Call each record in the array "$line."
    foreach my $line (@details_array)
    {
        #Designate it as the_passport.
        my $the_passport = ();
        #Remove the leading space in each line.
        $line =~ s/^\s+//;
        #Make a blank array called "listified_line.
        @listified_line = ();
        #Split it into an array with a space as a delimiter.
        @listified_line = split(/ /, $line);
        #Now it's time to work through that new item.
        #For each of those, call them "pairs."
        foreach my $pair (@listified_line)
        {
            #Guess what? Another split! This time we're splitting on the colon.
            #Now we have an easy key/value pair.
            @listified_pair = split(/:/, $pair);
            #Make "the_passport" your key/value pair.
            $the_passport{$listified_pair[0]} = $listified_pair[1];
        }
        #Now push that k/v pair into an array, @passports.
        push(@passports,{%the_passport});
        #Clear out the_passport. This one is EXTREMELY important, as the values are sticky.
        #If your passport is missing a record it will just assume that the previous one is right. It's awful.
        %the_passport = ();
    }
    #Now bring back your array of hash references.
    return @passports;
}

#Takes input of single hash for passport, returns count of required pieces.
sub Check_passport_4a
{
    #This is de-referencing syntax. We are passing a reference to a hash, so we need to de-reference it here.
    my %passport = %{$_[0]};
    #Initalize a counter.
    my $counter = 0;
    #We're going to use this @required_fields array as something to iterate through.
    @required_fields = ('ecl','pid','eyr','hcl','byr','iyr','hgt');
    #Iterate through each item in @required_fields.
    foreach $item (@required_fields)
    {
          #Straightforward: increment the counter if the required field exists in the hash.
          $counter += 1 if (exists $passport{$item});
    }
    #Just return the counter.
    return $counter;
}

#Get data in, run individual programs in sequence.
sub Day_4
{
    $todays_data = 'dcs_day4_input.txt';
    @data_import = File_import($todays_data);
    @my_passport_list = Process_import(@data_import);
    @my_passport_hash_list = Make_passport_hash(@my_passport_list);
    #Note that these are passing references.
    print "4A: " . Run_passports_4a(\@my_passport_hash_list) . "\n";
    print "4B: " . Run_passports_4b(\@my_passport_hash_list) . "\n";
}

#Answers the 4A question: how many valid passports, given that you need to match on all 7 requirements?
sub Run_passports_4a
{
    #We are passing a reference to an array here, so we're using the de-referencing syntax.
    #It appears that we don't HAVE to pass this as a reference.
    #What's most important is harmony between the subroutine call and variable declaration.
    #If we pass a reference, we have to de-reference.
    #If we don't pass a reference, we don't have to de-reference. But those choices need to be in harmony.
    my @passport_input = @{$_[0]};
    #Counting the passports.
    $valid_passport_count = 0;
    foreach $my_passport (@passport_input)
    {
        #Running ANOTHER function.
        #This one does need a reference, because it's a hash.
        #Note the syntax! "\@$" before the variable name.
        $valid_passport_count++ if (Check_passport_4a(\%$my_passport) == 7);
    }
    #Return the counter.
    return $valid_passport_count;
}

sub Run_passports_4b
{
    #De-referencing syntax, because we passed a reference.
    #Overall, the logic here is basically identical to Run_passports_4a.
    my @passport_input = @{$_[0]};
    $valid_passport_count = 0;
    foreach $my_passport (@passport_input)
    {
        $valid_passport_count++ if (Check_passport_4b(\%$my_passport) == 7);
    }
    return $valid_passport_count;
}

#4B had very specific requirements for all of the passport attributes.
#So to implement it we have seven different functions to call.
#Basic logic: check if it exists. If it does, go through the deeper verification.
#If the verification passes, increment a counter.
sub Check_passport_4b
{
    my %passport = %{$_[0]};
    my $counter = 0;
    if (exists $passport{'byr'})
    {
        $counter += 1 if (Check_byr($passport{'byr'}) == 1);
    }
    if (exists $passport{'pid'})
    {
        $counter += 1 if (Check_pid($passport{'pid'}) == 1);
    }
    if (exists $passport{'iyr'})
    {
        $counter += 1 if (Check_iyr($passport{'iyr'}) == 1);
    }
    if (exists $passport{'hcl'})
    {
        $counter += 1 if (Check_hcl($passport{'hcl'}) == 1);
    }
    if (exists $passport{'eyr'})
    {
        $counter += 1 if (Check_eyr($passport{'eyr'}) == 1);
    }
    if (exists $passport{'hgt'})
    {
        $counter += 1 if (Check_hgt($passport{'hgt'}) == 1);
    }
    if (exists $passport{'ecl'})
    {
        $counter += 1 if (Check_ecl($passport{'ecl'}) == 1);
    }
    return $counter;
}

#Simple: find if the number is between 1920 and 2002.
sub Check_byr
{
    $check_value = $_[0];
    if ($check_value >= 1920 && $check_value <= 2002)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#Simple: find if the number is between 2010 and 2020.
sub Check_iyr
{
    $check_value = $_[0];
    if ($check_value >= 2010 && $check_value <= 2020)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#Simple: find if the number is between 2020 and 2030.
sub Check_eyr
{
    $check_value = $_[0];
    if ($check_value >= 2020 && $check_value <= 2030)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#This one is more complex, because it can handle both inches or centimeters.
#There are two possible success combos, so we use an elsif.
#Option one: between 150-193 and including "cm" in the string.
#Option two: between 59-76 and including "in" in the string.
sub Check_hgt
{
    $check_value = $_[0];
    if ($check_value >= 150 && $check_value <= 193 && (index(lc($check_value), lc("cm")) != -1))
    {
        return 1;
    }
    elsif ($check_value >= 59 && $check_value <= 76 && (index(lc($check_value), lc("in")) != -1))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#Here, we're looking for a hex value.
#The check is 'starts with a #, 7 characters long, the final 6 of which are 0-9 or a-f.
sub Check_hcl
{
    $check_value = $_[0];
    if (substr($check_value,0,1) eq '#' && length($check_value) == 7 && $check_value =~ tr/[0-9][a-f]// == 6)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#Just see if the ecl value matches one of our acceptable ones.
#Perl calls this "experimental matching" so there are other ways to implement.

sub Check_ecl
{
    $check_value = $_[0];
    @valid_ecl = ('amb','blu','brn','gry','grn','hzl','oth');
    if ( $check_value ~~ @valid_ecl ) 
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#Just looking for a 9 digit number. No letters or special characters allowed.
sub Check_pid
{
    $check_value = $_[0];
    if ( length($check_value) == 9 && $check_value =~ tr/[0-9]// == 9 ) 
    {
        return 1;
    }
    else
    {
        return 0;
    }
}


#Run it.
Day_4();
