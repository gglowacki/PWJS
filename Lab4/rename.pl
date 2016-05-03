#!/usr/bin/perl

$op= shift or die "Błąd";
for (@ARGV) {
    $pre_rename = $_;
    eval $op;
    rename($pre_rename,$_) unless $pre_rename eq  $_;
    print("Zmieniono ", $pre_rename, " na ", $_, "\n");
}
