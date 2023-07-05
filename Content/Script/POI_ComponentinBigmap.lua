--
-- DESCRIPTION: Displays the object's icon on the bigmap
--
-- @COMPANY **
-- @AUTHOR Shuaijie Chen
-- @DATE 2023/06/20
--

---@type PointofInterest_Component_C
local M = UnLua.Class()

local function run(self)
    --Delay adding the object's icon to the minimap after 0.5 seconds to avoid accessing the bigmap before it is created
    UE.UKismetSystemLibrary.Delay(self,0.5)
    local __bigmap = UE.TArray(UE.UUserWidget)
    UE.UWidgetBlueprintLibrary.GetAllWidgetsOfClass(self:GetWorld(),__bigmap,UE.UClass.Load("/Game/MiniMap/WDG_BigMap.WDG_BigMap_C"),true)
    self.Bigmap = __bigmap:GetRef(1)
    self.Bigmap:AddPOIinBigmap(self:GetOwner())
end

-- function M:Initialize(Initializer)
-- end

function M:ReceiveBeginPlay()
    coroutine.resume(coroutine.create(run),self)
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

return M
