require "math"
-- ========== Settings ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.4)
Settings:setScanInterval(1)

dialogInit()
addCheckBox("mustSellRunes", "Vender as runas:", false)
newRow()
addCheckBox("debugMode", "Modo debug:", false)
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
riftResult = Pattern("riftResult.png"):similar(0.6)
repeatButton = Pattern("smallFlash.png")
sellButton = Pattern("sell.en.png")
getButton = Pattern("get.en.png")
okButtonScenario = Pattern("ok.en.png")
okButtonRifts = Pattern("okRifts.png")
-- ==========  regions ===========

fullScreen = Region(0,0,1920,1080)
diamondRegion = Region(1540,500,200,200)
riftResultRegion = Region(100,500,300,100)
replayRegion = Region(580, 540, 300, 200)
leftSide = Region(0,0,960,1080)
rightSide = Region(960,0,960,1080)
okButtonRegion = Region(900, 850, 300, 230)
getButtonRegion = Region(1050, 850, 300, 230)
 
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

scenarioRoutine = function()
  count = 0;
  while(count < repetitions)
  do
      count = count + 1;
      highlightRegion(diamondRegion)
      click(scanPattern(victoryDiamond, 600, diamondRegion))
      wait(1)
      highlightRegion(rightSide)
      click(rightSide)
      wait(1)
      highlightRegion(okButtonRegion)
      local okButtonFound = okButtonRegion:exists(okButtonScenario)
      if okButtonFound then
        highlightRegion(okButtonRegion) 
        click(scanPattern(okButtonScenario, 3, okButtonRegion))
      elseif mustSellRunes == true then
        highlightRegion(leftSide)
        click(scanPattern(sellButton, 3, leftSide))
      else
        highlightRegion(getButtonRegion)
        click(scanPattern(getButton, 3, getButtonRegion))
      end
      wait(1)
      highlightRegion(replayRegion)
      click(scanPattern(repeatButton, 3, replayRegion))
  end
end

riftsRoutine = function()
  count = 0;
  while(count < repetitions)
  do
      count = count + 1;
      highlightRegion(riftResultRegion)
      local victoryConditionfound = scanPattern(riftResult, 600, riftResultRegion)
      wait(5)
      click(victoryConditionfound)
      wait(2)
      highlightRegion(rightSide)
      click(rightSide)
      wait(2)
      highlightRegion(okButtonRegion)
      click(scanPattern(okButtonRifts, 3, okButtonRegion))
      wait(2)
      highlightRegion(replayRegion)
      click(scanPattern(repeatButton, 3, replayRegion))
  end
end

highlightRegion = function(region)
  if currentHighlightedRegion then
    currentHighlightedRegion:highlightOff()
  end
  if debugMode then
    region:highlight()
    currentHighlightedRegion = region
  end
end

-- ==========  main program ===========

if f_number == 1 then
  scenarioRoutine()
else
  riftsRoutine()
end
