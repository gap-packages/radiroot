#############################################################################
####
##
#W  Strings.gi                RADIROOT package                Andreas Distler
##
##  Installation file for the functions that generate Tex-strings
##
#H  @(#)$Id: Strings.gi,v 1.0 2004/08/21 14:38:01 gap Exp $
##
#Y  2004
##


#############################################################################
##
#F  RR_Radikalbasis( <erw>, <elements> ) 
##
##  Produces a basis for the matrixfield in the record <erw> from the
##  generating matrices <elements> and returns a Tex-readable strings
##  for the basis as well 
##
InstallGlobalFunction( RR_Radikalbasis, function( erw, elements )
    local k, basis, elm, mat, i, ll, basstr, elmstr;

    basis := [ One( erw.K ) ];
    basstr := [""];
    for elm in elements do
        mat := List( basis, Flat );;
#    if SolutionMat( mat, Flat( elm ) ) = fail then    
        k := First( Primes,
                    i -> fail <> SolutionMat( mat, Flat(elm^i) ) );
        elmstr := RR_WurzelAlsString( k, SolutionMat( mat, Flat(elm^k) ), 
                                      basstr);
        basis := Concatenation( List( [1..k], i -> elm^(i-1) * basis ) );
        ll := [ basstr, List( basstr, str -> Concatenation( str, elmstr ))];
        for i in [ 3..k ] do
            ll[i] := List( basstr, str -> Concatenation( str,
                Concatenation( "{",elmstr,"}^", String(i-1) ) ) ); 
        od;
        basstr := Concatenation( ll );
#    fi;
    od;
#    basis := List( [1..Order(erw.unity)], i -> erw.unity^(i-1) );

    return [ basis, basstr ];
end );


#############################################################################
##
#F  RR_BruchAlsString( <bruch> ) 
##
##  Creates a Tex-readable String for the rational <bruch>
##
InstallGlobalFunction( RR_BruchAlsString, function( bruch )
    local str, num, den, sgn;

    if IsInt( bruch ) then
        str := String( AbsInt( bruch ) );
    else
        num := String( AbsInt( NumeratorRat( bruch ) ) );
        den := String( DenominatorRat( bruch ) );
        str := Concatenation("\\frac{", num, "}{", den, "}" );
    fi;
    if IsNegRat( bruch ) then str := Concatenation( " - ", str ); fi;

    return str;
end );


#############################################################################
##
#F  RR_KoeffizientAlsString( <coeff>, <anf> ) 
##
##  Creates a Tex-readable String for the cyclotomic <coeff>; if <anf>
##  is true, positive signs of rationals will be omitted; if <coeff> is a
##  sum, it will be included in brackets; finitely an empty string
##  will be returned, if <coeff> is equal to 1
##
InstallGlobalFunction( RR_KoeffizientAlsString, function( coeff, anf )
    local cstr;

    if coeff = 1 then
        cstr := "";
    else
        cstr := RR_ZahlAlsString( coeff );
        if not IsRat( coeff ) then
            cstr := Concatenation( "(",cstr,")" );
        fi;
    fi;
    if not anf then
        if IsPosRat( coeff ) then
            cstr := Concatenation( " + ", cstr );
        elif not IsRat( coeff ) then
            cstr := Concatenation( " + ", cstr );
        fi;
    fi;
    
    return cstr;
end );


#############################################################################
##
#F  RR_WurzelAlsString( <k>, <coeffs>, <basstr> ) 
##
##  Creates a Tex-readable String for the <k>-th root of the element
##  described by <coeffs> and <basstr>
##
InstallGlobalFunction( RR_WurzelAlsString, function( k, coeffs, basstr )
    local i, str, anf;

    str := ""; anf := true;
    for i in [ 1..Length(coeffs) ] do
        if coeffs[i] <> 0 then
            str := Concatenation( str,
                                  RR_KoeffizientAlsString( coeffs[i], anf ),
                                  basstr[i]);
            anf := false;
        fi;
    od;
    if k <> 1 then
        str := Concatenation( "\\sqrt[", String(k), "]{", str, "}" );
    fi;

    return str;
end );


#############################################################################
##
#F  RR_ZahlAlsString( <zahl> ) 
##
##  Creates a Tex-readable String for the cyclotomic <zahl>
##
InstallGlobalFunction( RR_ZahlAlsString, function( zahl )
    local bas, coeff;

    if IsRat( zahl ) then

        return RR_BruchAlsString( zahl );
    else
        bas := Basis( CF( Conductor( zahl ) ) );
        coeff := Coefficients( bas, zahl );

        return RR_WurzelAlsString( 1, coeff, List( bas, String ) ); 
    fi;    
end );


#############################################################################
##
#F  RR_NstinDatei( <coeffs>, <basstr> ) 
##
##  Creates a Tex-file containing a string for the element described by
##  <coeffs> and <basstr> 
##
InstallGlobalFunction( RR_NstInDatei, function( coeffs, basstr )
    local i, file, cstr, anf;

    anf := true;
    file := OutputTextFile( "~/NstinRadikaldarstellung.tex", false );
    SetPrintFormattingStatus( file, false );
    AppendTo( file, "\\documentclass[fleqn, a4paper]{article} \n",
                    "\\begin{document} \n",
                    "\\[ \n");
    for i in [ 1..Length(coeffs) ] do
        if coeffs[i] <> 0 then
            AppendTo( file, RR_KoeffizientAlsString( coeffs[i], anf ),
                      basstr[i], "\n");
            anf := false;
        fi;
    od;
    AppendTo( file, "\\] \n",
                    "\\end{document} \n" );
    CloseStream( file );
  
end );


#############################################################################
##
#E


