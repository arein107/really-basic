local clubName = 42
local clubIdStr = 44


--Windows and stuff

borderFrame = CreateFrame("Frame", nil, UIParent, "PortraitFrameTemplate")
borderFrame:SetPoint("CENTER",UIParent)
borderFrame:SetSize(1000, 400)
borderFrame:EnableMouse(true)
borderFrame:SetMovable(true)
borderFrame:RegisterForDrag("LeftButton")--   Register left button for dragging1
borderFrame:SetScript("OnDragStart",borderFrame.StartMoving)--  Set script for drag start
borderFrame:SetScript("OnDragStop",borderFrame.StopMovingOrSizing)--    Set script for drag stop

portraitIcon = borderFrame:CreateTexture(nil, "OVERLAY")
portraitIcon:SetHeight(60)
portraitIcon:SetWidth(60)
portraitIcon:SetPoint("TOPLEFT",-5, 5)

SetPortraitToTexture(portraitIcon, "Interface\\ICONS\\UI_HordeIcon-round")

scrollFrame = CreateFrame("ScrollFrame", nil, borderFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(400,370)
scrollFrame:SetPoint("RIGHT", borderFrame, "RIGHT", -25, -10)

rosterTitleFrame = CreateFrame("Frame", nil, borderFrame, "AnimatedShineTemplate")
rosterTitleFrame:SetPoint("RIGHT", borderFrame, "TOPRIGHT", -60, -45)
rosterTitleFrame:SetSize(400,40)

infoTitleFrame = CreateFrame("Frame", nil, borderFrame, "AnimatedShineTemplate")
infoTitleFrame:SetPoint("TOP", borderFrame, "TOP",-76 ,-25)
infoTitleFrame:SetSize(400, 40)



frame = CreateFrame("Editbox", nil, scrollFrame, "AnimatedShineTemplate")
frame:SetPoint("BOTTOM", scrollFrame, "BOTTOM",0, 0)
frame:SetSize(300, 300)
frame:SetFontObject(Number18Font)
frame:EnableMouse(true)--   Receive mouse events (Buttons automatically have this set)
frame:SetAutoFocus(false)
frame:SetTextInsets(5,5,5,5)
frame:SetMultiLine(true)
scrollFrame:SetScrollChild(frame)

infoFrame = CreateFrame("Editbox", nil, borderFrame, "AnimatedShineTemplate")
infoFrame:SetPoint("TOP", borderFrame, "TOP",-76, -45)
infoFrame:SetSize(300, 400)
infoFrame:SetFontObject(Number18Font)
infoFrame:EnableMouse(true)--   Receive mouse events (Buttons automatically have this set)
infoFrame:SetAutoFocus(false)
infoFrame:SetTextInsets(5,5,5,5)
infoFrame:SetMultiLine(true)


dropDownList = CreateFrame("Frame", "DropDownList", borderFrame, "UIDropDownMenuTemplate");
dropDownList:SetPoint("TOPLEFT", borderFrame, "TOPLEFT",40,-20)
UIDropDownMenu_SetWidth(dropDownList, 200)
UIDropDownMenu_SetText(dropDownList, "Club: ")

------------------------------------------------------------------------------------------------------

rosterTitleFrameText = rosterTitleFrame:CreateFontString ( "rosterTitleFrameText" , "OVERLAY" , "Fancy22Font" );
rosterTitleFrameText:SetPoint("CENTER", rosterTitleFrame, "TOP", 0, -10)
rosterTitleFrameText:SetText("Roster: ")

infoFrameText = infoTitleFrame:CreateFontString("infoFrameText", "OVERLAY", "Fancy22Font");
infoFrameText:SetPoint("CENTER", infoTitleFrame, "TOP", 0,-10)
infoFrameText:SetText("Club Info: ")

---drop down menu functions

UIDropDownMenu_Initialize(dropDownList, function(frame, level, menuList) 

  local info = UIDropDownMenu_CreateInfo()
  local subscribedClubs = C_Club.GetSubscribedClubs()
  rosterString = ""

  info.func = dropDownList.SetValue


  for i, clubInfo in ipairs(subscribedClubs) do

----variables that make the club info readable
    clubNameStr = clubInfo.name
    joinTime = clubInfo.joinTime
    formatJoinTime = joinTime / 1000000
    notStupidTime = (date("!%m-%d-%Y at %H:%M:%SZ", formatJoinTime))
  
-----club type formatting

    clubTypeStr = clubInfo.clubType
    clubIdStr = clubInfo.clubId


    if clubTypeStr == 1 then
      clubTypeStr = "In-Game/Character-based Community"

    elseif clubTypeStr == 2 then
      clubTypeStr = "Guild"

    elseif clubTypeStr == 0 then
      clubTypeStr = "Battle.net Community"

    else 
      clubTypeStr = "Other"
    end
-----------

    rosterStr = ""
  for j, memberId in ipairs(C_Club.GetClubMembers((clubIdStr))) do
    memberInfo = C_Club.GetMemberInfo(clubIdStr, memberId)

    strName = tostring(memberInfo.name)

    if strName == "nil" then

      rosterStr = rosterStr 

    else

       rosterStr = rosterStr .."\n" ..  tostring(memberInfo.name)
     end
  end
---------the text that shows when the item is selected in the dropdown menu
    info.text = clubInfo.name
    info.arg1 =
    "Club Name: " .. clubNameStr .. "\n" .. "\n" ..
    "Member Count: " .. clubInfo.memberCount .. "\n" .. "\n" ..
    "Club ID: " .. clubInfo.clubId .. "\n" .."\n" ..
    "Club Type: " .. clubTypeStr .. "\n" .. "\n" ..
    "Join Date: " .. notStupidTime .. "\n"
    checked = true
    info.arg2 = rosterStr


  UIDropDownMenu_AddButton(info)
  

  end

end)


-- Implement the function to change the favoriteNumber
function dropDownList:SetValue(newValue, jewValue)

    frame:SetText(jewValue)

  -- print(clubIdStr)
    infoFrame:SetText(newValue)

end

