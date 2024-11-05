FrontBackControl = {}

function FrontBackControl.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AttacherJoints, specializations) and
    SpecializationUtil.hasSpecialization(Drivable, specializations) 
end

function FrontBackControl.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents", FrontBackControl)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad", FrontBackControl)
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad", FrontBackControl)
end

function FrontBackControl.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "actionHandleLowering", FrontBackControl.actionHandleLowering)
    SpecializationUtil.registerFunction(vehicleType, "doLowering", FrontBackControl.doLowering)
end

function FrontBackControl.registerOverwrittenFunctions(vehicleType)
end

function FrontBackControl:onLoad(savegame)
    local spec = self["spec_" .. FrontBackControl.modName .. ".frontBackControl"]

    spec.frontJoints = {}

    spec.backJoints = {}

end

function FrontBackControl:onPostLoad(savegame)
    local spec = self["spec_" .. FrontBackControl.modName .. ".frontBackControl"]
    local attacherJoints_spec  = self.spec_attacherJoints

    for attacherJointIndex, attacherJoint in pairs(attacherJoints_spec.attacherJoints) do
        if attacherJoint.comboTime ~= nil then
            if attacherJoint.comboTime <= 0.5 then
                table.insert(spec.frontJoints, {jointIndex = attacherJointIndex})
            else
                table.insert(spec.backJoints, {jointIndex = attacherJointIndex})
            end
        end
    end
end

function FrontBackControl:onRegisterActionEvents(isActionForInput, isActiveForInputIgnoreSelection)

    if self.isClient then
        local spec = self["spec_" .. FrontBackControl.modName .. ".frontBackControl"]

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

function FrontBackControl:actionHandleLowering(actionName, inputValue, callbackState, isAnalog)
    local spec = self["spec_" .. FrontBackControl.modName .. ".frontBackControl"]
    local attacherJoints_spec  = self.spec_attacherJoints
    local direction = nil

    if actionName == InputAction.SFBC_TOGGLE_FRONT or actionName == InputAction.SFBC_LIFT_FRONT or actionName == InputAction.SFBC_LOWER_FRONT then
        if table.getn(spec.frontJoints) > 0 then
            if actionName == InputAction.SFBC_LIFT_FRONT then
                direction = false
            elseif actionName == InputAction.SFBC_LOWER_FRONT then
                direction = true
            end
            for _, joint in pairs(spec.frontJoints) do
                self:doLowering(joint, direction)
            end
        end
    elseif actionName == InputAction.SFBC_TOGGLE_BACK or actionName == InputAction.SFBC_LIFT_BACK or actionName == InputAction.SFBC_LOWER_BACK then
        if table.getn(spec.backJoints) > 0 then
            if actionName == InputAction.SFBC_LIFT_BACK then
                direction = false
            elseif actionName == InputAction.SFBC_LOWER_BACK then
                direction = true
            end
            for _, joint in pairs(spec.backJoints) do
                self:doLowering(joint, direction)
            end
        end
    end
end

function FrontBackControl:doLowering(joint, direction)
    local implement = self:getImplementFromAttacherJointIndex(joint.jointIndex)
    if implement ~= nil then
        if implement.object.setLoweredAll ~= nil then
            local attacherJoint = self.spec_attacherJoints.attacherJoints[joint.jointIndex]
            local doLowering = nil
            if direction ~= nil then
                doLowering = direction
            else
                if implement.object.getToggledFoldMiddleDirection ~= nil then
                    local foldDirection = implement.object:getToggledFoldMiddleDirection()
                    if foldDirection ~= 0 then
                        doLowering = foldDirection < 0;
                    end
                end
                if doLowering == nil then
                    doLowering = not attacherJoint.moveDown
                end
            end
            implement.object:setLoweredAll(doLowering, joint.jointIndex)
        end
    end
end


