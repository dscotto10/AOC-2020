#DCS Day 3
use Data::Dumper qw(Dumper);

sub File_import
{
    $data_input = $_[0];
    open INFILE, "$data_input";
    @b = <INFILE> ;
    close INFILE ;
    return @b;
}

sub Make_coord
{
    my $x = $_[0];
    my $y = $_[1];
    return "x" . $x . "y" . $y;
}

sub Make_terrain
{
    my @coords = @_;
    my %coord_hash = {};
    my $x_coord = 0;
    my $y_coord = 0;
    
    #process for geting the coordinates into a key/value hash, %coord_hash.
    foreach my $line (@coords) {
        $x_coord = 0;
        @listified_line = split(//, $line);
        foreach my $char (@listified_line)
        {
            if ($char ne "\n")
            {
                $coord_hash{Make_coord($x_coord,$y_coord)} = $char;
                $x_coord += 1;
            }
            
        }
        $y_coord += 1;
    }
    return %coord_hash;
    }

sub Traversal
{
    my $x_delta = int($_[0]);
    my $y_delta = int($_[1]);
    my $map_length = int($_[2]);
    my $map_width = int($_[3]);
    my %traversal_map = %{$_[4]};
    $x_coord = 0;
    $y_coord = 0;
    $tree_count = 0;
    while ($y_coord <= $map_length)
     {
         $x_coord += $x_delta;
         $y_coord += $y_delta;
         $x_coord = $x_coord % $map_width;
         my $namer = Make_coord($x_coord,$y_coord);
         $tree_count += 1 if ($traversal_map{$namer} eq '#');
     }
    return $tree_count;
 }

$todays_data = 'dcs_day3_input.txt';
@data_import = File_import($todays_data);
%terrain_map = Make_terrain(@data_import);

$map_length = scalar @data_import - 1;
$map_width = length(@data_import[0]) - 1;

$terrain_map_ref = \%terrain_map;

#3A

$solution3a = Traversal(3,1,$map_length,$map_width,$terrain_map_ref);

#3B

$solution3b = $solution3a;
$solution3b *= Traversal(1,1,$map_length,$map_width,$terrain_map_ref);
$solution3b *= Traversal(5,1,$map_length,$map_width,$terrain_map_ref);
$solution3b *= Traversal(7,1,$map_length,$map_width,$terrain_map_ref);
$solution3b *= Traversal(1,2,$map_length,$map_width,$terrain_map_ref);

print "3A: " . $solution3a . "\n";
print "3B: " . $solution3b . "\n";
