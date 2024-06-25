local directory = g_currentModDirectory
local modName = g_currentModName

local vehicles = {}
local vehiclesByReplaceType = {}

local function validateVehicleTypes(typeManager)
    print(typeManager.typeName)
    if typeManager.typeName == "vehicle" then
        print("Lift/lower implement extention: start vehicleTypesValidation.")
        FrontBackControl.modName = modName

        for typeName, typeEntry in pairs(g_vehicleTypeManager:getTypes()) do 
            if SpecializationUtil.hasSpecialization(AttacherJoints, typeEntry.specializations) and 
                SpecializationUtil.hasSpecialization(Drivable, typeEntry.specializations) and 
                not SpecializationUtil.hasSpecialization(FrontBackControl, typeEntry.specializations) then
                    typeManager:addSpecialization(typeName, modName .. ".frontBackControl")
            end
        end
    end
end

local function init()
    print("Lift/lower implement extention: started mod.")
    TypeManager.validateTypes = Utils.prependedFunction(TypeManager.validateTypes, validateVehicleTypes)
end

init()