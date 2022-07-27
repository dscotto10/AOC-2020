use Moose;
#DCS Day 5, AOC 2020
use Data::Dumper qw(Dumper);

#really important for how to use classes (packages) in Perl with Moose.
#functions need to exist outside of the package, as far as I can tell.


#Perl uses 'packages' in place of classes.
package BoardingPass;
#This means that we can dump stuff from the package.
use Data::Dumper;
#"Moose" is how Perl does object-oriented stuff.
use Moose;

#There are three 'attributes' in this class, all of which are read/write (is => 'rw').
    has 'seat_row' => (is => 'rw');
    has 'seat_column' => (is => 'rw');
    has 'seat_number' => (is => 'rw');

#Removing any of these lines seems to have no impact. But...
#no Moose says "stop using Moose"
#make_immutable improves performance, in theory.
1;
no Moose;
__PACKAGE__->meta->make_immutable;

#Moving out of our BoardingPass package.
package main;

#file to import the text.
sub File_import
{
    my $data_input = $_[0];
    open INFILE, "$data_input";
    my @b = <INFILE> ;
    close INFILE ;
    return @b;
}

#Main procedure.
sub Day_5
{
    #This is the input file.
    my $todays_data = 'dcs_day5_input.txt';
    #This one runs "File_import" on the text file identified above.
    my @data_import = File_import($todays_data);
    #This procedure takes our list of records and converts them into a hash of boarding pass details.
    my %my_boarding_passes = build_passes(@data_import);
    #Answer 5A.
    #Note the syntax for passing a hash object. The \ makes it a "reference" to the object.
    #Syntax in the subroutine needs to "de-reference" the object.
    print "5A: " . get_max_seat_number(\%my_boarding_passes) . "\n";
    #Answer 5B.
    print "5B: " . find_missing_seat(\%my_boarding_passes) . "\n";
}
 
#This procedure takes its array input and converts it into a hash of BoardingPass objects.
sub build_passes
{
    #Accept the array as input.
    my @boarding_passes = @_;
    #Create a blank hash called "boarding_pass_hash."
    my %boarding_pass_hash = ();
    #For loop: iterate through every $item in @boarding passes.
    for my $item (@boarding_passes)
    {
        #Remove the line break.
        $item =~ s/\n//;
        #Add a new BoardingPass object.
        my $bp = BoardingPass->new;
        #Set up a key/value pair: the key is the $item from @boarding_passes.
        #The value is the BoardingPass object.
        $boarding_pass_hash{$item} = $bp;
        #These next 3 lines set up the attributes for our new hash.
        #Seat row: process the first 7 characters.
        $boarding_pass_hash{$item}->seat_row(row_calc(substr($item,0,7)));
        #Seat column: process characters 8-10.
        $boarding_pass_hash{$item}->seat_column(col_calc(substr($item,7,3)));
        #Seat number: row * 8 + column.
        $boarding_pass_hash{$item}->seat_number($boarding_pass_hash{$item}->seat_row * 8 + $boarding_pass_hash{$item}->seat_column);
    }
    #Now the hash is built! So return this hash from the subroutine.
    return %boarding_pass_hash;
}
 
 #row_calc is all about calculating the row based on the binary input logic.
 #F is front half of airplane; B is back half.
 sub row_calc
 {
    #Take in string input.
     my $row_binary = $_[0];
    #Set a score to 0.
     my $row_score = 0;
     #print $row_binary . "\n";
     #Set a counter to 0 for a while loop.
     my $x = 0;
     #Iterate 0-6 times.
     while ($x <= 6)
     {
        #Check if the character is 'F.' If so, add nothing to row_score.
        #If it's B, you'll want to add 64 divided by 2^xth power to row_score.
        #So for the third item, it would be 64 / 2^2, or 16.
        #This is just to simplify the implementation. You could also spell out each case explicitly.
        if (substr($row_binary,$x,1) eq "F")
        { 
            $row_score += 0
        }
        else
        {
            $row_score += (64 / 2**($x));
        }
        #Increment the counter.
        $x++;
    }
     return $row_score;
 }
 
 #col_calc is very similar to row_calc, except it only uses 3 character positions (8-10), and L/R rather than F/B.
 #Otherwise, the logic is identical.
 sub col_calc
 {
     my $col_binary = $_[0];
     my $col_score = 0;
     #print $col_binary . "\n";
     my $x = 0;
     while ($x <= 2)
     {
        if (substr($col_binary,$x,1) eq "L")
        { 
            $col_score += 0
        }
        else
        {
            $col_score += (4 / 2**($x));
        }
        $x++;
    }
     return $col_score;
 }

 #5A's goal is to get the max seat number.
sub get_max_seat_number
{
    #Pass in a reference to your hash, and de-reference it.
     my %boarding_passes = %{$_[0]};
    #Set the max_seat_number to 0.
     my $max_seat_number = 0;
     #Check through each item in your hash.
     foreach my $key (keys %boarding_passes)
     {
        #Simple logic here: if the seat number in a given BoardingPass object is greater than the existing max...
        #... replace it. Otherwise, leave it as is.
         if ($boarding_passes{$key}->seat_number > $max_seat_number)
         {
            $max_seat_number = $boarding_passes{$key}->seat_number;
        }
    }
    #Return the max_seat_number.
    return $max_seat_number;
}

#5B's goal is to find the missing seat.
sub find_missing_seat
{
    #Pass in a reference to your hash, and de-reference it.
    my %boarding_passes = %{$_[0]};
    #Set up a blank array.
    my @seat_array = ();
    #Iterate through each object in the hash.
    foreach my $key (keys %boarding_passes)
    {
        #Just add every seat_number to your new @seat_array list.
        push(@seat_array,$boarding_passes{$key}->seat_number);
    }
    #This is how you sort numbers in descending order.
    #This is apparently called the "spaceship operator."
    #We're creating a new array (@sorted_seats) from the old array (@seat_array).
    my @sorted_seats = sort { $b <=> $a } @seat_array;
    #Another counter for a for loop.
    my $x = 0;
    #This is basically 'go through every number in @sorted_seats.
    while ($x <= scalar @sorted_seats)
    {
        #Look at the value of the current position, and the next position.
        #If they're two apart, stop looking; you've found your answer. Get out of the loop.
        #That's what "last" does.
        if ($sorted_seats[$x] - $sorted_seats[$x+1] == 2)
        {
            last;
        }
        #Increment the counter.
        $x++;
    }
    #Grab the value of the seat that you hit on, and subtract one.
    #That finds you your missing seat.
    return $sorted_seats[$x] - 1;
}

Day_5()
