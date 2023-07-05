--
-- DESCRIPTION 
-- First, Function M:UpdateIconinminimap is called in Tick() in order to update the boundary of the map (part) provided in the MiniMap. In this func, the angle between the player and the tagged item 
--will be calc-ed by calling the M:FindAngle function and its returned value will be stored to be used again in M:FindCoord. Finally, the function M:FindCoord will provide the distance between the player
--and the tagged item. Now, the tag can be correctly showed to the player 

-- @COMPANY **
-- @AUTHOR Shuaijie Chen
-- @DATE 2023/06/15
--

---@type WDG_POI_C
local M = UnLua.Class()
local Screen = require ("Screen")


function M:FindAngle(A, B)
    --calculate the distance between character and item based on the location of character and item
    self.x = A.X - B.X
    self.y = A.Y - B.Y
    return UE.UKismetMathLibrary.DegAtan2(self.y,self.x)
end

function M:FindCoord(Radius, Degrees)
    --use trig function to calculate the difference of x and y between character and item
    local cos = UE.UKismetMathLibrary.DegCos(Degrees)
    local sin = UE.UKismetMathLibrary.DegSin(Degrees)
    local x = Radius * cos
    local y = Radius * sin
    --use Fvector2D to store the difference between character and item
    self.Vector2D.X = x
    self.Vector2D.Y = y
    return self.Vector2D
end

function M:UpdateIconinminimap() --Calculate where the object should be frame by frame, mapped on the minimap
    local __widgets = UE.TArray(UE.UUserWidget)
    UE.UWidgetBlueprintLibrary.GetAllWidgetsOfClass(self:GetWorld(),__widgets,UE.UClass.Load("/Game/MiniMap/WDG_hud.WDG_hud_C"),true)
    self.WDG_hud = __widgets:GetRef(1)
    self.MiniMap = self.WDG_hud.WDG_MiniMap
    --Calculate the scale
    local zoom = self.MiniMap.Zoom
    local dimensions = self.MiniMap.Dimensions
    self.character = UE.UGameplayStatics.GetPlayerCharacter(self:GetWorld(), 0)
    --Gets player and object positions
    self.character_x = self.character:K2_GetActorLocation().X
    self.character_y = self.character:K2_GetActorLocation().Y
    self.owner_x = self.Owner:K2_GetActorLocation().X
    self.owner_y = self.Owner:K2_GetActorLocation().Y
    self.measuring_scale = zoom * dimensions / 300
    -- Screen.Print(string.format("%s",zoom * dimensions))
    --Calculate the position of the character on the minimap
    self.Vector2DinMinimap.X = (self.character_y - self.owner_y) / self.measuring_scale
    self.Vector2DinMinimap.Y = (self.character_x - self.owner_x) * -1 / self.measuring_scale
    self.Radius = UE.UKismetMathLibrary.VSize2D(self.Vector2DinMinimap)
    --In the FindAngle() function you need to pass (0,0), where you construct a FVector2D with a value of 0
    self.Vector2DA.X = 0
    self.Vector2DA.Y = 0
    self.Degrees = M:FindAngle(self.Vector2DA,self.Vector2DinMinimap)
    --NewVector stores the position of objects on the minimap
    self.NewVector = self:FindCoord(self.Radius, self.Degrees)
    -- Screen.Print(string.format("%s",self.NewVector))
    self:SetRenderTranslation(self.NewVector)
    --Sets whether objects disappear when they go beyond the edge of the minimap
    if self.IsStatic == true then
        --Do not perform any operation here. To prevent future problems, reserve this area
    else
        if UE.UKismetMathLibrary.VSize2D(self.NewVector) >= 130 then
            self.CustomImage:SetVisibility(2)
        else
            self.CustomImage:SetVisibility(0)
        end
    end
end

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    --Show Icon
    self.IconImage = self.Owner:GetComponentByClass(UE.UClass.Load("/Game/MiniMap/PointofInterest_Component.PointofInterest_Component_C")).IconImage
    if self.IconImage ~= nil then
        self.CustomImage:SetBrushFromTexture(self.IconImage,false)
        self.DefaultImage:SetVisibility(2)
    else
        self.CustomImage:SetVisibility(2)
    end
end

function M:Tick(MyGeometry, InDeltaTime)
    --Determine whether the object still exists, if not, remove the object's icon from the minimap
    if self.Owner ~= nil then
        --The icon position of objects on the bigmap is updated only when the map is opened
        self:UpdateIconinminimap()
    else
    end
end

return M
