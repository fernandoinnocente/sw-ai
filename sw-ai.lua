require "math"
-- ========== Settings ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.4)
Settings:setScanInterval(1)

dialogInit()
addCheckBox("debugMode", "Modo debug:", false)
addCheckBox("verifyAdditionalReward", "Verificar Reward adicional:", false)
newRow()
addTextView("Número de repetições")
addEditNumber("repetitions", "10")
newRow()
addTextView("Tipo de cenário")
addRadioGroup("f_number", 1)
addRadioButton("Dungeons / Cenários", 1)
addRadioButton("Rift Beasts", 2)
addRadioButton("TOA", 3)
addRadioButton("Dimensional Rift", 4)
dialogShow("Configurações")

-- ==========  patterns ===========

startButton = Pattern("flash.png")
victoryDiamond = Pattern("victoryDiamond.png"):similar(0.8)
defeatedDiamond = Pattern("defeatedDiamond.png"):similar(0.6)
riftResult = Pattern("riftResult.png"):similar(0.4)
repeatButton = Pattern("smallFlash.png")
sellButton = Pattern("sell.en.png")
getButton = Pattern("get.en.png")
okButtonScenario = Pattern("ok.en.png")
okButtonRifts = Pattern("okRifts.png")
-- ==========  regions ===========

fullScreen = Region(0,0,2340,1080)
startRegion = Region(2100, 800, 150, 150)
victoryDiamondRegion = Region(2000,500,200,200)
defeatedDiamondRegion = Region(800,670,200,200)
diamondDimensionalRegion = Region(1500,500,200,200)
riftResultRegion = Region(1050,100,600,200)
replayRegion = Region(580, 540, 300, 200)
leftSide = Region(0,0,1170,1080)
rightSide = Region(1170,0,1170,1080)
okButtonRegion = Region(1150, 850, 800, 230)
noButtonRegion = Region(1600, 700, 100, 100)
okAdditionalReward = Region(1150, 800, 250, 200)
 
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
	startFromBattleScreen = true;
	victory = 0
	defeat = 0
	while(count < repetitions)
	do
		
		if(startFromBattleScreen) then
			highlightRegion(startRegion)
			click(startRegion)
		else
			highlightRegion(replayRegion)
			click(scanPattern(repeatButton, 3, replayRegion))
		end

		count = count + 1;
		local cycleCount = 0;

		while(cycleCount < 100)
		do
			cycleCount = cycleCount + 1;
			highlightRegion(victoryDiamondRegion)
			local victoryConditionFound = scanPattern(victoryDiamond, 2, victoryDiamondRegion)
			if(victoryConditionFound) then 
				collectScenarioRewards()
				break
			else 
				highlightRegion(defeatedDiamondRegion)
				local defeatConditionFound = scanPattern(defeatedDiamond, 2, defeatedDiamondRegion)
				if(defeatConditionFound) then
					retryFromDefeat()
					break
				end
			end
		end
	end
end

collectScenarioRewards = function()
	wait(5)
	click(rightSide)
	wait(2)
	click(rightSide)
	wait(2)
	highlightRegion(okButtonRegion)
  click(scanPattern(okButtonScenario, 3, okButtonRegion))
  wait(2)
  collectAdditionalReward()
	startFromBattleScreen = false
	victory = victory + 1
end

collectAdditionalReward = function()
  if(verifyAdditionalReward) then
    highlightRegion(okAdditionalReward)
    local additionalRewardFound = scanPattern(okButtonScenario, 1, okAdditionalReward)
    if(additionalRewardFound) then
      click(additionalRewardFound)
      wait(2)
    end
  end
end

retryFromDefeat = function()
	highlightRegion(noButtonRegion)
	wait(2)
	click(noButtonRegion)
	highlightRegion(replayRegion)
	wait(2)
	click(replayRegion)
	wait(2)
	click(scanPattern(repeatButton, 3, replayRegion))
	wait(2)
	startFromBattleScreen = true
	defeat = defeat + 1
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
      collectAdditionalReward()
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
      click(startRegion)
      highlightRegion(diamondRegion)
      click(scanPattern(victoryDiamond, 600, diamondRegion))
      highlightRegion(rightSide)
      click(rightSide)
      wait(3)
      click(rightSide)
      wait(1)
      highlightRegion(okButtonRegion)
      click(scanPattern(okButtonScenario, 3, okButtonRegion))
      wait(1)
      collectAdditionalReward()
      highlightRegion(replayRegion)
      click(scanPattern(repeatButton, 3, replayRegion))
      wait(1)
  end
end

dimensionalRoutine = function()
  count = 0;
  highlightRegion(startRegion)
  click(startRegion)
  while(count < repetitions)
  do
      count = count + 1;
      highlightRegion(diamondDimensionalRegion)
      local victoryConditionFound = scanPattern(victoryDiamond, 600, diamondDimensionalRegion)
      wait(5)
      highlightRegion(victoryConditionFound)
      click(victoryConditionFound)
      wait(2)
      highlightRegion(rightSide)
      click(rightSide)
      wait(2)
      highlightRegion(okButtonRegion)
      click(scanPattern(okButtonScenario, 3, okButtonRegion))
      wait(2)
      collectAdditionalReward()
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

showReport = function()
	print ("Resultado da execução: ")
	print ("Total de tentativas: "..repetitions)
	print ("Total de vitorias: "..victory)
	print ("Total de derrotas: "..defeat)
	print ("Eficiência: "..victory / repetitions)
end

-- ==========  main program ===========

if f_number == 1 then
  scenarioRoutine()
  showReport()
elseif f_number == 2 then
  riftsRoutine()
elseif f_number == 3 then
  toaRoutine()
elseif f_number == 4 then
  dimensionalRoutine()
end