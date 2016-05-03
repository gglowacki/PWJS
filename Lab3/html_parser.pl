#!/usr/bin/perl

use HTML::TableExtract;
use Text::Table;

my $doc = $ARGV[0];
my $headers = ['NAME', 'SCORE' ];

my $table_extract = HTML::TableExtract->new(headers => $headers);
my $table_output = Text::Table->new(
    \'| ',
    {
        title=>'NAME',
        align=>'center',
        align_title=>'center'    
    },
    \"| ",
    {
        title=>'SCORE',
        align=>'center',
        align_title=>'center'
    },
    \' |',
);

$table_extract->parse_file($doc);
my($table) = $table_extract->tables;

for my $row ($table->rows){
    $table_output->load($row);
    #$table_output=~s/\./\,/g;
    #print $table_output;
}
my $rule=$table_output->rule(qw/- +/);
my @arr=$table_output->body;
print $rule, $table_output->title,$rule;
for(@arr){
     $_=~s/\./\,/g;
     $_=~s/-/0,0/g;
     print $_;   
}
#my $outfile = 'file.csv';
 
# here i 'open' the file, saying i want to write to it with the '>>' symbol
#open (FILE, ">> $outfile") || die "problem opening $outfile\n";
#print FILE $table_output;
