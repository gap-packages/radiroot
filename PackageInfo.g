#############################################################################
##  
#W PackageInfo.g               RadiRoot package               Andreas Distler
##
## The package info file for the RadiRoot package
##
#Y 2006
##

SetPackageInfo( rec(

PackageName := "RadiRoot",
Subtitle := "Roots of a Polynomial as Radicals",
Version := "2.7",
Date := "09/04/2014",

PackageWWWHome  := "https://gap-packages.github.io/radiroot/",
README_URL      := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/radiroot",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/radiroot-", ~.Version ),
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
      LastName      := "Distler",
      FirstNames    := "Andreas",
      IsAuthor      := true,
      IsMaintainer  := true,
      Email         := "a.distler@tu-bs.de",
      PostalAddress := Concatenation( [
                       "AG Algebra und Diskrete Mathematik\n", 
                       "TU Braunschweig\n", "Rebenring 31 (A14)\n",
                       "38106 Braunschweig\n", "Germany"] ),
      Place         := "Braunschweig",
      Institution   := "Technische Universität Braunschweig")
    ],

Status := "accepted",
CommunicatedBy := "Edmund Robertson (St Andrews)",
AcceptDate := "02/2007",

AbstractHTML := 
  "The <span class=\"pkgname\">RadiRoot</span> package installs a method to \
   display the roots of a rational polynomial as radicals if it is solvable.",

PackageDoc := rec(
  BookName  := "RadiRoot",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Roots of a Polynomial as Radicals",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [[ "Alnuth", ">=2.2.3" ]],
  SuggestedOtherPackages := [],
  ExternalConditions := ["latex and the dvi-viewer xdvi are recommended"]
),

AvailabilityTest := ReturnTrue,
Autoload := false,

TestFile := "tst/testall.g",

Keywords := ["roots", "radicals"]

));


#############################################################################
##
#E
