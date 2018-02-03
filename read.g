#############################################################################
##  
#W read.g                      RADIROOT package               Andreas Distler
##
## The read file for the RADIROOT package
##
#Y 2005
##

#############################################################################
##
#R radiroot global variables
##
DeclareInfoClass( "InfoRadiroot" );
SetInfoLevel( InfoRadiroot, 1 );

#############################################################################
##
#R read files
##
ReadPackage( "RADIROOT", "lib/Radicals.gi" );
ReadPackage( "RADIROOT", "lib/SplittField.gi" );
ReadPackage( "RADIROOT", "lib/Manipulations.gi" );
ReadPackage( "RADIROOT", "lib/Strings.gi" );
ReadPackage( "RADIROOT", "lib/Maple.gi" );

#############################################################################
##
#E
