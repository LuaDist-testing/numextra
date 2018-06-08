_module{
    name = 'num',
    desc = "Numerical analysis functions",
}

_function{
    name = 'nlfit',
    desc = [[
Levenberg-Marquardt implementation to solve non-linear least squares fitting problems.
]],
    args = {
        "f(a,x): model function, receives the parameters 'a' and independent variables 'x' as input",
        "a: vector with the initial parameters. It is updated inplace.",
        "X: Matrix with the independend variables, one row per observation",
        "y: vector with the dependent data (desired values), one row per observation",
        "n_iters (default: 100): maximum number of iterations to be performed",
        "eps (default: 1e-9): tolerance for termination",
    },
    ret  = {"Fitted parameters", "Mean squared error", "Number of iterations performed"},
    see  = {"num:examples:Levenberg-Marquardt"},
}

_function{
    name = 'rk4',
    desc = [[Implementation of the classical Runge-Kutta method for a system of ODEs. Returns
a function that, when called with a step size, will compute that step returning the new
values.]],
    args = {
        "odesys: function that computes the derivatives at each step",
        "order: number of states / equations in the system of ODEs",
        "values: initial values (vector or Lua table)",
        "aux (optional): extra arguments that will be passed to function 'odesys'"},
    ret  = {"Function that can be used to iteratively solve a system of ODEs"},
    see  = {"num:examples:Runge-Kutta"},
}

_function{
    name = 'fmin',
    desc = [[Minimizes a scalar function, with one or more variables, by using the
Downhill Simplex method.]],
    args = {
        "func : function to be minimized, with f(x) signature, where x is a vector will all the independent variables.",
        "range: defines the initial search space (it is not used as a constraint during the execution of the algorithm). Should be 'table-like' with 'n' rows, where 'n' is the dimension of the search space. range[n][1] should be the lower limit, and range[n][2] the higher limit.",
        "iters (default: 1e3): maximum number of iterations to be performed.",
        "eps (default: 1e-6): tolerance for termination.",
    },
    ret  = {"Solution vector", "Number of iterations performed"},
    see  = {"num:examples:Function Minimization"}
}

_example{
    name = 'Levenberg-Marquardt',
    desc = 'Non-linear fitting (least squares) by using the Levenberg-Marquardt algorithm',
    code = [[
>  X = matrix{1,2,3,4,5}
>  y = 2*X^2 + 3*X + 5
>  poly = function(a, x) return a[1]*x^2 + a[2]*x + a[3] end
>  a, mse, iters = num.nlfit(poly, matrix{0.1, 0.1, 0.1}, X, y)
>  print(mse)
1.8508973999441e-23
>  print(a)
   2   3   5
]],
}

_example{
    name = 'Runge-Kutta',
    desc = "Using the Runge-Kutta method to solve a system of ODEs",
    code = [[
-- not in console mode; output not shown
function myode(y)
    local accel = y[1]
    local speed = y[2]
    
    y[1] = 0     -- constant acceleration
    y[2] = accel
    y[3] = speed
end

-- accel of 0.2m/s², initial speed of 1m/s, initial position of 10 m
sim     = num.rk4(myode, 3, {0.2, 1, 10})
step    = 1e-1   -- step of 0.1s
ttime   = 10     -- simulate for 10 s
n_steps = ttime / step
 
for i = 1, n_steps do
    local v = sim(step)
    print(i*step, v[3])
end
]],
}

_example{
    name = 'Function Minimization',
    desc = "Minimization of a function by using num.fmin.",
    code = [[
>  function f(x) return (1-x[1])^2 + 100*(x[2] - x[1]^2)^2 end
>  x, iters = num.fmin(f, { {-10,10}, {-10,10} })
>  print(x)
   1   1
>  print(iters)
66
]],
}
