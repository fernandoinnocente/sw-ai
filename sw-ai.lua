require "math"
-- ========== Settings ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)
Settings:set("MinSimilarity", 0.45)

dialogInit()
addCheckBox("mustSellRunes", "Vender as runas:", false)
newRow()
addCheckBox("mustRecharge", "Recarregar com cristais:", false)
newRow()
addTextView("Número de repetições")
addEditNumber("repetitions", "999")
dialogShow("Configurações")

-- ==========  patterns ===========

startButton = Pattern("flash.png")
victoryDiamond = Pattern("victoryDiamond.png"):similar(0.8)
repeatButton = Pattern("smallFlash.png")
buttonLeft = Pattern("buttonLeft.png")
buttonRight = Pattern("buttonRight.png")

-- ==========  regions ===========

startButtonRegion = Region(660, 340, 180, 80)
rewardButtonsRegionLeft = Region(250,400,190, 100)
rewardButtonsRegionRight = Region(440,400,190, 100)
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
count = 0;
while(count < repetitions)
do
    count = count + 1;
    click(scanPattern(startButton, 5, startButtonRegion))
    click(scanPattern(victoryDiamond, 120))
    wait(1)
    click(rightSide)
    wait(1)
    if mustSellRunes == true then
        click(scanPattern(buttonLeft, 3, leftSide))
    else
        click(scanPattern(buttonRight, 3, rightSide))
    end
    click(scanPattern(repeatButton, 3, leftSide))
end


