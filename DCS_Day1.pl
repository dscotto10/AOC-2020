#DCS Day 1

sub File_import
{
    $data_input = $_[0];
    open INFILE, "$data_input";
    @b = <INFILE> ;
    close INFILE ;
    return @b;
}

$todays_data = 'dcs_day1_input.txt' ;
@data_import = File_import($todays_data);

print Dumper $data_import . "\n";

#1A Procedure
foreach $number_one (@data_import)
    {
    foreach $number_two (@data_import)
        {
        if ($number_one + $number_two == 2020)
            {
                $product_2020a = $number_one * $number_two;
                break;
            }
        }
    }

#1B Procedure
foreach $number_one (@data_import)
    {
    foreach $number_two (@data_import)
        {
            foreach $number_three (@data_import)
            {
                if ($number_one + $number_two + $number_three == 2020)
                {
                    $product_2020b = $number_one * $number_two * $number_three;
                    break;
                }
            }
        }
    }
    
print "1A: " . $product_2020a . "\n";
print "1B: " . $product_2020b . "\n";
