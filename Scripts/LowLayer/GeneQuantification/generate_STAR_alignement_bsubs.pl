#! /usr/bin/perl

use strict;
use Data::Dumper;

my ($sampleInfo) = @ARGV[0];

open(sampleInfo, $sampleInfo) or die "Cannot open $sampleInfo";

my %Fastq;

while (<sampleInfo>) {
  chomp;
  my $line = $_;
  my @line = split(/_/, $line);
  my $sample = $line[0];
  my $lane = $line[2];
  my $pair = $line[3];
  my $numberLong = $line[4];
  my $number = (split(/\./, $numberLong))[0];
  $Fastq{$sample}{$lane}{$number}{$pair} = $line;
}

# print Dumper %Fastq;
# exit;

my $input = "/scratch/cluster/monthly/mjan/BXD_Franken/fastq_liver_clean";
my $output = "/scratch/cluster/monthly/mjan/BXD_Franken/STAR_liver";
my $BTgenome = '/scratch/cluster/monthly/mjan/BXD_Franken/mm9_Ref_Liver';
my $memory = 40000;
my $memoryKb = $memory * 1024;

my $finalCommand;
my $myOutput;
my @R1;
my @R2;

print "# 2pass
module add UHTS/Aligner/STAR/2.4.0g;
";

foreach my $SAMPLE (sort keys(%Fastq)) {
  # print "$SAMPLE\n";
  foreach my $lane (sort keys(%{$Fastq{$SAMPLE}})) {
    #print "$SAMPLE\t$lane\n";
    foreach my $number (sort keys(%{$Fastq{$SAMPLE}{$lane}})) {
      #print "$SAMPLE\t$lane\t$number\n";
      my $R1_fastq = $Fastq{$SAMPLE}{$lane}{$number}{'R1'};
      my $R2_fastq = $Fastq{$SAMPLE}{$lane}{$number}{'R2'};
      #print "$R1_fastq\t$R2_fastq\n";
      push(@R1, $input."/".$R1_fastq);
      push(@R2, $input."/".$R2_fastq);
      # print join(",", @R1);
      # print "\n";
      # print join(",", @R2);
    }
  }
    my $command1 = "bsub -q dee-hugemem -o $output/2pass_$SAMPLE.out -e $output/2pass_$SAMPLE.err -n 16 -R \"span[hosts=1]\" -R \"rusage[mem=$memory]\" -M $memoryKb \"STAR --genomeDir $BTgenome --outFilterIntronMotifs RemoveNoncanonicalUnannotated --readFilesCommand zcat --outFileNamePrefix 2pass_$SAMPLE\_ --runThreadN 16 --readFilesIn ";
    my $command2 = join(",", @R1);
    #my $command3 = join(",", @R2);
    my $command4 = "--outSAMtype BAM SortedByCoordinate --limitBAMsortRAM 50000000000\"\n";

    #$finalCommand = join " ", $command1, $command2, $command3, $command4;
    $finalCommand = join " ", $command1, $command2, $command4;
	
    $finalCommand =~ s/,  "/"/g;
  
    print "$finalCommand";
    undef @R1;
    undef @R2;
}



