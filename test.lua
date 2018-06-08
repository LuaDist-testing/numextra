-- required libraries
require('lunatest')
require('numextra')

-- test suits
tol = 1e-6
lunatest.suite('tests.stats' )
lunatest.suite('tests.matrix')

-- run
lunatest.run()
