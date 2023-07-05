--
-- DESCRIPTION: Bigmap logic: player icon and POI
--
-- @COMPANY **
-- @AUTHOR Shuaijie Chen
-- @DATE 2023/06/20
--

---@type WDG_BigMap_C
local M = UnLua.Class()
local playericon_class
local playericon_root
local Screen=require("Screen")
local POI_class
local POI_root


--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:AddPOIinBigmap(Owner)
    --create POI and add to overlay of bigmap
    self.IsStatic = Owner:GetComponentByClass(UE.UClass.Load("/Game/MiniMap/POI_Component.POI_Component_C"))
    POI_class = UE.UClass.Load("/Game/MiniMap/WDG_POIinBigmap.WDG_POIinBigmap_C")
    POI_root = NewObject(POI_class)
    POI_root.IsStatic = self.IsStatic
    POI_root.Owner = Owner
    self.overlaychild = self.BigMapOverlay:AddChildToOverlay(POI_root)
    self.overlaychild:SetHorizontalAlignment(2)--center
    self.overlaychild:SetVerticalAlignment(2)--center
end

function M:UpdatePlayerIcon()
    --Get the player's position in the world scene, after calculation, get the player's position on the big map
    self.character = UE.UGameplayStatics.GetPlayerCharacter(self:GetWorld(), 0)
    self.character_x = self.character:K2_GetActorLocation().X /5000 * -1000
    self.character_y = self.character:K2_GetActorLocation().Y / 5000 * 1000
    self.PlayerLocation.X = self.character_y
    self.PlayerLocation.Y = self.character_x
    playericon_root:SetRenderTranslation(self.PlayerLocation)
    --Gets the player's orientation in the world scene as the player's orientation on the large map
    self.character = UE.UGameplayStatics.GetPlayerCharacter(self:GetWorld(), 0)
    self.character_yaw = self.character:K2_GetActorRotation().Yaw
    playericon_root:SetRenderTransformAngle(self.character_yaw)
end

function M:UpdateMapImage(NewMap)
    --Update big map
    self.BigMapInstance = self.BigMap:GetDynamicMaterial()
    self.BigMapInstance:SetTextureParameterValue("None", NewMap)
end

function M:Construct()
    --Add the player to the big map when it is created
    playericon_class = UE.UClass.Load("/Game/MiniMap/WDG_PlayerIcon.WDG_PlayerIcon_C")
    playericon_root = NewObject(playericon_class)
    POI_class = UE.UClass.Load("/Game/MiniMap/WDG_POI.WDG_POI_C")
    POI_root = NewObject(POI_class)
    self.overlaychild = self.BigMapOverlay:AddChildToOverlay(playericon_root)
    self.overlaychild:SetHorizontalAlignment(2)--center
    self.overlaychild:SetVerticalAlignment(2)--center
    self.ExitButton.OnClicked:Add(self, self.Exit)
end

function M:Exit()
    -- Click "Exit" to exit
    -- Set bigmap visibility to "Hidden"
    self:SetVisibility(2) --hidden
    local __widgets = UE.TArray(UE.UUserWidget)
    UE.UWidgetBlueprintLibrary.GetAllWidgetsOfClass(self:GetWorld(),__widgets,UE.UClass.Load("/Game/MiniMap/WDG_hud.WDG_hud_C"),true)
    self.WDG_hud = __widgets:GetRef(1)
    -- After the bigmap exits, set the small map visibility to "visible"
    self.WDG_hud.WDG_MiniMap:SetVisibility(0)
    local PlayerController = UE.UGameplayStatics.GetPlayerController(self:GetWorld(),0)
    PlayerController.bShowMouseCursor = false
    PlayerController.InputYawScale = 1.0
    PlayerController.InputPitchScale = -1.0
    local __actors = UE.TArray(UE.AActor)
    UE.UGameplayStatics.GetAllActorsOfClass(self:GetWorld(), UE.UClass.Load("/Game/ThirdPersonCPP/Blueprints/ThirdPersonCharacter.ThirdPersonCharacter_C"), __actors)
    if __actors:Length() ~= 1 then
        -- This should report error.
        --Screen.Print("__actors.length() != 1")
        
    else
        --Screen.Print("OK")
        self.MyThirdPerson = __actors:GetRef(1)
        self.MyThirdPerson.BigMapOpen = false
    end
end

function M:Tick(MyGeometry, InDeltaTime)
    self:UpdatePlayerIcon() -- Update the player's position on the bigmap in real time
    self.character = UE.UGameplayStatics.GetPlayerCharacter(self:GetWorld(), 0)
    if self.character.BigMapOpen == true then
        -- The minimap visibility is set to "hidden" when the bigmap is opened
        local __widgets = UE.TArray(UE.UUserWidget)
        UE.UWidgetBlueprintLibrary.GetAllWidgetsOfClass(self:GetWorld(),__widgets,UE.UClass.Load("/Game/MiniMap/WDG_hud.WDG_hud_C"),true)
        self.hud = __widgets:GetRef(1)
        self.hud.WDG_MiniMap:SetVisibility(2) --Hide minimap
    else
        -- The minimap visibility is set to "hidden" when the bigmap is closed
        local __widgets = UE.TArray(UE.UUserWidget)
        UE.UWidgetBlueprintLibrary.GetAllWidgetsOfClass(self:GetWorld(),__widgets,UE.UClass.Load("/Game/MiniMap/WDG_hud.WDG_hud_C"),true)
        self.hud = __widgets:GetRef(1)
        self.hud.WDG_MiniMap:SetVisibility(0) --show minimap
    end

end

return M
