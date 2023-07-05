--
-- DESCRIPTION: Tentative use of blueprints
-- There is a problem with unlua calling the material parameter collection
--
-- @COMPANY **
-- @AUTHOR Shuaijie Chen
-- @DATE 2023/06/15
--

---@type WDG_MiniMap_C
local M = UnLua.Class()
local Screen = require "Screen"

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    --load MiniMap_Instance
    --self.MiniMapInstance = UE.UObject.Load("MaterialInstanceConstant'/Game/MiniMap/MiniMap_Instance.MiniMap_Instance'")
    self.MiniMapInstance = UE.UObject.Load("MaterialParameterCollection'/Game/MiniMap/MP_MIniMAp.MP_MiniMap'")
    --create a dynamic material instance for MiniMap_Instance
    --self.MID = UE.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self:GetWorld(), self.MiniMapInstance)
    --change scalar values in MP_MiniMap
    self.MiniMapInstance.ScalarParameters[4] = self.Dimensions
    self.MiniMapInstance.ScalarParameters[3] = self.Zoom
    --create dynamic material instance for image "Map"
    local MapInstance = self.Map:GetDynamicMaterial()
    MapInstance:SetTextureParameterValue("MapImage", self.Image)
    self:AddPlayerIcon()
end

function M:Tick(MyGeometry, InDeltaTime)
     --load MiniMap_Instance
     --self.MiniMapInstance = UE.UObject.Load("MaterialInstanceConstant'/Game/MiniMap/MiniMap_Instance.MiniMap_Instance'")
     --create a dynamic material instance for MiniMap_Instance
     --self.MID = UE.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self:GetWorld(), self.MiniMapInstance)
     --change scalar values in MP_MiniMap
    --  self.MiniMapInstance = UE.UObject.Load("/Game/MiniMap/MP_MiniMap.MP_MiniMap_C")
     self.character = UE.UGameplayStatics.GetPlayerCharacter(self:GetWorld(), 0)
     local character_x = self.character:K2_GetActorLocation().X
     local character_y = self.character:K2_GetActorLocation().Y
     --self.MID:SetScalarParameterValue("X", character_x)
     self.MiniMapInstance.ScalarParameters[1] = character_x
     --self.MID:SetScalarParameterValue("Y", character_y)
     self.MiniMapInstance.ScalarParameters[2] = character_y
     --self.MID:SetScalarParameterValue("Zoom", self.Zoom)
     self.MiniMapInstance.ScalarParameters[3] = self.zoom
    --  self.MiniMapInstance["X"] = character_x
    --  self.MiniMapInstance["Y"] = character_y
end

function M:AddPlayerIcon()
    --load WDG_PlayerIcon
    local WDG_PlayIcon = UE.UClass.Load("/Game/MiniMap/WDG_PlayerIcon.WDG_PlayerIcon_C")
    local widget_root = NewObject(WDG_PlayIcon, self)
    --add WDG_PlayerIcon to overlay
    self.MapOverlay:AddChildToOverlay(widget_root)
end

function M:UpdateMapImage()
    local MapInstance = self.Map:GetDynamicMaterial()
    MapInstance:SetTextureParameterValue("MapImage", self.Image)
end

return M
