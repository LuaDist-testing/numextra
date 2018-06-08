_module{
    name = 'stats',
    desc = "Statistical functions",
}

_function{
    name = 'mean',
    desc = "Computes the mean of the vector X",
    args = {"X"},
    ret  = {"Mean of the vector X"},
}

_function{
    name = 'cumsum',
    desc = "Computes the cumulative sum of vector X",
    args = {"X"},
    ret  = {"Vector of size #X with the cumulative sum of vector X"},
}

_function{
    name = 'meanm',
    desc = "Computes the mean of the matrix M",
    args = {"M"},
    ret  = {"vector where the i-th column contains the mean of the i-th column of M"},
}

_function{
    name = 'cov',
    desc = "Computes the covariance between vectors X and Y. Normalizes with #X-ddof",
    args = {"X","Y","ddof (default=1)"},
    ret  = {"Covariance between vectors X and Y"},
}

_function{
    name = 'var',
    desc = "Computes the variance of vector X. Normalizes with #X-ddof",
    args = {"X","ddof (default=1)"},
    ret  = {"Variance of vector X"},
}

_function{
    name = 'std',
    desc = "Computes the standard deviation of vector X. Normalizes with #X-ddof",
    args = {"X","ddof (default=1)"},
    ret  = {"Standard deviation of vector X"},
    see  = {"stats:examples:Standard deviation"},
}

_function{
    name = 'corr',
    desc = "Computes the correlation between vectors X and Y",
    args = {"X","Y"},
    ret  = {"Correlation between X and Y (scalar between -1 and 1)"},
}

_function{
    name = 'covm',
    desc = "Computes the covariance matrix (covariance between each pair of columns of matrix M). Normalizes with cols(M)-ddof",
    args = {"M","ddof (default=1)"},
    ret  = {"Covariance matrix"},
    see  = {"stats:functions:cov"},
}

_function{
    name = 'corrm',
    desc = "Computes the correlation matrix (correlation between each pair of columns of matrix M)",
    args = {"M"},
    ret  = {"Covariance matrix"},
    see  = {"stats:functions:corr"},
}

_function{
    name = 'zscore',
    desc = "Computes the standard score of each value in vector X in respect to itself",
    args = {"X"},
    ret  = {"Vector with the standard score (number of standard deviations from the mean) of each value in X"},
    see  = {"stats:functions:std"},
}

_function{
    name = 'zscorem',
    desc = "Computes the standard score of each value in each dimension (column) of matrix M in respect to itself",
    args = {"M"},
    ret  = {"Matrix where each column has been exchanged with its 'zscore'"},
    see  = {"stats:functions:zscore"},
}

_function{
    name = 'pca',
    desc = "Performs a principal component analysis on matrix M, where each column is a dimension and each row is a data 'point'",
    args = {"M"},
    ret  = {"vector s, matrix V, vector mu, where 's' is the variance contribution of each component, 'V' contains the components per se (one at each column), 'mu' is a vector with the mean of the original data. The vector s and matrix V are already ordered by their variance contributions"},
    see  = {"stats:functions:lda", "stats:functions:zscorem"}
}

_function{
    name = 'lda',
    desc = "Performs a linear discriminant analysis on matrix M (data 'points') and vector y (classes). Each column of matrix M is a dimension",
    args = {"M", 'y'},
    ret  = {"vector s, matrix V, vector mu, where 's' is the variance contribution of each component, 'V' contains the components per se (one at each column), 'mu' is a vector with the mean of the original data. The vector s and matrix V are already ordered by their variance contributions"},
}

_function{
    name = 'project',
    desc = "Projects the matrix X into the components V using the vector mu to shift the data to its original center",
    args = {"X","V","mu (optional)"},
    ret  = {"Project matrix"},
}

_function{
    name = 'reconstruct',
    desc = "Reconstructs a projected matrix back to its original axes",
    args = {"X","V","mu"},
    ret  = {"Reconstructed matrix"},
}

_example{
    name = 'Standard deviation',
    desc = 'Demonstrates the computation of the standard deviation of a vector',
    code = [[
> x = matrix{1,2,1,3,2,1}
> print( numextra.stats.std(x) ) -- default: sample standard deviation
0.81649658092773
>  print( numextra.stats.std(x, 0) ) -- 'whole population' standard deviation
0.74535599249993
]],
}
