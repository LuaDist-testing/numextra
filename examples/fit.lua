require('numextra')
local gp = require('gnuplot')

-- model
function poly(a, x)
    return a[1]*x^2 + a[2]*x + a[3]
end

-- data to fit (with noise)
local tx, ty    = {}, {}
local real_coef = {1, 0.5, 3.8}

for x = -10, 10 do
    local y = poly(real_coef, x) + 0.05 * math.random()
    table.insert(tx, x)
    table.insert(ty, y)
end

local initial = matrix{0.1, 0.1, 0.1}
local X = matrix(tx)
local y = matrix(ty)

-- fit
local a, mse, iters = num.nlfit(poly, initial, X, y)
print('MSE an iters: ', mse, iters)
print('\nSolution:\n')
print(a)

-- plot
gp{
    xlabel = 'x',
    ylabel = 'y',
    
    data = {
        gp.array{
            {
                tx,
                ty,
            },
            title = 'Original points',
            with  = 'points',
        },
        
        gp.func{
            function(x) return poly(a, x) end,
            title = 'Fitted polynomial',
            range = {-10, 10, 0.01},
        }
    }
}:plot('.wxt')
