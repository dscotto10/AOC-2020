#DCS Day 2

sub File_import
{
    $data_input = $_[0];
    open INFILE, "$data_input";
    @b = <INFILE> ;
    close INFILE ;
    return @b;
}

$todays_data = 'dcs_day2_input.txt' ;
@data_import = File_import($todays_data);

$valid_password_count_2a = 0;
$valid_password_count_2b = 0;

foreach $password_line (@data_import)
{
    @words = split(/[-:" "]/, $password_line);
    $min_count = $words[0];
    $max_count = $words[1];
    $search_letter = $words[2];
    $test_password = $words[4];
    #2A
    my $count == 0;
    for my $char (split //, $test_password) 
    {
        $count += 1 if $char eq $search_letter;
    }
    $valid_password_count_2a += 1 if ($count >= $min_count && $count <= $max_count);
    
    #2B
    my $count = 0;

    @password_characters = split(//, $test_password);
    $count += 1 if $password_characters[$min_count - 1] eq $search_letter;
    $count += 1 if $password_characters[$max_count - 1] eq $search_letter;
    
    $valid_password_count_2b += 1 if $count == 1;

}

print "2A: " . $valid_password_count_2a . "\n";
print "2B: " . $valid_password_count_2b . "\n";
