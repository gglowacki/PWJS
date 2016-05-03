#!/usr/bin/perl
use warnings;
format=
    @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  @>>>>>>>>
    $document,                         $count
.   
format STDOUT_TOP=
          Grzegorz Głowacki Log file raports 
                                        Page @|||
                                            $%
    @|||||||||||||||||||||||||||||||||  @||||||||||||
    $Tittle                           ,,$Tittle_2                                    
    ----------------------------------  -------------
.
format footer=
    -------------------------------------------------
                                    Total: @|||||||
                                         $total_count
.
sub parse{
     my ($w)="(.+?)";
     m/$w \[$w\:$w $w\] $w $w $w/;     
     #91.217.161.185 [28/Feb/2016:06:52:02 +0100] /pb/sp/pw/W2.pdf 200 271812
     if($1 eq ''|| $2 eq ''|| $3 eq '' || 
        $4 eq ''|| $5 eq ''|| $6 eq '' || $7 eq''){
         system 'clear';
         print "File is missing some data :( \n";
         exit(0);
     }
     return($1, $2, $3, $4, $5, $6, $7);
}
##liczba danych przeslanych
sub data_size{
   foreach(<LOGFILE>){
     ($accessDate, $fileSize)=(parse())[1, 6];
     if(defined($accessDate)){
         if($fileSize =~m/[0-9]+/){
             $docList{$accessDate}+=$fileSize;
             $total_count+=$fileSize;
         }
     }
     foreach $document (keys(%$docList)){
         $count=$docList{$document};
     }
     }
     $Tittle_2="Size";  
}
##poprawny dostep do serwera
sub access_date{
    foreach(<LOGFILE>){
    ($accessDate, $accessCode)=(parse())[1, 5];
    if(defined($accessDate)){
        if($accessCode !~m/^4..+/){
            $docList{$accessDate}++;
            $total_count++;
        }
    }
    foreach $document (sort(keys(%docList))){
        $count=$docList{$document};
    }
    }
}
##niepoprawny dostep do serwera
sub Naccess_date{
 foreach(<LOGFILE>){
    ($accessDate, $accessCode)=(parse())[1, 5];
    if(defined($accessDate)){
        if($accessCode =~m/^4..+/){
            $docList{$accessDate}++;
            $total_count++;
        }
    }
    foreach $document (sort(keys(%docList))){
        $count=$docList{$document};
    }
    }
}
##liczba poprawnych odwołań do zasobow
sub file_access{
 foreach(<LOGFILE>){
    ($fileSpec, $accessCode)=(parse())[4, 5];
    if(defined($fileSpec)){
        if($accessCode !~m/4..+/){
            $docList{$fileSpec}++;
            $total_count++;
        }
    }
    foreach $document (sort(keys(%docList))){
        $count=$docList{$document};
   }
  }
   $Tittle="File name";
}
#liczba niepoprawnych odwolan do zasobow
sub Nfile_access{   
   foreach(<LOGFILE>){   
    ($fileSpec, $accessCode)=(parse())[4, 5];
    if(defined($fileSpec)){
        if($accessCode =~m/4..+/){
            $docList{$fileSpec}++;
            $total_count++;
        }
    }
    foreach $document (sort(keys(%docList))){
        $count=$docList{$document};
    }
   }
    $Tittle="File name";
}
#liczba odnotowantch dostepow z kazdego IP
sub ip_counter{
 foreach(<LOGFILE>){
    $accessIP=(parse())[0];
    if(defined($accessIP)){
        $docList{$accessIP}++;
        $total_count++;
    }
 }
   $Tittle="IP adress"; 
}
#wyswietlanie raportu
sub print_stat{
    foreach $document (sort(keys(%docList))){
        $count=$docList{$document};
        write;
    }
    $~="footer";
    write;
}
$Tittle="Access Date";
$Tittle_2="Count";
$total_count=0;
$input="";
$LOGFILE=$ARGV[0];
open(LOGFILE) or die (":( $!");
    print("\n\n1. Size of send files.\n".
          "2. Number of correct accesses.\n".
          "3. Number of incorrect accesses.\n".
          "4. Number of correct file requests.\n".
          "5. Number of incorrect file requests.\n".
          "6. Number of requests from specific IP adress.\n".
          "7. EXIT.\n".
          "Enter your choice: ");
    $input=<STDIN>;  
    chop ($input); 
    print "\n\n\n";
    if($input eq 1){
        data_size();
        print_stat();
    }
    elsif($input eq 2){
        access_date();   
        print_stat();
    }
    elsif($input eq 3){
        Naccess_date();
        print_stat();
    }    
    elsif($input eq 4){
        file_access();
        print_stat();
    }
    elsif($input eq 5){
        Nfile_access();
        print_stat();
    }
    elsif($input eq 6){
        ip_counter();
        print_stat();    
    }
    else{exit(0);}
close LOGFILE;
