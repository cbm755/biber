use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More tests => 3;

use Biber;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata");

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('zoterordfxml.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('fastsort', 1);
Biber::Config->setoption('sortlocale', 'C');

# Now generate the information
$biber->prepare;
my $out = $biber->get_output_obj;
my $section = $biber->sections->get_section(0);
my $main = $section->get_list('MAIN');
my $bibentries = $section->bibentries;

my $l1 = q|  \entry{http://0-muse.jhu.edu.pugwash.lib.warwick.ac.uk:80/journals/theory_and_event/v005/5.3ranciere.html}{article}{}
    \name{labelname}{1}{}{%
      {{}{Rancière}{R\bibinitperiod}{Jacques}{J\bibinitperiod}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Rancière}{R\bibinitperiod}{Jacques}{J\bibinitperiod}{}{}{}{}}%
    }
    \name{translator}{2}{}{%
      {{}{Panagia}{P\bibinitperiod}{Davide}{D\bibinitperiod}{}{}{}{}}%
      {{}{Bowlby}{B\bibinitperiod}{Rachel}{R\bibinitperiod}{}{}{}{}}%
    }
    \strng{namehash}{RJ1}
    \strng{fullhash}{RJ1}
    \field{sortinit}{R}
    \field{labelyear}{2001}
    \field{issn}{1092-311X}
    \field{journaltitle}{Theory \& Event}
    \field{library}{Project MUSE}
    \field{note}{Volume 5, Issue 3, 2001}
    \field{number}{3}
    \field{title}{Ten Theses on Politics}
    \field{volume}{5}
    \field{year}{2001}
    \verb{url}
    \verb http://0-muse.jhu.edu.pugwash.lib.warwick.ac.uk:80/journals/theory_and_event/v005/5.3ranciere.html
    \endverb
    \keyw{{creator: Rancière},{Kant, Immanuel},{Rancière}}
  \endentry

|;

my $l2 = q|  \entry{urn:isbn:0713990023}{book}{}
    \name{labelname}{1}{}{%
      {{}{Foucault}{F\bibinitperiod}{Michel}{M\bibinitperiod}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Foucault}{F\bibinitperiod}{Michel}{M\bibinitperiod}{}{}{}{}}%
    }
    \list{location}{1}{%
      {London}%
    }
    \list{publisher}{1}{%
      {Allen Lane}%
    }
    \strng{namehash}{FM1}
    \strng{fullhash}{FM1}
    \field{sortinit}{F}
    \field{labelyear}{1988}
    \field{isbn}{0713990023}
    \field{library}{webcat.warwick.ac.uk Library Catalog}
    \field{pagetotal}{279}
    \field{title}{The History of Sexuality volume 3: The Care of the Self}
    \field{year}{1988}
    \keyw{{creator: Foucault}}
  \endentry

|;

my $l3 = q|  \entry{item_54}{inbook}{}
    \name{labelname}{1}{}{%
      {{}{Foucault}{F\bibinitperiod}{Michel}{M\bibinitperiod}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Foucault}{F\bibinitperiod}{Michel}{M\bibinitperiod}{}{}{}{}}%
    }
    \name{editor}{1}{}{%
      {{}{Lotringer}{L\bibinitperiod}{Sylvère}{S\bibinitperiod}{}{}{}{}}%
    }
    \name{translator}{2}{}{%
      {{}{Hochroth}{H\bibinitperiod}{Lysa}{L\bibinitperiod}{}{}{}{}}%
      {{}{Johnston}{J\bibinitperiod}{John}{J\bibinitperiod}{}{}{}{}}%
    }
    \list{location}{1}{%
      {New York}%
    }
    \list{publisher}{1}{%
      {Semiotext(e)}%
    }
    \strng{namehash}{FM1}
    \strng{fullhash}{FM1}
    \field{sortinit}{F}
    \field{labelyear}{1996}
    \field{booktitle}{Foucault Live: Interviews, 1961-1984}
    \field{day}{04}
    \field{endday}{07}
    \field{endmonth}{04}
    \field{endyear}{1996}
    \field{isbn}{157027018}
    \field{month}{03}
    \field{title}{The Ethics of the Concern for Self as a Practice of Freedom}
    \field{year}{1996}
    \field{pages}{432\bibrangedash 449}
    \keyw{{creator: Foucault},{Foucault}}
  \endentry

|;

is( $out->get_output_entry($main, 'http://0-muse.jhu.edu.pugwash.lib.warwick.ac.uk:80/journals/theory_and_event/v005/5.3ranciere.html'), $l1, 'Basic Zotero RDF/XML test - 1') ;
is( $out->get_output_entry($main, 'urn:isbn:0713990023'), $l2, 'Basic Zotero RDF/XML test - 2') ;
is( $out->get_output_entry($main, 'item_54'), $l3, 'Basic Zotero RDF/XML test - 3') ;

unlink <*.utf8>;