--[[
    Using the Runge-Kutta (classical, rk4) method to solve an ODE.
    You can play with the initial values and the simulation step.
--]]

require('numextra')
local gp = require('gnuplot')

---
-- Simple system, that describes an uniformly accelerated motion.
function myode(y)
    local accel = y[1]
    local speed = y[2]
    
    y[1] = 0     -- constant acceleration
    y[2] = accel
    y[3] = speed
end

-- *initial values*
--
-- aceleration of 0.1 m/s²
-- speed of 1 m/s
-- position 0 m
local values = {0.2, 1, 10} -- updated inplace
local sim = num.rk4(myode, 3, values)
 -- sim is now a function that simulates one step.
 
local sim_step = 5e-1   -- step of 0.5 s
local sim_time = 10     -- simulate for 10 seconds
local n_steps  = sim_time / sim_step
local t, p     = {0}, {values[3]} -- time and position pairs
 
for s = 1, n_steps do
    local v = sim(sim_step)
    t[#t+1] = s*sim_step
    p[#p+1] = v[3]
end

-- plot the simulation
gp{
    xlabel = 'Time [s]',
    ylabel = 'Position [m]',
    grid   = 'back',
    
    data = {
        gp.array {
            {
                t,
                p,
            },
            with = 'linespoints',
        }
    }
}:plot('.wxt')

