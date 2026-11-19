SteakAutoTracking = {
	events = {
		"PLAYER_TARGET_CHANGED",
		"PLAYER_ENTERING_WORLD"
	},
	frame = CreateFrame("Frame", nil, UIParent),
	Init = function(self)
		if self.initialized then return end
		self.initialized = true

		local _, class = UnitClass("player")
		if class ~= "HUNTER" then return end

		for _, event in ipairs(self.events) do
			self.frame:RegisterEvent(event)
		end

		self.frame:SetScript("OnEvent", function(_, event, ...)
			if self[event] then
				self[event](self, ...)
			end
		end)
	end,
	IsSpellKnown = function(self, spellName, isPet)
		for spellID, creatureType in pairs(self.spells) do
			local name = GetSpellInfo(spellID)

			if name == spellName and IsSpellKnown(spellID, isPet or false) then
				return true
			end
		end

		return false
	end,
	UpdateTracking = function(self)
		if not UnitExists("target") then return end

		local creatureType = UnitCreatureType("target")

		for i=1,GetNumTrackingTypes() do
			local name, texture, active, type = GetTrackingInfo(i)

			if name:match(creatureType) and type == "spell" then
				if not active then
					SetTracking(i, true)
				end
				return
			end
		end
	end,
	PLAYER_ENTERING_WORLD = function(self)
		self:UpdateTracking()
	end,
	PLAYER_TARGET_CHANGED = function(self)
		self:UpdateTracking()
	end
}

SteakAutoTracking:Init()
