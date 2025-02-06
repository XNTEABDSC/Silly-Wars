Spring.Echo("Loaded AutosizeLayoutPanel")
AutosizeLayoutPanel=LayoutPanel:Inherit{
    resizeItems=false,
    centerItems=false,
    autosize=true,
	noFont = true,
}
if not Utils.BetterGetChildrenMinimumExtents then
    Spring.Echo("DEBUG: NO Utils.BetterGetChildrenMinimumExtents")
end
AutosizeLayoutPanel.GetChildrenMinimumExtents=Utils.BetterGetChildrenMinimumExtents

function AutosizeLayoutPanel:GetMinimumExtents()
--[[
    local old = self.autosize
    self.autosize = false
    local right, bottom = inherited.GetMinimumExtents(self)
    self.autosize = old

    return right, bottom
--]]
    local maxRight, maxBottom = 0, 0
    local right  = self.x + self.width
    local bottom = self.y + self.height
    maxRight, maxBottom = right, bottom

    if self.autosize then
        
        local childRight, childBottom=self:GetChildrenMinimumExtents()
        maxRight  = math.max(maxRight,  childRight)
        maxBottom = math.max(maxBottom, childBottom)

        
    end
    --return 500,500
    return maxRight, maxBottom
end

function AutosizeLayoutPanel:UpdateLayout()
    if (not self.children[1]) then
        --FIXME redundant?
        if (self.autosize) then
            if (self.orientation == "horizontal") then
                self:Resize(0, nil, false)
            else
                self:Resize(nil, 0, false)
            end
        end
        return
    
    end

    self:RealignChildren()

    if self.autosize then
        local neededWidth, neededHeight = self:GetChildrenMinimumExtents()

        local relativeBox = self:GetRelativeBox(self._savespace or self.savespace)
        neededWidth  = math.max(relativeBox[3], neededWidth)
        neededHeight = math.max(relativeBox[4], neededHeight)

        neededWidth  = neededWidth  - self.padding[1] - self.padding[3]
        neededHeight = neededHeight - self.padding[2] - self.padding[4]

        if (self.debug) then
            local cminextW, cminextH = self:GetChildrenMinimumExtents()
            Spring.Echo("Control:UpdateLayout", self.name,
                    "GetChildrenMinimumExtents", cminextW, cminextH,
                    "GetRelativeBox", relativeBox[3], relativeBox[4],
                    "savespace", self._savespace)
        end

        self:Resize(neededWidth, neededHeight, true, true)

        self._inUpdateLayout = true
    end

    --FIXME add check if any item.width > maxItemWidth ( + Height) & add a new autosize tag for it

    if (self.resizeItems) then
        self:_LayoutChildrenResizeItems()
    else
        self:_LayoutChildren()
    end

    self._inUpdateLayout = false

    self:RealignChildren() --FIXME split SetPos from AlignControl!!!

    return true
    
        
end