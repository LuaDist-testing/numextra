local ematrix  = require('numextra.matrix')
local reorder  = ematrix.reorder
local unique   = ematrix.unique
local filter   = ematrix.filter
local bsx      = ematrix.bsx
local sub, add = ematrix.sub, ematrix.add

local stats = {}

function stats.mean(X)
    return X:sum() / #X
end

function stats.cumsum(X)
    local acc  = 0
    local Xout = matrix(#X)
    
    for i = 1, #X do
        acc     = acc + X[i]
        Xout[i] = acc
    end
    
    return Xout
end

function stats.meanm(M)
    local cols = M:size(2)
    local Mout = matrix.new(cols)
    
    for c = 1, cols do
        Mout[c] = stats.mean(M:col(c))
    end
    
    return Mout
end

function stats.cov(X, Y, ddof)
    assert(#X == #Y, "'x' and 'y' must have the same size")
    local mx, my = stats.mean(X), stats.mean(Y)
    local acc    = 0
    
    for i = 1, #X do
        acc = acc + (X[i] - mx) * (Y[i] - my)
    end
    
    return acc / (#X - (ddof or 1))
end

function stats.var(X, ddof)
    return stats.cov(X, X, ddof)
end

function stats.std(X, ddof)
    return math.sqrt( stats.var(X, ddof) )
end

function stats.corr(X, Y)
    return stats.cov(X,Y) / ( stats.std(X) * stats.std(Y))
end

function stats.covm(M, ddof)
    local dims = M:size(2)
    return matrix.new(dims, dims):apply(function(i,j)
        return stats.cov(M:col(i), M:col(j), ddof)
    end)
end

function stats.corrm(M)
    local dims = M:size(2)
    return matrix.new(dims, dims):apply(function(i,j)
        return stats.corr(M:col(i), M:col(j))
    end)
end

function stats.zscore(X)
    return (X - stats.mean(X)):div( stats.std(X), false, true )
end

function stats.zscorem(M)
    local rows, cols = M:shape()
    local O = matrix.new(rows, cols)
    
    for c = 1, cols do
        O:col(c):set( stats.zscore(M:col(c)) )
    end
    
    return O
end

local function eig_reorder(M)
    local s, V = M:eig()
    local o    = s:sort(true, true)
    V = reorder(V, o, true)
    return s, V
end

function stats.pca(M)
    local mu   = stats.meanm(M)
    M = bsx( sub, M:copy(), mu )
    local s, V = eig_reorder( stats.covm(M) )
    return s, V, mu
end

function stats.lda(X, y)
    local dims   = X:size(2)
    local labels = unique(y)
    local C      = #labels
    local Sw     = matrix.zeros(dims, dims)
    local Sb     = matrix.zeros(dims, dims)
    local mu     = stats.meanm(X)
    
    for i = 1, C do
        local Xi   = filter(X, function(p) return y[p] == labels[i] end)
        local mu_i = stats.meanm(Xi)
        bsx( sub, Xi, mu_i )
        add( Sw, Xi:t() * Xi() )
        sub( mu_i, mu )
        add( Sb, (mu_i:t() * #Xi) * mu_i)
    end
    
    local s, V = eig_reorder( matrix.ls(Sw, Sb) )
    return s, V, mu
end

function stats.project(X, V, mu)
    if mu then
        X = bsx(sub, X:copy(), mu)
    end
    
    return X * V
end

function stats.reconstruct(X, V, mu)
    local out = X*V:t()
    
    if mu then
        bsx(add, out, mu)
    end
    
    return out
end

return stats
