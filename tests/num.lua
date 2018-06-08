module(..., package.seeall)

local M  = num
local lm = M.lm

function setup()
    X1 = matrix{1,2,3,4,5,6,7,8,9}
    y1 = X1^2 + 3*X1 + 5                    -- {1, 3, 5}
    
    X2 = matrix{ {2,5}, {3,1}, {-2, 9}, {20, -3} }
    y2 = -3*X2:col(1) + 5*X2:col(2)         -- {-3, 5}
    
    X3 = matrix.linspace(0, 1, 30) 
    y3 = matrix.sin(2*math.pi*5*X3 + 6) - 4 -- {5, 6, -4}
end

-- one independent variable
function test_nlfit1()
    local function poly(a, x)
        return a[1]*x*x + a[2]*x + a[3]
    end
    
    local a, mse, it = num.nlfit(poly, matrix{0.1, 0.1, 0.1}, X1, y1)
    assert_true ( a:equal(matrix{1, 3, 5}, tol) )
    assert_equal( 0, mse, tol)
end

-- two independent variable
function test_nlfit2()
    local function mysum(a, x)
        return a[1]*x[1] + a[2]*x[2]
    end
    
    local a, mse, it = num.nlfit(mysum, matrix{0.1, 0.1}, X2, y2)
    assert_true ( a:equal(matrix{-3, 5}, tol) )
    assert_equal(0, mse, tol)
end

-- sine function
function test_nlfit3()
    local function mysin(a, x)
        return math.sin(2*math.pi*a[1]*x + a[2]) + a[3]
    end
    
    local a, mse, it = num.nlfit(mysin, matrix{4.5, 3, 1}, X3, y3)
    assert_equal( 5, a[1], tol)
    assert_equal(-4, a[3], tol)
    assert_equal( 0, mse , tol)
end

-- runge-kutta
function test_rk()
    local function ode(y)
        y[1], y[2], y[3] = 0, y[1], y[2]
    end

    local s1 = num.rk4(ode, 3, {0.2, 1, 10}) 
    local s2 = num.rk4(ode, 3, {0.2, 1, 10}) 
    local s3 = num.rk4(ode, 3, {0.2, 1, 10}) 
    
    local r1, r2, r3
    r1 = s1(1e1)
    for i = 1, 10   do r2 = s2(1e0)  end
    for i = 1, 1000 do r3 = s3(1e-2) end
    
    assert_equal(30, r1[3], tol)
    assert_equal(30, r2[3], tol)
    assert_equal(30, r3[3], tol)
end

function test_fmin()
    local function f(x)
        return (1-x[1])^2 + 100*(x[2] - x[1]^2)^2
    end

    local x, iters = num.fmin(f, { {-10,10}, {-10,10} }, 1e6, 1e-9)
    assert_true(x:equal(matrix{1,1}, tol))
end
