--
-- DESCRIPTION: Place an invisible button on the small map to open the bigmap by clicking on the minimap
--
-- @COMPANY **
-- @AUTHOR Shuaijie Chen
-- @DATE 2023/06/15

---@type WDG_hud_C
local M = UnLua.Class()
local Screen = require "Screen"

--function M:Initialize(Initializer)
--end


-- function M:ReceiveBeginPlay()
-- end

function M:Construct()
    self.ImageButton.OnClicked:Add(self, self.OnTappedT1)
end

function M:OnTappedT1()--Click the button to open the bigmap
    local __actors = UE.TArray(UE.AActor)
    UE.UGameplayStatics.GetAllActorsOfClass(self:GetWorld(), UE.UClass.Load("/Game/ThirdPersonCPP/Blueprints/ThirdPersonCharacter.ThirdPersonCharacter_C"), __actors)
    if __actors:Length() ~= 1 then
        -- This should report error.
        --Screen.Print("__actors.length() != 1")
        
    else
        --Screen.Print("OK")
        self.MyThirdPerson = __actors:GetRef(1)
    end
    --get BigMapOpen from ThridPersonCharacter, BigMapOpen is a bool that shows is big map in viewport now
    if self.MyThirdPerson.BigMapOpen == false then
        --if the big map in not in viewport, then create widget and add to viewport
        local widget_class = UE.UClass.Load("/Game/MiniMap/WDG_BigMap.WDG_BigMap_C")
        local widget_root = NewObject(widget_class, self)
        widget_root:AddToViewport()
        
        --set BigMapOpen true
        self.MyThirdPerson.BigMapOpen = true
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M
