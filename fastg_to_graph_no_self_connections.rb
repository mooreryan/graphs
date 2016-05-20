#!/usr/bin/env ruby
require 'parse_fasta'
require 'fail_fast'
include FailFast::Assertions
n=0
FastaFile.open(ARGV.first).each_record_fast do |head, seq|
  n+=1;STDERR.printf("%d\r", n) if (n%10_000).zero?
  # tildes mean something a bit more complicated in fastG
  abort "\n\nOH SNAP A TILDE\n\n" if head.match /~/

  # remove any of the reverse compliment headers -> ie treat rev comp
  # the same as regulars
  names = head.split(/[:;,]/).map { |head| head.sub(/'$/, '') }.uniq

  if names.count > 1
    names.each_cons(2).each do |arr|
      puts arr.join "\t"
    end
  end
end
