--
-- DESCRIPTION: Through scale, the position of objects in the world scene is mapped on bigmap
--
-- @COMPANY **
-- @AUTHOR Shuaijie Chen
-- @DATE 2023/06/20
--

---@type WDG_POIinBigmap_C
local M = UnLua.Class()
local Screen = require ("Screen")


function M:UpdateIconinbigmap()
    -- Use 5.3 as the scale for the time being
    self.x = self.Owner:K2_GetActorLocation().X
    self.y = self.Owner:K2_GetActorLocation().Y
    -- The xy axis in the world scene is the opposite of the xy axis in the big map
    self.Vector2DinBigmap.Y = self.x/-5.3
    self.Vector2DinBigmap.X = self.y/5.3
    self:SetRenderTranslation(self.Vector2DinBigmap)
end

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    --Show Icon
    self.IconImage = self.Owner:GetComponentByClass(UE.UClass.Load("/Game/MiniMap/POI_Component.POI_Component_C")).IconImage
    if self.IconImage ~= nil then
        self.CustomImage:SetBrushFromTexture(self.IconImage,false)
        self.DefaultImage:SetVisibility(2)
    else
        self.CustomImage:SetVisibility(2)
    end
end

function M:Tick(MyGeometry, InDeltaTime)
    self:UpdateIconinbigmap()
end

return M
