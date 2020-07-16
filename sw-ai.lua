require "math"
-- ========== Settings ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.4)
Settings:setScanInterval(1)

dialogInit()
addCheckBox("debugMode", "Modo debug:", false)
newRow()
addTextView("Número de repetições")
addEditNumber("repetitions", "10")
newRow()
addTextView("Tipo de cenário")
addRadioGroup("f_number", 1)
addRadioButton("Dungeons / Cenários", 1)
addRadioButton("Rift Beasts", 2)
addRadioButton("TOA", 3)
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

fullScreen = Region(0,0,2340,1080)
startRegion = Region(2100, 800, 150, 150)
diamondRegion = Region(2000,500,200,200)
riftResultRegion = Region(100,500,300,100)
replayRegion = Region(580, 540, 300, 200)
leftSide = Region(0,0,1170,1080)
rightSide = Region(1170,0,1170,1080)
okButtonRegion = Region(1150, 850, 800, 230)
 
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
      wait(3)
      highlightRegion(rightSide)
      click(rightSide)
      wait(1)
      highlightRegion(okButtonRegion)
      click(scanPattern(okButtonScenario, 3, okButtonRegion))
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

toaRoutine = function()
  count = 0;
  while(count < repetitions)
  do
      count = count + 1;
      highlightRegion(startRegion)
      click(startRegion))
      highlightRegion(diamondRegion)
      click(scanPattern(victoryDiamond, 600, diamondRegion))
      wait(3)
      highlightRegion(rightSide)
      click(rightSide)
      wait(1)
      highlightRegion(okButtonRegion)
      click(scanPattern(okButtonScenario, 3, okButtonRegion))
      wait(1)
      highlightRegion(replayRegion)
      click(scanPattern(repeatButton, 3, replayRegion))
      wait(3)
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
elseif f_number == 2 then
  riftsRoutine()
elseif f_number == 3 then
  toaRoutine()
end
