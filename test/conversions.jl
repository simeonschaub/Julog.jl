# Test conversions ta various normal forms
@test to_nnf(@julog(true => not(and(not(!a), b, or(not(c), false))))) ==
    @julog(or(not(a), not(b), c))

@test to_cnf(@julog(and(and(or(a, and(b, or(c, d))), or(e, f)),
                        and(not(x), or(y, z))))) ==
    @julog(and(or(a, b), or(a, c, d), or(e, f), or(not(x)), or(y, z)))

@test to_cnf(@julog(true => not(and(not(!a), b, or(not(c), false))))) ==
    @julog(and(or(not(a), not(b), c)))

@test to_dnf(@julog(or(or(and(a, or(b, and(c, d))), and(e, f)),
                      or(not(x), and(y, z))))) ==
    @julog(or(and(a, b), and(a, c, d), and(e, f), and(not(x)), and(y, z)))

@test to_dnf(@julog(true => not(and(not(!a), b, or(not(c), false))))) ==
    @julog(or(and(not(a)), and(not(b)), and(c)))

# Test regularization of clause bodies
clauses = @julog [
    binary(X) <<= or(woman(X), man(X)) & not(nonbinary(X)),
    bigender(X) <<= and(woman(X), man(X)),
    nonbinary(X) <<= or(genderqueer(X), agender(X), thirdgender(X))
]

regularized = @julog [
    binary(X) <<= woman(X) & not(nonbinary(X)),
    binary(X) <<= man(X) & not(nonbinary(X)),
    bigender(X) <<= woman(X) & man(X),
    nonbinary(X) <<= genderqueer(X),
    nonbinary(X) <<= agender(X),
    nonbinary(X) <<= thirdgender(X)
]

@test regularize_clauses(clauses) == regularized