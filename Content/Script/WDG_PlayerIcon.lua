--
-- DESCRIPTION: Adds player icon to the minimap
--
-- @COMPANY **
-- @AUTHOR Shuaijie Chen
-- @DATE 2023/06/15
--

---@type WDG_PlayerIcon_C
local M = UnLua.Class()

--function M:Initialize(Initializer)
--end

function M:PreConstruct(IsDesignTime)
    --Draw the player icon image
    self.SlateBrush.ImageSize = UE.FVector2D(32.0,32.0)
    self.SlateBrush.Image = UE.UObject.Load("Texture2D'/Game/MiniMap/Icon.Icon'")
    self.SlateBrush.DrawAs = 3
end

-- function M:Construct()
-- end

function M:Tick(MyGeometry, InDeltaTime)
    --Gets the player orientation as the player icon orientation
    self.character = UE.UGameplayStatics.GetPlayerCharacter(self:GetWorld(), 0)
    self.character_yaw = self.character:K2_GetActorRotation().Yaw
    self.PlayerIcon:SetRenderTransformAngle(self.character_yaw)
    --Gets the player's field of view orientation as the field of view
    self.controller = UE.UGameplayStatics.GetPlayerController(self:GetWorld(),0)
    self.controller_yaw = self.controller:GetControlRotation().Yaw
    self.View:SetRenderTransformAngle(self.controller_yaw)
end

return M
