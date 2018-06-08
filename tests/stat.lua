module(..., package.seeall)

local s           = stat
local mean, std   = s.mean , s.std
local meanm       = s.meanm
local corr, cov   = s.corr , s.cov
local corrm, covm = s.corrm, s.covm
local zscore      = s.zscore
local lda, pca    = s.lda, s.pca

function setup()
    X  = matrix{1,2,3,4,5}
    X2 = matrix{5,4,6,7,8}
    Y  = matrix{6,7,8,9,10}
    Y2 = Y * (-1)
    X3 = matrix{
        {-2.1, -1,  4.3},
        {3,  1.1,  0.12}
    }
    L1 = matrix{ {2, 50}, {3, 10}, {2, 40}, {3, 80}, {2, 30}, {3, 100}, {2, 20} }
    L2 = matrix{ 1, 2, 1, 2, 1, 2, 1 }
end

function test_mean()
    assert_equal( 3, mean(X ), tol )
    assert_equal( 6, mean(X2), tol )
    assert_equal( 8, mean(Y) , tol )
    assert_equal((4.3+0.12)/2, mean(X3:col(3)), tol )
end

function test_meanm()
    local m = meanm(X3)
    assert_equal( mean(X3:col(1)), m[1], tol )
    assert_equal( mean(X3:col(2)), m[2], tol )
    assert_equal( mean(X3:col(3)), m[3], tol )
end

function test_corr()
    assert_equal( 1, corr(X, Y    ), tol )
    assert_equal( 1, corr(X, Y,  0), tol )
    assert_equal(-1, corr(X, Y2   ), tol )
    assert_equal(-1, corr(X, Y2, 0), tol)
    
    assert_gt(0, corr(X2, Y,  0), 0)
    assert_lt(0, corr(X2, Y2, 0), 0)
    assert_gt(0, corr(X2, Y,  1), 0)
    assert_lt(0, corr(X2, Y2, 1), 0)
end

function test_corrm()
    local C = corrm(X3)
    assert_equal(C[1][1], corr(X3:col(1), X3:col(1) ), tol )
    assert_equal(C[1][2], corr(X3:col(1), X3:col(2) ), tol )
    assert_equal(C[2][1], corr(X3:col(2), X3:col(1) ), tol )
    assert_equal(C[2][2], corr(X3:col(2), X3:col(2) ), tol )
end

function test_covm()
    local C = covm(X3)
    assert_equal(C[1][1], cov(X3:col(1), X3:col(1) ), tol )
    assert_equal(C[1][2], cov(X3:col(1), X3:col(2) ), tol )
    assert_equal(C[2][1], cov(X3:col(2), X3:col(1) ), tol )
    assert_equal(C[2][2], cov(X3:col(2), X3:col(2) ), tol )
end

function test_zscore()
    local Z = zscore(Y)
    assert_equal( mean(Z), 0, tol )
    assert_equal( std(Z) , 1, tol )
end

function test_pca()
    local s, V, mu = pca(L1)
    local r, c = V:shape()
    assert_equal(r, 2)
    assert_equal(c, 2)
    assert_equal(2, #s)
    assert_true( (V[2][1] / V[1][1]) > 100 )
end

function test_lda()
    local s, V, mu = lda(L1, L2)
    local r, c = V:shape()
    assert_equal(r, 2)
    assert_equal(c, 2)
    assert_equal(2, #s)
    assert_true( (V[1][1] / V[2][1]) < 1 )
end
