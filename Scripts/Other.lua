function TextBannerAfterSet(self,param)
	local Title=self:GetChild("Title")
	local Subtitle=self:GetChild("Subtitle")
	local Artist=self:GetChild("Artist")

	if Subtitle:GetText() == "" then
		Title:maxwidth(192)
		Title:y(-8)
		Title:zoom(1.2)
		Title:zoomx(1.4)

		Subtitle:visible(false)

		Artist:maxwidth(349)
		Artist:y(10)
		Artist:zoom(0.75)
	else
		Title:maxwidth(274)
		Title:zoom(1)
		Title:y(-10)

		-- subtitle below title
		Subtitle:visible(false)
		Subtitle:zoom(0.55)
		Subtitle:maxwidth(274)

		Artist:maxwidth(349)
		Artist:y(9)
		Artist:zoom(0.7)
	end

end

function PlayerItemOn(self)
	self:uppercase(true)
	self:maxwidth(148)
	self:halign(pn=='PlayerNumber_P2' and 0 or 1)
end;

local difficultyToIconIndex = {
	Difficulty_Beginner		= 0,
	Difficulty_Easy			= 1,
	Difficulty_Medium		= 2,
	Difficulty_Hard			= 3,
	Difficulty_Challenge 	= 4,
	Difficulty_Edit			= 5
}
function GetDifficultyIconFrame(diff) return difficultyToIconIndex[diff] or difficultyToIconIndex['Difficulty_Edit'] end

function LoadStepsDisplayGameplayFrame(self,player)
	local difficultyStates = {
		Difficulty_Beginner	 = 0,
		Difficulty_Easy		 = 2,
		Difficulty_Medium	 = 4,
		Difficulty_Hard		 = 6,
		Difficulty_Challenge = 8,
		Difficulty_Edit		 = 10,
	};
	local selection;
	if GAMESTATE:IsCourseMode() then
		-- get steps of current course entry
		selection = GAMESTATE:GetCurrentTrail(player);
		local entry = selection:GetTrailEntry(GAMESTATE:GetLoadingCourseSongIndex()+1)
		selection = entry:GetSteps()
	else
		selection = GAMESTATE:GetCurrentSteps(player);
	end;
	local diff = selection:GetDifficulty()
	local state = difficultyStates[diff] or 10;
	if player == PLAYER_2 then state = state + 1; end;
	return state;
end;

function Actor:scale_or_crop_background()
	if PREFSMAN:GetPreference("StretchBackgrounds") then
		self:cropto(SCREEN_WIDTH, SCREEN_HEIGHT)
	else
		local graphicAspect = self:GetWidth()/self:GetHeight()
		self:zoomto(SCREEN_HEIGHT*graphicAspect,SCREEN_HEIGHT)
	end
end

-- GetCharAnimPath(sPath)
-- Easier access to Characters folder (taken from ScreenHowToPlay.cpp)
function GetCharAnimPath(sPath) return "/Characters/"..sPath end

--stuff for doing update functions that i love so -tertu
function CalculateWaitFrames(targetDelta, delta)
    return math.max(1, math.round(targetDelta/delta))-1
end

--returns a function that returns true if the function should run this update
function GetUpdateTimer(targetDelta)
    local frameCounter = 0
    return function()
        if frameCounter == 0 then
            frameCounter = CalculateWaitFrames(targetDelta, 1/DISPLAY:GetCumFPS())
            return true
        end
        frameCounter = frameCounter - 1
        return false
    end
end
