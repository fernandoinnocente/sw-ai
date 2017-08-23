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
repeat3 = Pattern("require3.png")
repeat4 = Pattern("require4.png")
repeat5 = Pattern("require5.png")
sellButton = Pattern("sell.en.png")
getButton = Pattern("get.en.png")
okRegion = Region(350,400,200, 100)
okButton = Pattern("ok.en.png"):similar(0.4)
dialogButton = Pattern("sellButton.png")
leftSide = Region(0,0,480,540)
rightSide = Region(480,0,480,540)

-- ==========  main program ===========

while(true)
do
    local start = wait(startButton, 5)
    click(start)
    local victory = wait(victoryDiamond, 120)
    click(victory)
    local chest = wait(chestCenter, 5)
    click(chest)
    local ok = okRegion:exists(okButton, 3)
    if ok then click(ok)
    else
        if mustSellRunes == true then
            local sell = wait(sellButton, 3)
            click(sell)
        else
            local get = wait(getButton, 3)
            click(get)
        end
    end
    local repeatButton = leftSide:wait(repeat3, 3)
    click(repeatButton)
end
