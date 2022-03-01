#############################################################################
##  
#W PackageInfo.g               RadiRoot package               Andreas Distler
##
## The package info file for the RadiRoot package
##

SetPackageInfo( rec(

PackageName := "RadiRoot",
Subtitle := "Roots of a Polynomial as Radicals",
Version := "2.9",
Date := "01/03/2022", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

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
      IsMaintainer  := false,
      Email         := "a.distler@tu-bs.de",
  ),
  rec(
      LastName      := "GAP Team",
      FirstNames    := "The",
      IsAuthor      := false,
      IsMaintainer  := true,
      Email         := "support@gap-system.org",
  ),
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
  GAP := ">=4.7",
  NeededOtherPackages := [[ "Alnuth", ">=3.0" ]],
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
