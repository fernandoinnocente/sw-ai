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
defetedDiamond = Pattern("defeatedDiamond.png"):similar(0.8)
repeatButton = Pattern("smallFlash.png")
repeatAfterDefeat = Pattern("flashDefeated.png")
dontReviveButton = Pattern("noButton.png")
buttonLeft = Pattern("buttonLeft.png")
buttonRight = Pattern("buttonRight.png")

-- ==========  regions ===========

startButtonRegion = Region(660, 340, 180, 80)
rewardButtonsRegionLeft = Region(270,370,130, 170)
rewardButtonsRegionRight = Region(470,370,130, 170)
leftSide = Region(0,0,480,540)
rightSide = Region(480,0,480,540)

-- ==========  functions ===========

scanPattern = function (pattern, time, region)
    if not region then region = Region(0,0,960,540) end
    if not pattern then return end
    if not time then time = 0 end
    local counter = -1
    local patternFound
    local pitch = (time > 10 and 5 or 1)
    while(counter < time)
    do
        patternFound = region:exists(pattern)
        if(patternFound) then break
        else
            wait(pitch)
            counter = counter + pitch
        end
    end
    return patternFound
end

isVictory = function()
    while(true) do
        local isVictory = rightSide:exists(victoryDiamond)
        if isVictory then
            return isVictory
        end
        local isDefeat = leftSide:exists(defetedDiamond)
        if isDefeat then
            return false
        end
        wait(5)
    end
end

collectReward = function()
    wait(1)
    click(rightSide)
    wait(1)
    if mustSellRunes == true then
        click(scanPattern(buttonLeft, 4, leftSide))
    else
        click(scanPattern(buttonRight, 4, rightSide))
    end
end

-- ==========  main loop ===========
count = 0;
while(count < repetitions)
do
    count = count + 1;
    click(scanPattern(startButton, 5, startButtonRegion))
    local victory = isVictory()
    if victory then
        click(victory)
        collectReward()
        click(scanPattern(repeatButton, 3, leftSide))
    else
        click(scanPattern(dontReviveButton, 5, rightSide))
        wait(1)
        click(leftSide)
        click(scanPattern(repeatAfterDefeat, 5, leftSide))
    end
end


