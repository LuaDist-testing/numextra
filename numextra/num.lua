num = {}

-- finite difference: df/dx = ( f(x+eps)-f(x) ) / eps
local function diff(f, a, Xr, p, eps)
    local orig = a[p]
    
    local y1 = f(a, Xr)
    a[p] = a[p] + eps
    local y2 = f(a, Xr)
    a[p] = orig
    
    return (y2 - y1) / eps
end

-- computes the mean square error
local function mse(f, a, X, y)
    local acc = 0
    local n_rows = #X
    
    for r = 1, n_rows do
        local o   = f(a, X[r])
        local err = y[r] - o
        acc       = acc + err * err
    end
    
    return acc / n_rows
end


-- reflection, expansion, contraction and shrink
local amoeba_coefs = {1, 2, 0.5, 0.5}

-- Downhill simplex - Nelder and Mead, 1965 - minimization.
function num.fmin(func, range, iters, eps, coefs)
    -- preparation
    iters = iters or 1e3
    eps   = eps   or 1e-6
    coefs = coefs or amoeba_coefs
    local n    = #range
    local p    = n+1
    local eval = matrix(p) -- holds the evaluations
    local x0   = matrix(n) -- centroid, excluding the worst point
    local f_h, h, f_lm, l  -- holds the lowest and highest points
    
    -- generate the amoeba
    local x = matrix(p, n)
    x:apply(function(a, b) return rng.runif(range[b][1], range[b][2]) end)
    
    local it = 0
    while true do
        it = it + 1
        
        -- evaluate each point / solution
        for i = 1, p do eval[i] = func(x[i]) end
        
        -- select the highest (h) and lowest (l) points
        f_h, h = eval:max()
        f_l, l = eval:min()
        
        -- iteration limit reached
        if it > iters then break end
        
        -- compute the centroid
        x0:set(0)
        for i = 1, p do if i ~= h then
            x0:badd(x[i])
        end end
        x0:bdiv(p-1)
        
        local xp   = (1 + coefs[1])*x0 - coefs[1]*x[h]
        local f_xp = func(xp)
        
        -- if it is lower than the lowest
        if f_xp < f_l then          
            local xpp = (1 + coefs[2])*xp - coefs[2]*x0
            if func(xpp) < f_l then
                x[h] = xpp     -- expansion
            else
                x[h] = xp      -- reflection
            end
        else
            eval[h] = math.min -- trick
            local f_h2, h2 = eval:max()
            
            -- if the reflected solution is higher than all but the highest
            if f_xp > f_h2 then
                if f_xp < f_h then
                    x[h] = xp  -- reflection
                end
                
                xpp = coefs[3]*x[h] + (1 - coefs[3])*x0
                
                if func(xpp) > f_h then
                    -- multiple contraction
                    for i = 1, p do
                        x[i] = (x[i] + x[l])/2
                    end
                else
                    x[h] = xpp -- contraction
                end
            else
                x[h] = xp      -- reflection
            end
        end
    
        -- verify the convergence
        if math.sqrt(f_h - f_l) < eps then break end
    end
    
    return x[l], it
end

-- Levenberg-Marquardt for non-linear least squares fitting
function num.nlfit(f, a, X, y, n_iters, eps)
    -- default parameters
    n_iters = n_iters or 1e2
    eps     = eps     or 1e-9

    local u, v             = 0.1, 10
    local n_rows, n_params = #X, #a
    local J = matrix(n_rows, n_params)
    local E = matrix(n_rows, 1)
    local I = matrix.eye(n_params)
    
    local it = 0
    while it < n_iters do -- for every iteration
        it = it + 1
    
        -- compute the Jacobian matrix
        for r = 1, n_rows do
            local Xr, Jr = X[r], J[r]
            for p = 1, n_params do
                Jr[p] = diff(f, a, Xr, p, eps)
            end
            
            E[r][1] = y[r] - f(a, Xr)
        end
        
        -- compute the quasi-Hessian matrix
        local H     = J:t() * J
        local G     = J:t() * E
        local err_m = E:t() * E
        local l_err = err_m[1][1] / n_rows
        
        -- update the parameters
        local alast = a:copy()
        a:add(matrix.ls(H + I*u, G), 1, true)
        local n_err = mse(f, a, X, y)
        
        -- adjust the damping factor accordingly
        if n_err < l_err then
            u = u / v
            -- check for convergence
            if math.abs(l_err - n_err) < eps then break end
        else
            u = u * v
            a = alast
        end
    end
    
    return a, mse(f, a, X, y), it
end

-- Fourth-order Runge-Kutta
function num.rk4(odesys, order, values, aux)
    local k1, k2, k3, k4 = {}, {}, {}, {}
    return function(step)
        for i = 1, order do k1[i] = values[i] end
        odesys(k1, aux)
        
        for i = 1, order do k2[i] = 0.5*step*k1[i]+values[i] end
        odesys(k2, aux)
        
        for i = 1, order do k3[i] = 0.5*step*k2[i]+values[i] end
        odesys(k3, aux)
        
        for i = 1, order do k4[i] = step*k3[i]+values[i] end
        odesys(k4, aux)
        
        for i = 1, order do
            values[i] = values[i] + (step/6)*(k1[i] + 2*k2[i] + 2*k3[i] + k4[i])
        end
        
        return values
    end
end
