FrontBackControl = {}

function FrontBackControl.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AttacherJoints, specializations)
end

function FrontBackControl.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents", FrontBackControl)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad", FrontBackControl)
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad", FrontBackControl)
end

function FrontBackControl.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "actionHandleLowering", FrontBackControl.actionHandleLowering)
end

function FrontBackControl:onLoad(savegame)
    local spec = self["spec_" .. FrontBackControl.modName .. ".FrontBackControl"]

    spec.frontJoints = {}

    spec.backJoints = {}


end

function FrontBackControl:onPostLoad(savegame)
    local spec = self["spec_" .. FrontBackControl.modName .. ".FrontBackControl"]
    local attacherJoints_spec  = self.spec_attacherJoints

    for attacherJointIndex, attacherJoint in pairs(attacherJoints_spec.attacherJoints) do
        if attacherJoint.comboTime ~= nil then
            if attacherJoint.comboTime <= 0.5 then
                print("Added " .. attacherJoint.jointTransform .. "to front")
                table.insert(spec.frontJoints, {jointIndex = attacherJointIndex})
            else
                print("Added " .. attacherJoint.jointTransform .. "to back")
                table.insert(spec.backJoints, {jointIndex = attacherJointIndex})
            end
        end
    end

end

function FrontBackControl:onRegisterActionEvents(isActionForInput, isActiveForInputIgnoreSelection)

    if self.isClient then
        local spec = self["spec_" .. FrontBackControl.modName .. ".FrontBackControl"]

        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            if not self:getIsAIActive() then
                local nonDrawActionEvents = {}
                local function insert(_, actionEventId)
                    table.insert(nonDrawActionEvents, actionEventId)
                end

                insert(self:addPoweredActionEvent(spec.actionEvents, InputAction.SFBC_TOGGLE_FRONT, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredActionEvent(spec.actionEvents, InputAction.SFBC_TOGGLE_BACK, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredActionEvent(spec.actionEvents, InputAction.SFBC_LIFT_FRONT, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredActionEvent(spec.actionEvents, InputAction.SFBC_LOWER_FRONT, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredActionEvent(spec.actionEvents, InputAction.SFBC_LIFT_BACK, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredActionEvent(spec.actionEvents, InputAction.SFBC_LOWER_BACK, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))

                for _, actionEventId in ipairs(nonDrawActionEvents) do
                    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
                    g_inputBinding:setActionEventTextVisibility(actionEventId, false)
                end
            end
        end
    end

end

function FrontBackControl.actionHandleLowering(self, actionName, inputValue, callbackState, isAnalog)
    print("action recieved name: " .. actionName)
    print("test inputAction: " .. InputAction.SFBC_TOGGLE_FRONT)
    local spec = self["spec_" .. FrontBackControl.modName .. ".FrontBackControl"]
    local attacherJoints_spec  = self.spec_attacherJoints
    local direction

    if actionName == InputAction.SFBC_TOGGLE_FRONT or actionName == InputAction.SFBC_LIFT_FRONT or actionName == InputAction.SFBC_LOWER_FRONT then
        print("Front action")
        if #spec.frontJoints > 0 then
            if actionName == InputAction.SFBC_LIFT_FRONT then
                print("front lift")
                direction = false
            elseif actionName == InputAction.SFBC_LOWER_FRONT then
                print("Front lower")
                direction = true
            end
            for joint in spec.frontJoints do
                
                handleLowerImplementByAttacherJointIndex(joint.jointIndex, direction)
            end
        end
    elseif actionName == InputAction.SFBC_TOGGLE_BACK or actionName == InputAction.SFBC_LIFT_BACK or actionName == InputAction.SFBC_LOWER_BACK then
        print("Back action")
        if #spec.backJoints > 0 then
            if actionName == InputAction.SFBC_LIFT_BACK then
                print("back lift")
                direction = false
            elseif actionName == InputAction.SFBC_LOWER_BACK then
                print("back lower")
                direction = true
            end
            for joint in spec.frontJoints do

                handleLowerImplementByAttacherJointIndex(joint.jointIndex, direction)
            end
        end
    end

    

end




