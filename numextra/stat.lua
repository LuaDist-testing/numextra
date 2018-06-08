local reorder  = matrix.reorder
local unique   = matrix.unique
local filter   = matrix.filter
local bsx      = matrix.bsx
local sub, add = matrix.bsub, matrix.badd

function stat.mean(X)
    return X:sum() / #X
end

function stat.cumsum(X)
    local acc  = 0
    local Xout = matrix(#X)
    
    for i = 1, #X do
        acc     = acc + X[i]
        Xout[i] = acc
    end
    
    return Xout
end

function stat.meanm(M)
    local cols = M:size(2)
    local Mout = matrix.new(cols)
    
    for c = 1, cols do
        Mout[c] = stat.mean(M:col(c))
    end
    
    return Mout
end

function stat.cov(X, Y, ddof)
    assert(#X == #Y, "'x' and 'y' must have the same size")
    local mx, my = stat.mean(X), stat.mean(Y)
    local acc    = 0
    
    for i = 1, #X do
        acc = acc + (X[i] - mx) * (Y[i] - my)
    end
    
    return acc / (#X - (ddof or 1))
end

function stat.var(X, ddof)
    return stat.cov(X, X, ddof)
end

function stat.std(X, ddof)
    return math.sqrt( stat.var(X, ddof) )
end

function stat.corr(X, Y)
    return stat.cov(X,Y) / ( stat.std(X) * stat.std(Y))
end

function stat.covm(M, ddof)
    local dims = M:size(2)
    return matrix.new(dims, dims):apply(function(i,j)
        return stat.cov(M:col(i), M:col(j), ddof)
    end)
end

function stat.corrm(M)
    local dims = M:size(2)
    return matrix.new(dims, dims):apply(function(i,j)
        return stat.corr(M:col(i), M:col(j))
    end)
end

function stat.zscore(X)
    return (X - stat.mean(X)):div( stat.std(X), false, true )
end

function stat.zscorem(M)
    local rows, cols = M:shape()
    local O = matrix.new(rows, cols)
    
    for c = 1, cols do
        O:col(c):set( stat.zscore(M:col(c)) )
    end
    
    return O
end

local function eig_reorder(M)
    local s, V = M:eig()
    local o    = s:sort(true, true)
    V = reorder(V, o, true)
    return s, V
end

function stat.pca(M)
    local mu   = stat.meanm(M)
    M = bsx( sub, M:copy(), mu )
    local s, V = eig_reorder( stat.covm(M) )
    return s, V, mu
end

function stat.lda(X, y)
    local dims   = X:size(2)
    local labels = unique(y)
    local C      = #labels
    local Sw     = matrix.zeros(dims, dims)
    local Sb     = matrix.zeros(dims, dims)
    local mu     = stat.meanm(X)
    
    for i = 1, C do
        local Xi   = filter(X, function(p) return y[p] == labels[i] end)
        local mu_i = stat.meanm(Xi)
        bsx( sub, Xi, mu_i )
        add( Sw, Xi:t() * Xi() )
        sub( mu_i, mu )
        add( Sb, (mu_i:t() * #Xi) * mu_i)
    end
    
    local s, V = eig_reorder( matrix.ls(Sw, Sb) )
    return s, V, mu
end

function stat.project(X, V, mu)
    if mu then
        X = bsx(sub, X:copy(), mu)
    end
    
    return X * V
end

function stat.reconstruct(X, V, mu)
    local out = X*V:t()
    
    if mu then
        bsx(add, out, mu)
    end
    
    return out
end
