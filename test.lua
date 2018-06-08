-- required libraries
require('lunatest')
require('numextra')

-- test suits
tol = 1e-6
lunatest.suite('tests.stat'  )
lunatest.suite('tests.matrix')
lunatest.suite('tests.num'   )

-- run
lunatest.run()
