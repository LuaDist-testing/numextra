module(..., package.seeall)

local M = numextra.matrix
local filter   = M.filter
local reorder  = M.reorder
local equal    = M.equal
local unique   = M.unique
local contains = M.contains
local bsx      = M.bsx

function setup()
    X1    = matrix{1,2,3,4,5,6}
    X2    = matrix{4,5,6}
    X3    = matrix{5,3,1,4,2,6}
    X4    = matrix{1,2,3,4,5,6}
    X5    = matrix{4,5,6}
    X6    = matrix{4.01, 5.01, 6.01}
    X7    = matrix{ {4, 2, 3}, {5, 3, 4}, {6, 2, 1} }
    X7c   = X7:copy()
    X8    = matrix{ 1, 2, 3, 2, 1, 3, 2, 1, 2, 1, 2, 3 }
    X9    = matrix{ {3, 0, 0}, {4, 1, 1}, {5, 0, -2} }
    X123  = matrix{1, 2, 3}
end

function test_equal()
    assert_true  ( equal(X2, X5) )
    assert_true  ( equal(X5, X6, 0.01) )
    assert_false ( equal(X5, X6 ) )
    assert_true  ( equal(X1, X4) )
    assert_true  ( equal(X1:reshape(6,1), X4) )
    assert_true  ( equal(X1, X4:reshape(6,1)) )
    assert_true  ( equal(X1:reshape(6,1), X4:reshape(6,1)) )
    assert_true  ( equal(X1:reshape(3,2), X4:reshape(3,2)) )
    assert_true  ( equal(X1:reshape(2,3), X4:reshape(2,3)) )
    assert_false ( equal(X1:reshape(3,2), X4:reshape(2,3)) )
end

function test_filter()
    assert_true( equal(X2, filter(X1, function(a) return X1[a] > 3 end)) )
end

function test_reorder_row()
    local idx = X3:copy():sort(false, true)
    assert_true( equal(X4, reorder(X3, idx)) )
end

function test_reorder_col()
    local m = reorder(X7, matrix{3, 2, 1}, true)
    assert_true( equal( X2, m:col(3) ) )
end

function test_reoder_repl()
    local m = reorder(X7, matrix{1, 1, 3, 2, 2, 3})
    assert_true( equal(m[1], X7[1]) )
    assert_true( equal(m[2], X7[1]) )
    assert_true( equal(m[3], X7[3]) )
    assert_true( equal(m[4], X7[2]) )
    assert_true( equal(m[5], X7[2]) )
    assert_true( equal(m[6], X7[3]) )
end

function test_contains()
    assert_true ( contains(X1, 3) )
    assert_true ( contains(X1, 6) )
    assert_true ( contains(X1, 1) )
    assert_false( contains(X1, 0) )
    assert_false( contains(X1, 7) )
    assert_false( contains(X2, 2) )
    assert_false( contains(X2, 3) )
    assert_true ( contains(X2, 5) )
    assert_true ( contains(X2, 6) )
end

function test_unique()
    local u = unique(X8)
    assert_equal(3, #u)
    assert_true( contains(u, 1) )
    assert_true( contains(u, 2) )
    assert_true( contains(u, 3) )
end

function test_bsx()
    bsx(M.sub, X7, X123)
    assert_true ( equal(X7, X9 ) )
    assert_false( equal(X7, X7c) )
    bsx(M.add, X7, X123)
    assert_true( equal(X7, X7c) )
    bsx(M.mul, X7, 1)
    assert_true( equal(X7, X7c) )
    bsx(M.mul, X7, 0.4)
    assert_false( equal(X7, X7c, tol) )
    bsx(M.div, X7, 0.4)
    assert_true ( equal(X7, X7c, tol) )
    bsx(M.mul, X7, X2)
    assert_false( equal(X7, X7c, tol) )
    bsx(M.div, X7, X2)
    assert_true ( equal(X7, X7c, tol) )
end

function test_bsx_custom()
    bsx(function(a,b) a:add(b,-1,true) end, X7, X123)
    assert_true( equal(X7, X9) )
end
