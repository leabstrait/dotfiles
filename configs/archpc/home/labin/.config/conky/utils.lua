-- Sample functions
function conky_F2C(f)
    local c = (5.0/9.0)*(f-32.0)
    return c
end

function conky_acpitempF()
    local c = conky_parse("${acpitemp}")
    return conky_C2F(c)
end

function conky_loadavg()
    return conky_parse("${loadavg 1}") * 100
end