
AutosizeLayoutPanel=LayoutPanel:Inherit{
    classname="autosizelayoutpanel",
    resizeItems=false,
    centerItems=false,
    autosize=true,
	noFont = true,
}
AutosizeLayoutPanel.GetChildrenMinimumExtents=Utils.BetterGetChildrenMinimumExtents

local this = AutosizeLayoutPanel
local inherited = this.inherited
--[=[
function AutosizeLayoutPanel:New(obj)
	if (obj.orientation == "horizontal") then
		obj.rows, obj.columns = 1, nil
	else
		obj.rows, obj.columns = nil, 1
	end
	obj = inherited.New(self, obj)
	return obj
end

function AutosizeLayoutPanel:SetOrientation(orientation)
	if (orientation == "horizontal") then
		self.rows, self.columns = 1, nil
	else
		self.rows, self.columns = nil, 1
	end

	inherited.SetOrientation(self, orientation)
end
]=]
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
--[=[
--- ai bro
function AutosizeLayoutPanel:_LayoutChildren()
    local cn = self.children
    local cn_count = #cn

    self._lines = {1}
    local _lines = self._lines
    self._cells = {}
    local _cells = self._cells
    self._cellPaddings = {}
    local _cellPaddings = self._cellPaddings

    local itemMargin = self.itemMargin
    local itemPadding = self.itemPadding

    local cur_x, cur_y = 0, 0
    local curLine, curLineSize = 1, self.minItemHeight
    local totalChildWidth, totalChildHeight = 0, 0
    local lineHeights = {}
    local lineWidths = {}

    local clientAreaWidth, clientAreaHeight = self.clientArea[3], self.clientArea[4]

    if self.orientation == "horizontal" then
        local maxItemWidth = self.maxItemWidth or clientAreaWidth
        for i = 1, cn_count do
            local child = cn[i]
            if not child then break end
            local margin = child.margin or itemMargin

            local childWidth = math.max(child.width, self.minItemWidth)
            local childHeight = math.max(child.height, self.minItemHeight)

            local totalChildWidth = margin[1] + itemPadding[1] + childWidth + itemPadding[3] + margin[3]
            local totalChildHeight = margin[2] + itemPadding[2] + childHeight + itemPadding[4] + margin[4]

            if (i > 1) and (self.columns and ((i - 1) % self.columns < 1) or (not self.columns and cur_x + totalChildWidth > clientAreaWidth)) then
                lineHeights[curLine] = curLineSize
                lineWidths[curLine] = cur_x

                -- Start a new line
                cur_x = 0
                cur_y = cur_y + curLineSize
                curLine = curLine + 1
                curLineSize = math.max(self.minItemHeight, totalChildHeight)
                _lines[curLine] = i
            end

            local cell_left = cur_x + margin[1] + itemPadding[1]
            local cell_top = cur_y + margin[2] + itemPadding[2]
            local cell_width = childWidth
            local cell_height = childHeight

            _cells[i] = {cell_left, cell_top, cell_width, cell_height}
            _cellPaddings[i] = {margin[1] + itemPadding[1], margin[2] + itemPadding[2], margin[3] + itemPadding[3], margin[4] + itemPadding[4]}

            cur_x = cur_x + totalChildWidth
            if totalChildHeight > curLineSize then
                curLineSize = totalChildHeight
            end
        end
    else -- orientation == "vertical"
        local maxItemHeight = self.maxItemHeight or clientAreaHeight
        for i = 1, cn_count do
            local child = cn[i]
            if not child then break end
            local margin = child.margin or itemMargin

            local childWidth = math.max(child.width, self.minItemWidth)
            local childHeight = math.max(child.height, self.minItemHeight)

            local totalChildWidth = margin[1] + itemPadding[1] + childWidth + itemPadding[3] + margin[3]
            local totalChildHeight = margin[2] + itemPadding[2] + childHeight + itemPadding[4] + margin[4]

            if (i > 1) and (self.rows and ((i - 1) % self.rows < 1) or (not self.rows and cur_y + totalChildHeight > clientAreaHeight)) then
                lineHeights[curLine] = curLineSize
                lineWidths[curLine] = cur_y

                -- Start a new column
                cur_y = 0
                cur_x = cur_x + curLineSize
                curLine = curLine + 1
                curLineSize = math.max(self.minItemWidth, totalChildWidth)
                _lines[curLine] = i
            end

            local cell_left = cur_x + margin[1] + itemPadding[1]
            local cell_top = cur_y + margin[2] + itemPadding[2]
            local cell_width = childWidth
            local cell_height = childHeight

            _cells[i] = {cell_left, cell_top, cell_width, cell_height}
            _cellPaddings[i] = {margin[1] + itemPadding[1], margin[2] + itemPadding[2], margin[3] + itemPadding[3], margin[4] + itemPadding[4]}

            cur_y = cur_y + totalChildHeight
            if totalChildWidth > curLineSize then
                curLineSize = totalChildWidth
            end
        end
    end

    lineHeights[curLine] = curLineSize
    lineWidths[curLine] = cur_x

    -- Center items if needed
    if self.centerItems or self.autoArrangeH or self.autoArrangeV then
        for i = 1, #lineWidths do
            local startcell = _lines[i]
            local endcell = (_lines[i + 1] or (cn_count + 1)) - 1
            local freespace = (self.orientation == "horizontal") and (clientAreaWidth - lineWidths[i]) or (clientAreaHeight - lineWidths[i])
            self:_AutoArrangeAbscissa(startcell, endcell, freespace)
        end

        for i = 1, #lineHeights do
            local lineHeight = lineHeights[i]
            local startcell = _lines[i]
            local endcell = (_lines[i + 1] or (cn_count + 1)) - 1
            self:_EnlargeToLineHeight(startcell, endcell, lineHeight)
        end

        local freeSpace = (self.orientation == "horizontal") and (clientAreaHeight - cur_y) or (clientAreaWidth - cur_x)
        self:_AutoArrangeOrdinate(freeSpace)
    end

    -- Resize the LayoutPanel if needed
    if self.autosize then
        if self.orientation == "horizontal" then
            self:Resize(nil, cur_y, true, true)
        else
            self:Resize(cur_x, nil, true, true)
        end
    end

    -- Update the Children constraints
    for i = 1, cn_count do
        local child = cn[i]
        if not child then break end

        local cell = _cells[i]
        local cposx, cposy = cell[1], cell[2]
        if self.centerItems then
            cposx = cposx + (cell[3] - child.width) * 0.5
            cposy = cposy + (cell[4] - child.height) * 0.5
        end

        child:_UpdateConstraints(cposx, cposy)
    end
end
]=]