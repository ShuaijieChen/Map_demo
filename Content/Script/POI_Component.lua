--
-- DESCRIPTION: Displays the object's icon on the minimap
--
-- @COMPANY **
-- @AUTHOR Shuaijie Chen
-- @DATE 2023/06/15
--

---@type PointofInterest_Component_C
local M = UnLua.Class()
local Screen = require "Screen"
-- function M:Initialize(Initializer)
-- end

local function run(self)
    local __widgets = UE.TArray(UE.UUserWidget)
    --Delay adding the object's icon to the minimap after 0.2 seconds to avoid accessing the minimap before it is created
    UE.UKismetSystemLibrary.Delay(self,0.2)
    UE.UWidgetBlueprintLibrary.GetAllWidgetsOfClass(self:GetWorld(),__widgets,UE.UClass.Load("/Game/MiniMap/WDG_hud.WDG_hud_C"),true)
    self.WDG_hud = __widgets:GetRef(1)
    self.MiniMap = self.WDG_hud.WDG_MiniMap
    self.MiniMap:AddPOI(self:GetOwner())
end

function M:ReceiveBeginPlay()
    coroutine.resume(coroutine.create(run),self)
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

return M
