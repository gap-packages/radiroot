#############################################################################
##
##  makedoc.g
##
##  Builds the package documentation with AutoDoc/GAPDoc.
##
#############################################################################

LoadPackage("AutoDoc");

# Run this from the package's root directory: gap makedoc.g
AutoDoc(rec(
    autodoc := rec(scan_dirs := []),
    gapdoc := rec(main := "main", files := []),
    extract_examples := true,
    scaffold := rec(
        includes := [
            "intro.xml",
            "radiroot.xml",
            "info.xml",
            "install.xml"
        ],
        entities := rec(
            Alnuth := "<Package>Alnuth</Package>",
            Radiroot := "<Package>Radiroot</Package>",
        ),
        bib := "manual.bib",
    ),
));

QuitGap();
