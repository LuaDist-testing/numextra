--[[
    Adapted from http://www.bytefish.de/blog/pca_lda_with_gnu_octave/
--]]

local ne = require('numextra')
local gp = require('gnuplot')

local filter                = ne.matrix.filter
local meanm, pca            = ne.stats.meanm  , ne.stats.pca
local project, reconstruct  = ne.stats.project, ne.stats.reconstruct

-- data
local X = matrix{ {2, 3}, {3, 4}, {4, 5}, {5, 6}, {5, 7}, {2, 1}, {3, 2}, {4, 2}, {4, 3}, {6, 4}, {7, 6}}
local c = matrix{ 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2 }

-- X per class
local c1 = filter(X, function(i) return c[i] == 1 end)
local c2 = filter(X, function(i) return c[i] == 2 end)

-- initial plot
gp{
    title  = "Figure 1 - Points per class",
    grid   = "back",
    xrange = "[0 to 8]", yrange = "[0 to 8]",
    width  = 600       , height = 500,
    data   = {
        gp.array{ { c1:col(1), c1:col(2) },
            with  = 'p',
            width = 4
        },
        
        gp.array{ { c2:col(1), c2:col(2) },
            with  = 'p',
            width = 4
        },
    }
}:plot('fig1.png')

-- PCA
local s, V, mu = pca(X)

-- plotting with the components
local scale    = 5
gp{
    title  = "Figure 2 - With components",
    grid   = "back",
    xrange = "[0 to 8]", yrange = "[0 to 8]",
    width  = 600       , height = 500,
    data   = {
        gp.array{ { c1:col(1), c1:col(2) },
            with  = 'p',
            width = 4
        },
        gp.array{ { c2:col(1), c2:col(2) },
            with  = 'p',
            width = 4
        },
        gp.array{
            {
                {mu[1] - scale*V[1][1] , mu[1] + scale*V[1][1] },
                {mu[2] - scale*V[2][1] , mu[2] + scale*V[2][1] }
            }
        },
        gp.array{
            {
                {mu[1] - scale*V[1][2] , mu[1] + scale*V[1][2]},
                {mu[2] - scale*V[2][2] , mu[2] + scale*V[2][2]}
            }
        }
    }
}:plot('fig2.png')

-- projecting at each principal component
for comp = 1, 2 do
    local W  = V:col(comp):reshape(2,1)
    local X1 = reconstruct( project(X, W, mu), W, mu)

    -- X per class
    local p1 = filter(X1, function(i) return c[i] == 1 end)
    local p2 = filter(X1, function(i) return c[i] == 2 end)

    -- plotting with the projection
    gp{
        title  = "Figure " .. (2+comp) .. " - Projection",
        grid   = "back",
        xrange = "[0 to 8]", yrange = "[0 to 8]",
        width  = 600       , height = 500,
        data   = {
            gp.array{ { p1:col(1), p1:col(2) },
                with  = 'p',
                width = 4
            },
            gp.array{ { p2:col(1), p2:col(2) },
                with  = 'p',
                width = 4
            },
            gp.array{
                {
                    {mu[1] - scale*V[1][1] , mu[1] + scale*V[1][1] },
                    {mu[2] - scale*V[2][1] , mu[2] + scale*V[2][1] }
                }
            },
            gp.array{
                {
                    {mu[1] - scale*V[1][2] , mu[1] + scale*V[1][2]},
                    {mu[2] - scale*V[2][2] , mu[2] + scale*V[2][2]}
                }
            }
        }
    }:plot('fig' .. (2+comp) .. '.png')
end
