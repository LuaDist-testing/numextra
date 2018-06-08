_project{
    name = 'Numeric Extra',
    desc = "A collection of complementary functions for Numeric Lua.",
    links = {
        Lua    = 'http://www.lua.org',
        numlua = "https://github.com/carvalho/numlua",
        OProj  = 'http://oproj.tuxfamily.org',
    },
}

require('doc.stat')
require('doc.matrix')
require('doc.num')
