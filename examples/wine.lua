--[[
    2D visualizations of the wine[1] dataset.
    [1] http://archive.ics.uci.edu/ml/machine-learning-databases/wine
    
    Should be run from the project's root dir.
--]]

-- import the required functions
local ne = require('numextra')
local gp = require('gnuplot')

local load_sep = ne.matrix.load_sep
local filter   = ne.matrix.filter
local pca      = ne.stats.pca
local lda      = ne.stats.lda
local project  = ne.stats.project
local zscorem  = ne.stats.zscorem

-- load the dataset
local data  = load_csv('examples/wine.data')
local y     = data:col(1)
local X     = zscorem( data{{}, {2,} } )

-- project with both PCA and LDA
for _, algo in ipairs{"pca", "lda"} do
    local s, V, mu
    if algo == "pca" then
        s, V, mu = pca(X)
    else
        s, V, mu = lda(X, y)
    end
    
    local Xproj = project(X, V{{},{1, 2}}, mu)

    -- plot
    local c1 = filter(Xproj, function(i) return y[i] == 1 end)
    local c2 = filter(Xproj, function(i) return y[i] == 2 end)
    local c3 = filter(Xproj, function(i) return y[i] == 3 end)

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
