
while 1
    sinstim test
    setpriority normal
    close all
    if isabort
	break
    end
    wait(13e3)
end
