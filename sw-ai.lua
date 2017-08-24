require "math"
-- ========== Settings ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)
Settings:set("MinSimilarity", 0.45)

dialogInit()
addCheckBox("mustSellRunes", "Vender as runas:", false)
addCheckBox("mustRecharge", "Recarregar com cristais:", false)
dialogShow("Configurações")

-- ==========  patterns ===========

startButton = Pattern("flash.png")
victoryDiamond = Pattern("victoryDiamond.png"):similar(0.8)
chestCenter = Pattern("box.png")
repeatButton = Pattern("smallFlash.png")
sellButton = Pattern("sell.en.png")
getButton = Pattern("get.en.png")
okButton = Pattern("okButton.png")
dialogButton = Pattern("sellButton.png")

rewardButtonsRegion = Region(250,400,380, 100)
leftSide = Region(0,0,480,540)
rightSide = Region(480,0,480,540)

-- ==========  functions ===========

scanPattern = function (pattern, time, region)
    if not region then region = Region(0,0,960,540) end
    if not pattern then return end
    if not time then time = 0 end
    local counter = -1;
    local patternFound;
    while(counter < time)
    do
        patternFound = region:exists(pattern)
        if(patternFound) then break
        else
            wait(1)
            counter = counter + 1
        end
    end
    return patternFound
end

-- ==========  main loop ===========

while(true)
do
    click(scanPattern(startButton, 5))
    click(scanPattern(victoryDiamond, 120))
    wait(1)
    click(rightSide)
    local ok = scanPattern(okButton, 3, rewardButtonsRegion)
    if(ok) then
        click(ok)
    else
        if mustSellRunes == true then
            click(scanPattern(sellButton, 3, rewardButtonsRegion))
        else
            click(scanPattern(getButton, 3, rewardButtonsRegion))
        end
    end
    click(scanPattern(repeatButton, 3, leftSide))
end


