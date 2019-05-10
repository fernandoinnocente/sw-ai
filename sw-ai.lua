require "math"
-- ========== Settings ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 1920)
Settings:set("MinSimilarity", 0.4)
Settings:setScanInterval(1)

dialogInit()
addCheckBox("mustSellRunes", "Vender as runas:", false)
newRow()
addCheckBox("mustRecharge", "Recarregar com cristais:", false)
newRow()
addTextView("Número de repetições")
addEditNumber("repetitions", "10")
newRow()
addTextView("Tipo de cenário")
addRadioGroup("f_number", 1)
addRadioButton("Dungeons / Cenários", 1)
addRadioButton("Rift Beasts", 2)
dialogShow("Configurações")

-- ==========  patterns ===========

startButton = Pattern("flash.png")
victoryDiamond = Pattern("victoryDiamond.png"):similar(0.8)
riftResult = Pattern("riftResult.png"):similar(0.8)
repeatButton = Pattern("smallFlash.png")
sellButton = Pattern("sell.en.png")
getButton = Pattern("get.en.png")
okButton = Pattern("ok.en.png"):similar(0.3)

-- ==========  regions ===========

fullScreen = Region(0,0,1920,1080)
diamondRegion = Region(1540,500,200,200)
riftResultRegion = Region(100,500,300,100)
replayRegion = Region(580, 540, 300, 200)
leftSide = Region(0,0,960,1080)
rightSide = Region(960,0,960,1080)
okButtonRegion = Region(900, 850, 300, 230)

-- ==========  functions ===========

scanPattern = function (pattern, time, region)
    if not region then region = fullScreen end
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

repeatProcedure = function(victoryPattern, region)
  count = 0;
  while(count < repetitions)
  do
      count = count + 1;
      click(scanPattern(victoryPattern, 180, region))
      wait(1)
      click(rightSide)
      wait(1)
      local okButtonFound = okButtonRegion:exists(okButton)
      if okButtonFound then 
        click(scanPattern(okButton, 3, okButtonRegion))
      elseif mustSellRunes == true then
        click(scanPattern(sellButton, 3, leftSide))
      else
        click(scanPattern(getButton, 3, rightSide))
      end
      wait(1)
      click(scanPattern(repeatButton, 3, replayRegion))
  end
end

-- ==========  main program ===========

if f_number == 1 then
  repeatProcedure(victoryDiamond, diamondRegion)
else
  repeatProcedure(riftResult, riftResultRegion)
end
