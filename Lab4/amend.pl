#!/usr/bin/perl 
#
$op = shift or die "Błąd :(";
for(@ARGV){
    open my $in, '<', $_ or die "Can't read file: $!";
    open my $out, '>', "$_.new" or die "Can't create file: $!";
    $name=$_;
    $counter=0;
    while( <$in>  ) { 
             $counter++ if eval $op;
             print $out $_;
    }
  print("W pliku: ",$name, " zmieniono ", $counter," lini\n");   
}
close $in;
close $out;
exec("./rename.pl 's/txt.new\$/txt/s' *.new");
