#############################################################################
####
##
#W  Manipulations.gi          RADIROOT package                Andreas Distler
##
##  Installation file for the functions that do various manipulations
##  to special elements of a splitting field and to the permutations
##  in its Galois-group   
##
#H  @(#)$Id: Manipulations.gi,v 1.0 2004/08/21 14:38:01 gap Exp $
##
#Y  2004
##


#############################################################################
##
#F  RR_Produkt( <erw>, <elm>, <perm> )
##
##  Calculates the result for apllying the permutation <perm> to the
##  fieldelement <elm>
##
InstallGlobalFunction( RR_Produkt, function( erw, elm, perm )
    local i, k, mat, coeff, degprod, prod;

    mat := 0*One(erw.K);
    coeff := Coefficients( Basis(erw.K), elm );

    # unter Ausnutzung der Reihenfolge von Basiselementen rechnen
    for i in [ 1..Length(coeff) ] do
        if coeff[i] <> 0 then
	        # Einheitswurzel bleibt erhalten
	        # Size(elm)/Product(erw.degs) ist 1, wenn keine
	        # Einheitswurzel adjungiert wurde
	        prod := One( erw.K );
	        degprod := Length( coeff ) / Product( erw.degs );
	        # Jede in der Basis vorkommende Wurzel wird permutiert
	        for k in [ 1..Length(erw.degs) ] do
	            prod := prod * erw.roots[ k^perm ]^QuoInt(
                    RemInt( i-1, degprod * erw.degs[k] ), degprod );
	            degprod := degprod * erw.degs[k];
	        od;
	        mat := mat + coeff[i] * prod;
	    fi;    
    od;

    return mat;
end );


#############################################################################
##
#F  RR_Resolvent( <G>, <N>, <elm>, <erw> )
##
##  Computes the Lagrange-Resolvent for the element <elm> and a
##  generator of the factorgroup of <G> and <N>
##
InstallGlobalFunction( RR_Resolvent, function( G, N, elm, erw )
    local unity, gen, p;

    p := Order( G ) / Order( N );
    # Bestimme gen mit gen*N ist Erzeuger der Faktorgruppe G/N
    gen := First( Elements( G ), x -> not x in N );
    # p-te Einheitswurzel
    unity := erw.unity^( Order( erw.unity ) / p );

    return Sum([ 0..p-1 ], k -> unity^k * RR_Produkt( erw, elm, gen^k ) )/p;
end );


#############################################################################
##
#F  RR_CyclicElements( <erw>, <compser> )
##
##  It is <compser> a composition-series for the Galois-group of the
##  field in the record <erw>. The function returns a list of elements
##  that generate the corresponding tower of fields. Each element is
##  cyclic in the direct subfield.
##
InstallGlobalFunction( RR_CyclicElements, function( erw, compser )
    local i, k, elements, elm, primEllist, L, n;

    elements := [ ];
    L := FieldByMatrices( [ One( erw.K ) ] );
    for i in [ 2..Length(compser) ] do
        primEllist := List( Elements( compser[i] ),
	                    perm -> RR_Produkt( erw, erw.primEl, perm ) );
        for k in [ 1..Length( primEllist ) ] do
            elm := Sum( Combinations([ 1..Length(primEllist) ], k),
                                     subset -> Product( subset,
                                                        x -> primEllist[x]));
	        if not (elm in L) then break; fi;
        od;
        n := Order( compser[i-1] ) / Order( compser[i] );
        for k in [ 1..n ] do
            elements[i-1] := RR_Resolvent(compser[i-1],compser[i],elm^k,erw);
            if elements[i-1] <> 0 * One( erw.K ) then break; fi;
        od;
        if i <> Length(compser) then
            L := FieldByMatrices( List( [1..i-1], x -> elements[x] ) );
        fi;
    od;

    return elements;
end );


#############################################################################
##
#F  RR_IsInGalGrp( <erw>, <perm> )
##
##  Tests if the Permutation <perm> is in the Galois-group that
##  belongs to the roots in the record <erw>
##  
InstallGlobalFunction( RR_IsInGalGrp, function( erw, perm )
    local i;

    for i in [ 1..Length(erw.roots) ] do
        if RR_Produkt( erw, erw.roots[i], perm ) <> erw.roots[ i^perm ] then
            return false;
	    fi;
    od;

    return true;
end );


#############################################################################
##
#F  RR_ConstructGaloisGroup( <erw> )
##
##  Constructs the Galois-group for the roots in the record <erw> with
##  respect to their order; 
##
InstallGlobalFunction( RR_ConstructGaloisGroup, function( erw )
    local Sn, rt, perm, ggelm, ggord, p;

    ggelm := [ ];
    ggord := Product(erw.degs);
    Sn := SymmetricGroup( Length( erw.roots ) );
    rt := RightTransversal( Sn, Stabilizer( Sn, [ 1..Length(erw.degs) ], 
                                            OnTuples ) );
    for perm in rt do
        p := Permutation( perm, erw.roots, function( x, g ); 
                                               return RR_Produkt(erw, x, g);
                                           end );
        if p <> fail then Add( ggelm, p ); fi;
        if Order( Group( ggelm ) ) = ggord then break; fi;
    od;

    return Group( ggelm );
end );


#############################################################################
##
#F  RR_FindGaloisGroup( <erw>, <poly>, <galgrp> )
##
##  This function searchs the Galois-group of the rational polynomial
##  <poly> that is compatible to the numbering of the roots of <poly>
##  in <erw>; it's recommended to use RR_ConstructGaloisGroup if there
##  exist many groups conjugated to <galgrp> 
## 
InstallGlobalFunction( RR_FindGaloisGroup, function( erw, poly, galgrp )
    local G, H, perm, k, gens, newgens, Sn;

    k := 1;
    gens := [ ];
    Sn := SymmetricGroup( Degree(poly) );
    for G in ConjugacyClassSubgroups( Sn, galgrp ) do
        newgens := Filtered( GeneratorsOfGroup( G ),
                             gen -> RR_IsInGalGrp( erw, gen ) );
        gens := DuplicateFreeList( Concatenation( gens, newgens ) );
        H := Subgroup( Sn, gens );
        if Order(galgrp) = Order( H ) then
            return H;
        fi;
    od;
end );


#############################################################################
##
#E

