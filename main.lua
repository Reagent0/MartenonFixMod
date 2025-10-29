print("MartenonFixMod loaded!\n")

local function LogLine(msg)
    print("[MartenonFixMod] ".. msg .. "\n")
end

-- =========================
-- LEVEL 4 PASSIVE HANDLING
-- =========================

local damagePassiveFired = false

---@param self RemoteUnrealParam<UBP_LU_Foretell_DealAOEDamagePerChargeOnTwilightSwitch_C>
function OnCharacterTurnStartDamage(self, ...)
    LogLine("OnCharacterTurnStartDamage called")

    damagePassiveFired = false
end

---@param self RemoteUnrealParam<UBP_LU_Foretell_DealAOEDamagePerChargeOnTwilightSwitch_C>
---@param chargeState RemoteUnrealParam<TMap<E_UniqueMechanic_Foretell_ChargeType, int32>>
function DamageSupernovaAOE(self, chargeState)
    if damagePassiveFired then
        LogLine("Damage passive already deployed, ignoring..")
        return
    end
    LogLine("Damage passive not fired, patching!")

    ---@class UAC_jRPG_BattleManager_C
    local battleManager = FindFirstOf("AC_jRPG_BattleManager_C")
    if not battleManager:IsValid() then
        LogLine("battleManager not valid")
        return
    end

    ---@class UFL_BattleHelpers_C
    local battleHelpers = StaticFindObject("/Game/Gameplay/Battle/FL_BattleHelpers.Default__FL_BattleHelpers_C")
    if not battleHelpers:IsValid() then
        LogLine("battleHelpers not valid")
        return
    end

    ---@class UDataTable
    local luminaDatatable = StaticFindObject("/Game/Gameplay/Battle/ScalingSystem/BalancingTables/Content/DT_Balancing_Luminas.DT_Balancing_Luminas")
    if not luminaDatatable:IsValid() then
        LogLine("luminaDatatable not valid")
        return
    end

    local damagePerCharge = luminaDatatable:FindRow("Foretell_DealAOEDamagePerChargeOnTwilightSwitch_DamagePerCharge")
    if not damagePerCharge then
        LogLine("damagePerCharge row not found")
        return
    end

    local finalDamage = damagePerCharge["FloatValue_3_9D7EBC84471861D83D95EC8FC8B0C998"] * chargeState:get():Find(3):get()

    battleManager.Enemies:ForEach(function(i, enemy_)
        ---@class ABP_jRPG_Character_Battle_Base_C
        local enemy = enemy_:get()

        local damageBuilder = battleHelpers:MakeDamageBuilder(
            enemy.AC_jRPG_CharacterStats,
            7,
            finalDamage,
            finalDamage,
            battleManager.CurrentCharacter.AC_jRPG_CharacterStats,
            6,
---@diagnostic disable-next-line: param-type-mismatch
            "Foretell_DealAOEDamagePerChargeOnTwilightSwitch",
            self:get()
        )

        local t = {}
---@diagnostic disable-next-line: param-type-mismatch
        damageBuilder:DealDamages(t, t)

        local loc1 = {}
        local loc2 = {}
        local loc3 = {}
        enemy:GetRootLocation(loc1, loc2, loc3)

        ---@class UBP_LU_Foretell_DealAOEDamagePerChargeOnTwilightSwitch_C
        local ctx = self:get()
        ctx:FX_ImpactLight(loc1)
    end)

    ---@class UFL_jRPG_CustomFunctionLibrary_C
    local funcLibrary = StaticFindObject("/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.Default__FL_jRPG_CustomFunctionLibrary_C")
    if not funcLibrary:IsValid() then
        LogLine("funcLibrary not valid")
        return
    end

    funcLibrary:NotifyLuminaPassiveEffectBuff(self:get(), self:get())
end

-- =========================
-- LEVEL 10 PASSIVE HANDLING
-- =========================

local foretellPassiveFired = false

---@param self RemoteUnrealParam<UBP_LU_Foretell_ApplyForetellPerChargeOnTwilightSwitch_C>
function OnCharacterTurnStartForetell(self, ...)
    LogLine("OnCharacterTurnStartForetell called")

    foretellPassiveFired = false
end

---@param self RemoteUnrealParam<UBP_LU_Foretell_ApplyForetellPerChargeOnTwilightSwitch_C>
---@param chargeState RemoteUnrealParam<TMap<E_UniqueMechanic_Foretell_ChargeType, int32>>
function ForetellSupernovaAOE(self, chargeState)
    if foretellPassiveFired then
        LogLine("Foretell passive already deployed, ignoring..")
        return
    end
    LogLine("Foretell passive not fired, patching!")

    ---@class UAC_jRPG_BattleManager_C
    local battleManager = FindFirstOf("AC_jRPG_BattleManager_C")
    if not battleManager:IsValid() then
        LogLine("battleManager not valid")
        return
    end

    ---@class UBP_UniqueMechanic_Foretell_Component_C
    local foretellComponent = FindFirstOf("BP_UniqueMechanic_Foretell_Component_C")
    if not foretellComponent:IsValid() then
        LogLine("foretellComponent not valid")
        return
    end

    ---@class UDataTable
    local luminaDatatable = StaticFindObject("/Game/Gameplay/Battle/ScalingSystem/BalancingTables/Content/DT_Balancing_Luminas.DT_Balancing_Luminas")
    if not luminaDatatable:IsValid() then
        LogLine("luminaDatatable not valid")
        return
    end

    local foretellPerCharge = luminaDatatable:FindRow("Foretell_ApplyForetellPerChargeOnTwilightSwitch_ForetellAmount")
    if not foretellPerCharge then
        LogLine("foretellPerCharge row not found")
        return
    end

    local finalForetellAmount = foretellPerCharge["FloatValue_3_9D7EBC84471861D83D95EC8FC8B0C998"] * chargeState:get():Find(3):get()

    battleManager.Enemies:ForEach(function(i, enemy)
        foretellComponent:ApplyForetell(enemy:get().AC_jRPG_CharacterStats, finalForetellAmount, 15, true)
    end)

    ---@class UFL_jRPG_CustomFunctionLibrary_C
    local funcLibrary = StaticFindObject("/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.Default__FL_jRPG_CustomFunctionLibrary_C")
    if not funcLibrary:IsValid() then
        LogLine("funcLibrary not valid")
        return
    end

    funcLibrary:NotifyLuminaPassiveEffectBuff(self:get(), self:get())
end

-- =========================
-- OTHER STUFF
-- =========================

---@param self RemoteUnrealParam<UFL_jRPG_CustomFunctionLibrary_C>
---@param buffInstance RemoteUnrealParam<UBP_BattleBuffInstance_C>
function NotifyLuminaPassiveEffectBuff(self, buffInstance, ...)
    local buffInstanceFName = buffInstance:get():GetFName():ToString()
    if string.find(buffInstanceFName, "BP_LU_Foretell_ApplyForetellPerChargeOnTwilightSwitch_C") then
        LogLine(string.format("Detected passive %s", buffInstanceFName))
        foretellPassiveFired = true
    end
    if string.find(buffInstanceFName, "BP_LU_Foretell_DealAOEDamagePerChargeOnTwilightSwitch_C") then
        LogLine(string.format("Detected passive %s", buffInstanceFName))
        damagePassiveFired = true
    end
end

-- =========================
-- INIT
-- =========================

local fn_battleStarted = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnAllBattleStartEventsTriggered"
local fn_foretellSupernovaAOE = "/Game/Gameplay/Lumina/Passives_Foretell/BP_LU_Foretell_ApplyForetellPerChargeOnTwilightSwitch.BP_LU_Foretell_ApplyForetellPerChargeOnTwilightSwitch_C:SupernovaAOE"
local fn_damageSupernovaAOE = "/Game/Gameplay/Lumina/Passives_Foretell/BP_LU_Foretell_DealAOEDamagePerChargeOnTwilightSwitch.BP_LU_Foretell_DealAOEDamagePerChargeOnTwilightSwitch_C:SupernovaAOE"
local fn_onCTurnStartForetell = "/Game/Gameplay/Lumina/Passives_Foretell/BP_LU_Foretell_ApplyForetellPerChargeOnTwilightSwitch.BP_LU_Foretell_ApplyForetellPerChargeOnTwilightSwitch_C:OnCharacterTurnStart"
local fn_onCTurnStartDamage = "/Game/Gameplay/Lumina/Passives_Foretell/BP_LU_Foretell_DealAOEDamagePerChargeOnTwilightSwitch.BP_LU_Foretell_DealAOEDamagePerChargeOnTwilightSwitch_C:OnCharacterTurnStart"
local fn_notifyLuminaPassive = "/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:NotifyLuminaPassiveEffectBuff"

local hooked = false
local preId, postId = -1, -1
preId, postId = RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    ExecuteWithDelay(2000, function()
        RegisterHook(fn_battleStarted, function()
            if not hooked then
                RegisterHook(fn_onCTurnStartDamage, OnCharacterTurnStartDamage)
                RegisterHook(fn_damageSupernovaAOE, DamageSupernovaAOE)
                RegisterHook(fn_onCTurnStartForetell, OnCharacterTurnStartForetell)
                RegisterHook(fn_foretellSupernovaAOE, ForetellSupernovaAOE)
                RegisterHook(fn_notifyLuminaPassive, NotifyLuminaPassiveEffectBuff)
                hooked = true
            end
        end)
        LogLine("Battle hook registered!")
    end)
    UnregisterHook("/Script/Engine.PlayerController:ClientRestart", preId, postId)
end)