local alpha = require('alpha.themes.startify')
local logo = {
    '   _               _       ',
    ' _| |___ ___ _ _ _| |_ _ _ ',
    '| . |  _| .\'| | | | . | | |',
    '|___|_| |__,|_____|___|___|',
}

alpha.section.header.val = logo
require('alpha').setup(alpha.config)

