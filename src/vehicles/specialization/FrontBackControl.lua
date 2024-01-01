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

function FrontBackControl:onload(savegame)
    local spec = self["spec_" .. FrontBackControl.modName .. ".FrontBackControl"]

    spec.frontJoints = []

    spec.backJoints = []


end

function AttacherJoints:onPostLoad(savegame)
    local spec = self["spec_" .. FrontBackControl.modName .. ".FrontBackControl"]
    local attacherJoints_spec  = self.spec_attacherJoints

    for joint in for attacherJointIndex, attacherJoint in pairs(spec.attacherJoints) do
        if attacherJoint.comboTime ~= nil then
            if attacherJoint.comboTime <= 0.5 then
                table.insert(spec.frontJoints, {jointIndex = attacherJointIndex})
            else
                table.insert(spec.backJoints, {jointIndex = attacherJointIndex})
            end
        end
    end

end

function onRegisterActionEvents(isActionForInput, isActiveForInputIgnoreSelection)

    if self.isClient then
        local spec = self["spec_" .. FrontBackControl.modName .. ".FrontBackControl"]

        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            if not self:getIsAIActive() then
                local nonDrawActionEvents = {}
                local function insert(_, actionEventId)
                    table.insert(nonDrawActionEvents, actionEventId)
                end

                insert(self:addPoweredACtionEvent(spec.actionEvents, InputAction.SFBC_TOGGLE_FRONT, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredACtionEvent(spec.actionEvents, InputAction.SFBC_TOGGLE_BACK, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredACtionEvent(spec.actionEvents, InputAction.SFBC_LIFT_FRONT, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredACtionEvent(spec.actionEvents, InputAction.SFBC_LOWER_FRONT, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredACtionEvent(spec.actionEvents, InputAction.SFBC_LIFT_BACK, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))
                insert(self:addPoweredACtionEvent(spec.actionEvents, InputAction.SFBC_LOWER_BACK, self, FrontBackControl.actionHandleLowering, false, true, false, true, nil))

                for _, actionEventId in ipairs(nonDrawActionEvents) do
                    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
                    g_inputBinding:setActionEventTextVisibility(actionEventId, false)
                end
            end
        end
    end

end

function actionHandleLowering(self, actionName, inputValue, callbackState, isAnalog)
    local spec = self["spec_" .. FrontBackControl.modName .. ".FrontBackControl"]
    local attacherJoints_spec  = self.spec_attacherJoints
    local direction

    if actionName == InputAction.SFBC_TOGGLE_FRONT or actionName == InputAction.SFBC_LIFT_FRONT or actionName == InputAction.SFBC_LOWER_FRONT then
        if #spec.frontJoints > 0 then
            if actionName == InputAction.SFBC_LIFT_FRONT then
            elseif actionName == InputAction.SFBC_LOWER_FRONT then
            end
            for joint in spec.frontJoints do
                
                handleLowerImplementByAttacherJointIndex(joint.jointIndex, direction)
            end
        end
    elseif actionName == InputAction.SFBC_TOGGLE_FRONT or actionName == InputAction.SFBC_LIFT_FRONT or actionName == InputAction.SFBC_LOWER_FRONT then
        if #spec.backJoints > 0 then
            for joint in spec.frontJoints do

                self:setJointMoveDown(index, direction, false)
            end+
        end
    end if

    

end




