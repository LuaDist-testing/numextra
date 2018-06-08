local ematrix = {}

function ematrix.filter(X, cond)
    local idx = {}
    local qt  = 0
    local rows, cols = X:shape()
    
    for i = 1, rows do
        if cond(i) then
            table.insert(idx, i)
            qt = qt + 1
        end
    end
    
    local out = matrix(qt, cols)
    for i = 1, qt do
        out[i] = X[idx[i]]
    end
    
    return out
end

function ematrix.bsx(f, A, B)
    for i = 1, #A do
        f(A[i], B)
    end
    
    return A
end

-- functions to use with bsx
function ematrix.add(A, B) A:add(B,  1, true)    end
function ematrix.sub(A, B) A:add(B, -1, true)    end
function ematrix.mul(A, B) A:mul(B, true)        end
function ematrix.div(A, B) A:div(B, false, true) end

function ematrix.reorder(X, order, col)
    if col then X = X:t() end
    local new = matrix(#order, X:size(2) )
    for i = 1, #order do new[i] = X[order[i]] end
    return col and new:t() or new
end

local function equalrow(X, Y, eps)
    for i = 1, #X do
        if math.abs(X[i] - Y[i]) > eps then
            return false
        end
    end
    return true
end

function ematrix.equal(X, Y, eps)
    local r1, c1 = X:shape()
    local r2, c2 = Y:shape()
    eps    = eps or 0
    
    -- A [n x 1] matrix could be equal to a [n] column vector
    if c1 == 1 then X = X:col(1); c1 = nil end
    if c2 == 1 then Y = Y:col(1); c2 = nil end
    if r1 ~= r2 or c1 ~= c2 then return false end
    
    -- two column vectors
    if not c1 then return equalrow(X, Y, eps) end
    
    -- two matrices
    for i = 1, #X do
        if not equalrow(X[i], Y[i], eps) then
            return false
        end
    end
    
    return true
end

local function split_str(str, pattern)
    local tbl = {}
    str:gsub(pattern, function(f) tbl[#tbl+1] = tonumber(f) end)
    return tbl
end

function ematrix.load_sep(path, sep)
    local f       = assert(io.open(path))
    local list    = {}
    local n, m    = 0, 0
    local pattern = ("([^%s]+)"):format(sep or ',')
    
    while true do
        local line = f:read('*l')
        if not line then break end
        list[#list+1] = split_str(line, pattern)
    end
    
    f:close()
    return matrix{list}
end

function ematrix.contains(X, val, eps)
    eps = eps or 0
    
    for i = 1, #X do
        if math.abs(X[i]-val) <= eps then return true end
    end
    return false
end

function ematrix.unique(v)
    assert(v:size'#' == 1)
    local set, vals = {}, {}
    local n   = 0
    
    for i = 1, #v do
        if not set[v[i]] then
            set[v[i]]     = true
            vals[#vals+1] = v[i]
            n = n + 1
        end
    end
    
    return matrix(vals)
end

return ematrix
