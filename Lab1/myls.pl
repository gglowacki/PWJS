#!/usr/bin/perl
use Fcntl ':mode';
system("clear");
format STDOUT_TOP=
                      Grzegorz Głowacki MYLS:
File                            Mode             Time        Size    
-----------------------------------------------------------------
.
format=
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @>>>>>>>>>> @>>>>>>>> @>>>>>>>>>>
$file, $prawa, $time, $size,,
.

$ftypes[S_IFDIR]="d";
$ftypes[S_IFCHR]="c";
$ftypes[S_IFBLK]="b";
$ftypes[S_IFIFO]="p";
$ftypes[S_IFREG]="-";

$num_args=$#ARGV+1;
if($num_args==0){
    $stat=0;
    $dir=".";
}elsif($ARGV[0] eq "-l"){
    $stat=1;
    $dir=$ARGV[1];
}elsif($ARGV[1] eq "-l"){
    $stat=1;
    $dir=$ARGV[0];
}else{
    $stat=0;
    $dir=$ARGV[0];
}

if($ARGV[2] eq "-L"){
    $own=1;    
}

opendir(DIR, $dir) or die "Blad otwarcia pliku, $!";
while($file=readdir DIR){
    $filePath=$dir .'/'. $file;
    if($stat!=0){
        $mode=((stat $filePath)[2]);
        $filetype=S_IFMT($mode);
        $ftype=$ftypes[$filetype];
        $time=(stat $filePath)[9];
        $time=scalar(localtime($time));
        $size=(stat($filePath))[7];
        for(my $i=9; $i>0; $i-=3){
            if($mode & 0x100){
                $prawa=$prawa . "r";
            }
            else{
                $prawa=$prawa . "-";
            }
            if($mode & 0x80){
                $prawa=$prawa . "w";
            }
            else{
                $prawa=$prawa . "-";
            }
            if($mode & 0x40){
                $prawa=$prawa . "x";
            }
            else{
                $prawa=$prawa . "-";
            }
            $mode=$mode<<3;
        }
        $prawa=$ftype . $prawa;
        write;
        if($own==1){
            $owner=getpwuid((stat($filePath))[4]);
            print"   #Owner: $owner\n";
        }
        print"\n";
    }else{
        print"$file\n";
    }
    $prawa="";
}
close DIR;
