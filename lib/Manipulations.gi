#############################################################################
####
##
#W  Manipulations.gi          RADIROOT package                Andreas Distler
##
##  Installation file for the functions that do various manipulations
##  to special elements of a splitting field and to the permutations
##  in its Galois group   
##
#H  $Id:$
##
#Y  2004
##


#############################################################################
##
#F  GaloisGroupOnRoots( <f> )
##
##  Computes the Galois group of the rational polynomial <f> with respect to
##  its roots, created as matrices
##
InstallGlobalFunction( GaloisGroupOnRoots, function( f )
    local erw, galgrp;
    
    erw := RR_Zerfaellungskoerper( f, rec( roots := [ ],
                                           degs := [ ],
                                           coeffs := [ ],
                                           K := FieldByMatrices([ [[ 1 ]] ]),
                                           H := Rationals ) );

    erw.unity := RR_RootOfUnity( erw, DegreeOverPrimeField(erw.K) );
    if IsInt(erw.unity) then 
        erw := RR_SplittField( f, erw.unity );
    fi;

    # get all roots, set a basis of the primitive element
    erw.roots := RR_Roots( [ [], erw.roots[1], erw.roots[2] ], erw );;
    Add( erw.roots, 
         -CoefficientsOfUnivariatePolynomial(f)[Degree(f)]*One(erw.K)
         -Sum( erw.roots ) );

    Info( InfoRadiroot, 1, "Construction of the Galoisgroup" );
    galgrp := RR_ConstructGaloisGroup( erw );
    galgrp!.roots := erw.roots;

    return galgrp;
end );


#############################################################################
##
#F  RR_CanonicalBasis( <primEl>, <n> )
##
##  Fast computation of the canonical basis with <n> elements, which consists
##  of the powers of the primitive element <primEl>
##
InstallGlobalFunction( RR_CanonicalBasis, function( primEl, n )
    local list, log, i, k;

    if n = 1 then return [ primEl ]; fi;
    list := [ primEl^0, primEl ];
    log := LogInt( n-1, 2 );
    for i in [ 0..log - 1 ] do
        for k in [ 1..2^i ] do
            list[ 2^i + k + 1 ] := list[ 2^i + 1 ] * list[ k + 1 ];
        od;
    od;
    for k in [ 1..(n - 1 - 2^log) ] do
        list[ 2^log + k + 1 ] := list[ 2^log + 1 ] * list[ k + 1 ];
    od;
 
    return list;
end );


#############################################################################
##
#F  RR_PrimElImg( <erw>, <perm> )
##
##  Calculates the result for apllying the permutation <perm> to the
##  primitive element of the field in the record <erw>
##
InstallGlobalFunction( RR_PrimElImg, function( erw, perm )

    # keine Einheitswurzel adjungiert
    if Length(erw.degs) = Length(erw.coeffs) then
        return Sum( [ 1..Length(erw.coeffs) ],
                    i -> erw.coeffs[i] * erw.roots[i^perm] );;
    # Einheitswurzel vorweg adjungiert
    else
        return Sum( [ 2..Length(erw.coeffs) ],
                    i -> erw.coeffs[i] * erw.roots[(i-1)^perm] ) +
               erw.coeffs[1] * erw.unity;;
    fi;
end );


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
	        degprod := Length( coeff ) / Product( erw.degs );
	        prod := erw.unity^RemInt( i-1, degprod );
                # One( erw.K );
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
#F  RR_CompositionSeries( <G>, <N> )
##
##  Computes a CompositionSeries of <G> through it's normal subgroup <N>
##  
InstallGlobalFunction( RR_CompositionSeries, function( G, N )
    local hom, genN, grps, gens;

    if G = N then
        return CompositionSeries( G ); 
    elif Order( G ) / Order( N ) in Primes then
        return Concatenation([ G ], CompositionSeries( N ));
    else
        Info( InfoRadiroot, 3, "        computation of Compositon Series" );
        hom := NaturalHomomorphismByNormalSubgroupNC( G, N );
        # Generators of Composition Series G/N as free group
        gens := List( CompositionSeries(Range(hom)), GeneratorsOfGroup );
        Unbind( gens[ Length( gens ) ] );
        # Preimages of the Generators in G
        gens := List(gens, ll->List(ll, x->PreImagesRepresentative(hom, x)));
        genN := GeneratorsOfGroup( N );
        grps := List( gens, x -> Group( Concatenation( genN, x )));
    fi;

    return Concatenation( grps, CompositionSeries( N ) );
end );


#############################################################################
##
#F  RR_Potfree( <rat>, <exp> )
##
##  Computes the smallest integer <rat> * q^<exp> with q in the rationals and
##  returns q
##  
InstallGlobalFunction( RR_Potfree, function( rat, exp )
    local num, den;

    num := Product( Collected( Factors( AbsInt( NumeratorRat( rat )))),
                    pe -> pe[1]^( exp * (QuoInt( pe[2], exp ) ) ) );
    den := Product( Collected( Factors( AbsInt( DenominatorRat( rat )))),
                    pe -> pe[1]^( exp * (QuoInt( pe[2], exp ) ) ) );

    return Root( num, exp ) / Root( den, exp );
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
    if IsInt( Order( erw.unity ) / p ) then
        unity := erw.unity^( Order( erw.unity ) / p );
    else
        unity := E( p ) * One( erw.K );
    fi;

    return Sum([ 0..p-1 ], k -> unity^k * RR_Produkt( erw, elm, gen^k ) )/p;
end );


#############################################################################
##
#F  RR_CyclicElements( <erw>, <compser> )
##
##  It is <compser> a composition series for the Galois group of the
##  field in the record <erw>. The function returns a list of elements
##  that generate the corresponding tower of fields. Each element is
##  cyclic in the direct subfield.
##
InstallGlobalFunction( RR_CyclicElements, function( erw, compser )
    local i, k, elements, elm, primEllist, L, n, potelm, primEl;

    if erw.H = Rationals then return [ ]; fi;
    elements := [ ];
    if Length(erw.degs) = Length(erw.coeffs) then
        L := FieldByMatricesNC( [ One( erw.K ) ] );
    else
        L := FieldByMatricesNC( [ erw.unity ] );
    fi;
    for i in [ 2..Length(compser)-1 ] do
        primEllist := List( AsList( compser[i] ),
	                    perm -> RR_PrimElImg( erw, perm ));;
        for k in Flat(List([ 1..Length(primEllist) ],
                           i -> [i, Length(primEllist) + 1 - i ])) do
            elm := Sum( Combinations( [ 1..Length(primEllist) ], k),
                        subset -> Product( subset, x -> primEllist[x]));;
            if not (elm in L) then 
                Info( InfoRadiroot, 2,
                      "    found element of field with degree ",
                      DegreeOverPrimeField( erw.K ) / Order( compser[i] ) );
                break;
            fi;
        od;
        n := Order( compser[i-1] ) / Order( compser[i] );
        for k in [ 1..n ] do
            elements[i-1]:=RR_Resolvent(compser[i-1],compser[i],elm^k,erw);
            if elements[i-1] <> 0 * One( erw.K ) then break; fi;
        od;
        potelm := elements[i-1]^n;;
        if IsDiagonalMat( potelm ) and IsRat( potelm[1][1] ) then
            elements[i-1] := elements[i-1] / RR_Potfree( potelm[1][1], n );
        fi;
        elements[i-1] := [elements[i-1], n];
        if i <> Length(compser)-1 then
          L := FieldByMatricesNC( Concatenation( GeneratorsOfField(L), 
                                                 [ elements[i-1][1] ]));
        fi;
    od;
    i := Length( compser );
    n := Order( compser[i-1] ) / Order( compser[i] );
    for k in [ 1..n ] do
        elements[i-1]:=RR_Resolvent(compser[i-1],compser[i],
                                    PrimitiveElement(erw.K)^k,erw);
        if elements[i-1] <> 0 * One( erw.K ) then break; fi;
    od;
    if i = 2 then
        potelm := elements[i-1]^n;
        if IsDiagonalMat( potelm ) and IsRat( potelm[1][1] ) then
            elements[i-1] := elements[i-1] / RR_Potfree( potelm[1][1], n );
        fi;
    fi;
    elements[i-1] := [elements[i-1], n];

    return elements;
end );


#############################################################################
##
#F  RR_IsInGalGrp( <erw>, <perm> )
##
##  Tests if the Permutation <perm> is in the Galois group that
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
##  Constructs the Galoisgroup for the roots in the record <erw> with
##  respect to their order 
##
InstallGlobalFunction( RR_ConstructGaloisGroup, function( erw )
    local Sn, rt, ggelm, p, B, imgs, oldgroup;

    ggelm := [ () ];
    oldgroup := [ ];
    if erw.H = Rationals then return Group( ggelm ); fi;
    Sn := SymmetricGroup( Length( erw.roots ) );
    rt := RightTransversal( Sn, Stabilizer( Sn, [ 1..Length(erw.degs) ], 
                                            OnTuples ) );
    imgs := List( rt, perm -> RR_PrimElImg( erw, perm ));;
    if IsDuplicateFreeList( imgs ) then
        Info( InfoRadiroot, 2, "    using fast Galoisgroup computation" );
        repeat
            # sort out already known permutations
            rt := Difference(rt,
                             List(Difference(AsList(Group(ggelm)),oldgroup),
                                  p -> First(rt,
                                             prm->ForAll([1..Length(erw.degs)],
                                                         i->i^prm = i^p))));;
            oldgroup := AsList(Group(ggelm));
            p := Permutation(rt[1], erw.roots, function(x, g) 
                                                 return RR_Produkt(erw, x, g);
                                               end );
            if p <> fail and Value( DefiningPolynomial(erw.K),
                                    RR_PrimElImg( erw, p )) = 0 * One(erw.K)
            then                
                Add( ggelm, p );
            else
                rt := rt{[ 2..Length(rt) ]};;
            fi;
        until Order(Group(ggelm)) = Product(erw.degs);
    else
        Info( InfoRadiroot, 2, "    using slow Galoisgroup computation" );
        imgs := DuplicateFreeList(imgs);
        erw.B := Basis( erw.K, RR_CanonicalBasis(PrimitiveElement(erw.K),
                                                 DegreeOverPrimeField(erw.K)));
        repeat
            imgs := Difference(imgs,
                               List(Difference(AsList(Group(ggelm)),oldgroup),
                                    p->RR_PrimElImg( erw, p )));;
            oldgroup := AsList(Group(ggelm));
            if Value(DefiningPolynomial(erw.K), imgs[1]) = 0 * One(erw.K) then
                B := Basis( erw.K, RR_CanonicalBasis(imgs[1], Size(imgs[1])));;
                p := Permutation( (), erw.roots,
                                  function( x, g )
                                      return LinearCombination( B,
                                          Coefficients( erw.B, x ));
                                  end );
                Add( ggelm, p );
            else
                imgs := imgs{[ 2..Length(imgs) ]};
            fi;
        until Order(Group(ggelm)) = DegreeOverPrimeField(erw.K);           
    fi;

    return Group( Difference( ggelm, [ () ] ));
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

