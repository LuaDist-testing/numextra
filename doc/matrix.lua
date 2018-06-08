_module{
    name = 'matrix',
    desc = "Functions that operate on matrices (some of then operates only in real matrices for now).",
}

_function{
    name = 'filter',
    desc = "Returns a new matrix with only the rows where cond(row_idx) is true",
    args = {"X","cond"},
    ret  = {"New matrix with the filtered elements of X"},
    see  = {"matrix:examples:Filter"},
}

_function{
    name = 'reorder',
    desc = "Returns a new matrix that is a 'reordering' of the rows of matrix X. This reordering can be arbitrary, so the new matrix can also contain less rows or more rows than the original one. The new order, or composition, is given by the vector order. If the parameter col is true, the columns are reordered instead",
    args = {"X","order","col"},
    ret  = {"A new matrix with the X rows (or columns) reordered"},
    see  = {"matrix:examples:Reorder"},
}

_function{
    name = 'equal',
    desc = "Checks if two real matrices are equal (element-wise, within eps, to handle floating point precision)",
    args = {"X", "Y", "eps (default=0)"},
    ret  = {"true if the matrices have the same elements (up to eps), false otherwise"},
}

_function{
    name = 'bsx',
    desc = "'Broadcast' function applier, like 'bsxfun' in octave. Calls f(A[i], B) for every row i in matrix A, where B is a vector. To be used with inplace functions (one can always pass a copy of A to prevent inplace modifications)",
    args = {"f","A","B"},
    ret  = {"Returns the modified matrix A"},
    see  = {"matrix:examples:Broadcast function applier"}
}

_function{
    name = 'add',
    desc = "Adds vector B to vector A inplace",
    args = {"A","B"},
    ret  = {},
}

_function{
    name = 'sub',
    desc = "Subtracts vector B from vector A inplace",
    args = {"A","B"},
    ret  = {},
}

_function{
    name = 'mul',
    desc = "Multiplies vector A by vector B, element-wise, inplace",
    args = {"A","B"},
    ret  = {},
}

_function{
    name = 'div',
    desc = "Divides vector A by vector B, element-wise, inplace",
    args = {"A","B"},
    ret  = {},
}

_function{
    name = 'load_sep',
    desc = "Loads a matrix from a text file, where each row is in a line and each value is separated by sep",
    args = {"path","sep (default=',')"},
    ret  = {"Constructed matrix"},
}

_function{
    name = 'contains',
    desc = "Verifies if vector X contains value val, up to a tolerance of eps",
    args = {"X","val", "eps (default=0)"},
    ret  = {"true if val is in vector X, false otherwise"},
}

_function{
    name = 'unique',
    desc = "Returns a vector containing only the unique values of vector v. Warning: the ordering will be undefined",
    args = {"v"},
    ret  = {"vector with the unique values in v (may not preserve the original order of appearance)"},
    see  = {"matrix:examples:Unique"}
}

_function{
    name = 'mpow',
    desc = "Returns the matrix X to the a-th power (exponentiation by squaring). 'a' must be >= 0.",
    args = {"X","a"},
    ret  = {"A new matrix that corresponds to X^a"},
    see  = {"matrix:examples:Power"},
}

_example{
    name = 'Broadcast function applier',
    desc = 'Demonstrates the usage of the bsx function',
    code = [[
>  A = matrix{ {1, 2}, {3, 4}, {5, 6} }
>  b = matrix{ {3, 3} }
>  matrix.bsx(matrix.badd, A, b)
>  print( A )
   4   5
   6   7
   8   9
]],
}

_example{
    name = 'Unique',
    desc = "Using the unique function",
    code = [[
>  x = matrix{1, 1, 2, 1, 3, 1, 2}
>  u = x:unique()
>  print( u )
   1   2   3
]],
}

_example{
    name = 'Reorder',
    desc = "Using the reorder function",
    code = [[
>  m = matrix{ {1,2}, {3,4}, {5,6}, {7,8} }
>  r = m:reorder{2,2,1}
>  print( r )
   3   4
   3   4
   1   2
]],
}

_example{
    name = 'Filter',
    desc = "Filtering values from a vector with the filter function",
    code = [[
>  x = matrix{2,1,3,5,7,6,8}
>  f = x:filter(function(i) return x[i] % 2 == 0 end)
>  print( f )
   2   6   8
]],
}

_example{
    name = 'Power',
    desc = "Usage of the function mpow to perform exponentiation by squaring",
    code = [[
>  X = matrix{{1,2},{3,4}}
>  print( X:mpow(0) )
   1   0
   0   1
>  print( X:mpow(5) )
   1069   1558
   2337   3406
>  X = matrix{{0.3,0.7},{0.6,0.4}}
>  print( X:mpow(9999999) )
   0.461538   0.538462
   0.461538   0.538462
]],
}
