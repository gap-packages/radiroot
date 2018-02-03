LoadPackage("radiroot");
dirs := DirectoriesPackageLibrary( "radiroot", "tst" );
TestDirectory(dirs, rec(exitGAP := true, rewriteToFile:=true));
