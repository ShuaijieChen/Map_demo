--
-- DESCRIPTION: create and add WDG_hub to viewport(provisional), then decide where to create the UI according to the actual situation
--
-- @COMPANY **
-- @AUTHOR Shuaijie Chen
-- @DATE 2023/06/15
--

---@type ThirdPersonExampleMap_C
local M = UnLua.Class()
local minimap_class
local minimap_root
local bigmap_class
local bigmap_root
local playericon_class
local playericon_root
local Screen = require "Screen"
-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

local function delayFunc(self,name)
    UE4.UKismetSystemLibrary.Delay(self, 0.2)  --Here we need at least 0.5 seconds to load minimap, or will get a nil value
    bigmap_class = UE.UClass.Load("/Game/MiniMap/WDG_BigMap.WDG_BigMap_C")
    bigmap_root = NewObject(bigmap_class, self)
    bigmap_root:AddToViewport()
    bigmap_root:SetVisibility(2)
end

function M:ReceiveBeginPlay()
    -- create minimap
    minimap_class = UE.UClass.Load("/Game/MiniMap/WDG_hud.WDG_hud_C")
    minimap_root = NewObject(minimap_class, self)
    minimap_root:AddToViewport()
    coroutine.resume(coroutine.create(delayFunc), self:GetWorld(), "A")
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
