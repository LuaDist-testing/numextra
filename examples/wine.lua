--[[
    2D visualizations of the wine[1] dataset.
    [1] http://archive.ics.uci.edu/ml/machine-learning-databases/wine
    
    Should be run from the project's root dir.
--]]

-- import libraries
require('numextra')
local gp = require('gnuplot')

-- load the dataset
local data  = matrix.load_sep('examples/wine.data')
local y     = data:col(1)
local X     = stat.zscorem( data{{}, {2,} } )

-- project with both PCA and LDA
for _, algo in ipairs{"pca", "lda"} do
    local s, V, mu
    if algo == "pca" then
        s, V, mu = stat.pca(X)
    else
        s, V, mu = stat.lda(X, y)
    end
    
    local Xproj = stat.project(X, V{{},{1, 2}}, mu)

    -- plot
    local c1 = Xproj:filter(function(i) return y[i] == 1 end)
    local c2 = Xproj:filter(function(i) return y[i] == 2 end)
    local c3 = Xproj:filter(function(i) return y[i] == 3 end)

    gp{
        width = 600   , height = 500,
        grid  = "back", title = algo .. ' projection',
        data  = {
            gp.array{ { c1:col(1), c1:col(2) }, with = 'points' },
            gp.array{ { c2:col(1), c2:col(2) }, with = 'points' },
            gp.array{ { c3:col(1), c3:col(2) }, with = 'points' },
        }
    }:plot('wine_' .. algo .. '.png')
end
