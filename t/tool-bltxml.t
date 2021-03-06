# -*- cperl -*-
use strict;
use warnings;
use Test::More tests => 2;
use Test::Differences;
unified_diff;

use Encode;
use Biber;
use Biber::Utils;
use Biber::Output::biblatexml;
use Log::Log4perl;
use Unicode::Normalize;
chdir("t/tdata");
no warnings 'utf8';
use utf8;

# Set up Biber object
my $biber = Biber->new( configfile => 'tool-test.conf');
my $LEVEL = 'ERROR';
my $l4pconf = qq|
    log4perl.category.main                             = $LEVEL, Screen
    log4perl.category.screen                           = $LEVEL, Screen
    log4perl.appender.Screen                           = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.utf8                      = 1
    log4perl.appender.Screen.Threshold                 = $LEVEL
    log4perl.appender.Screen.stderr                    = 0
    log4perl.appender.Screen.layout                    = Log::Log4perl::Layout::SimpleLayout
|;
Log::Log4perl->init(\$l4pconf);

my $outvar;

$biber->set_output_obj(Biber::Output::biblatexml->new());
# Get reference to output object
my $out = $biber->get_output_obj;
# Set the output target
$out->set_output_target_file(\$outvar);

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('tool', 1);
Biber::Config->setoption('output_resolve', 1);
Biber::Config->setoption('output_format', 'biblatexml');
Biber::Config->setoption('sortlocale', 'en_GB.UTF-8');

# THERE IS A CONFIG FILE BEING READ!

# Now generate the information
$ARGV[0] = 'tool.bib'; # fake this as we are not running through top-level biber program
$biber->tool_mode_setup;
$biber->prepare_tool;
$out->output;
my $main = $biber->sortlists->get_list(99999, Biber::Config->getblxoption('sortscheme'), 'entry', Biber::Config->getblxoption('sortscheme'));

my $bltxml1 = q|<?xml version="1.0" encoding="UTF-8"?>
<!-- Auto-generated by Biber::Output::biblatexml -->

<bltx:entries xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml">
  <bltx:entry id="i3Š" entrytype="unpublished">
    <bltx:author>
      <bltx:person>
        <bltx:last>
          <bltx:namepart initial="A">AAA</bltx:namepart>
        </bltx:last>
      </bltx:person>
      <bltx:person>
        <bltx:last>
          <bltx:namepart initial="B">BBB</bltx:namepart>
        </bltx:last>
      </bltx:person>
      <bltx:person>
        <bltx:last>
          <bltx:namepart initial="C">CCC</bltx:namepart>
        </bltx:last>
      </bltx:person>
      <bltx:person>
        <bltx:last>
          <bltx:namepart initial="D">DDD</bltx:namepart>
        </bltx:last>
      </bltx:person>
      <bltx:person>
        <bltx:last>
          <bltx:namepart initial="E">EEE</bltx:namepart>
        </bltx:last>
      </bltx:person>
    </bltx:author>
    <bltx:institution>
      <bltx:item>REPlaCEDte</bltx:item>
      <bltx:item>early</bltx:item>
    </bltx:institution>
    <bltx:lista>
      <bltx:item>list test</bltx:item>
    </bltx:lista>
    <bltx:listb>
      <bltx:item>late</bltx:item>
      <bltx:item>early</bltx:item>
    </bltx:listb>
    <bltx:location>
      <bltx:item>one</bltx:item>
      <bltx:item>two</bltx:item>
    </bltx:location>
    <bltx:abstract>Some abstract %50 of which is useless</bltx:abstract>
    <bltx:note>i3Š</bltx:note>
    <bltx:title>Š title</bltx:title>
    <bltx:userb>test</bltx:userb>
    <bltx:date>2003</bltx:date>
  </bltx:entry>
  <bltx:entry id="xd1" entrytype="book">
    <bltx:author>
      <bltx:person>
        <bltx:last>
          <bltx:namepart initial="E">Ellington</bltx:namepart>
        </bltx:last>
        <bltx:first>
          <bltx:namepart initial="E">Edward</bltx:namepart>
        </bltx:first>
      </bltx:person>
    </bltx:author>
    <bltx:location>
      <bltx:item>New York</bltx:item>
      <bltx:item>London</bltx:item>
    </bltx:location>
    <bltx:publisher>
      <bltx:item>Macmillan</bltx:item>
    </bltx:publisher>
    <bltx:note>A Note</bltx:note>
    <bltx:date>2001</bltx:date>
  </bltx:entry>
  <bltx:entry id="macmillan" entrytype="xdata">
    <bltx:id>
      <bltx:item>macmillanalias</bltx:item>
    </bltx:id>
    <bltx:location>
      <bltx:item>New York</bltx:item>
      <bltx:item>London</bltx:item>
    </bltx:location>
    <bltx:publisher>
      <bltx:item>Macmillan</bltx:item>
    </bltx:publisher>
    <bltx:note>A Note</bltx:note>
    <bltx:date>2001</bltx:date>
  </bltx:entry>
  <bltx:entry id="macmillan:pub" entrytype="xdata">
    <bltx:id>
      <bltx:item>macmillan:pubALIAS</bltx:item>
    </bltx:id>
    <bltx:publisher>
      <bltx:item>Macmillan</bltx:item>
    </bltx:publisher>
  </bltx:entry>
  <bltx:entry id="macmillan:loc" entrytype="xdata">
    <bltx:location>
      <bltx:item>New York</bltx:item>
      <bltx:item>London</bltx:item>
    </bltx:location>
    <bltx:note>A Note</bltx:note>
  </bltx:entry>
  <bltx:entry id="b1" entrytype="book">
    <bltx:crossref>mv1</bltx:crossref>
    <bltx:mainsubtitle>Mainsubtitle</bltx:mainsubtitle>
    <bltx:maintitle>Maintitle</bltx:maintitle>
    <bltx:maintitleaddon>Maintitleaddon</bltx:maintitleaddon>
    <bltx:title>Booktitle</bltx:title>
    <bltx:date>1999</bltx:date>
  </bltx:entry>
  <bltx:entry id="mv1" entrytype="mvbook">
    <bltx:id>
      <bltx:item>mvalias</bltx:item>
    </bltx:id>
    <bltx:subtitle>Mainsubtitle</bltx:subtitle>
    <bltx:title>Maintitle</bltx:title>
    <bltx:titleaddon>Maintitleaddon</bltx:titleaddon>
  </bltx:entry>
</bltx:entries>
|;

# NFD here because we are testing internals here and all internals expect NFD
eq_or_diff(decode_utf8($outvar), $bltxml1, 'bltxml tool mode - 1');
is_deeply([$main->get_keys], ['macmillan:pub', 'macmillan:loc', 'mv1', 'b1', 'xd1', 'macmillan', NFD('i3Š')], 'tool mode sorting');
