--[[
    Using num.fmin to minimize the Rosenbrock function.
--]]

require('numextra')

-- Minimum at x = {1,1}
function f(x)
    return (1-x[1])^2 + 100*(x[2] - x[1]^2)^2
end

local x, iters = num.fmin(f, { {-10,10}, {-10,10} })
print('Iterations: '     .. iters)
print(string.format('Solution: x1 = %f, x2 = %f)', x[1], x[2]))
