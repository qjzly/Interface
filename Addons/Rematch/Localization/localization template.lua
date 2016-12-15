﻿--[[
	This file is a template for localizing Rematch into other languages.

	As strings are added/removed for each update, they will appear here.

	If you'd like to translate Rematch into another language, that would be
	very much appreciated!

	Take this file and add translations for the text in quotes, then contact
	me via PM to Gello either on wowinterface.com or curse.com. If you're able
	to include the file in the message that'd be a bonus but not necessary.

	(Please make sure to use default game fonts and test to ensure text fits!)

	Thanks!
]]

--[[ New strings in 3.5.4 to 3.5.7
"Hide mouseover buttons"
"Comes back to life once per battle, returning to 20% health."
"Deals 25% extra damage while below half health."
"If a duplicate is found:"
"Ingores all negative weather effects."
"Returns to life immortal for one round when killed."
"Gains 50% extra speed while above 50% health."
"Cannot be dealt more than 35% of maximum health in one attack."
"When you mouseover a team in the team list, don't show faded buttons to set notes, preferences and a target when the team lacks any of them.\n\nNote: This is experimental and may disappear."
"Importing Multiple Teams..."
"Save these teams?"
"Press CTRL+C to copy this tab's teams to the clipboard."
"Tab: %s"
"Overwrite existing teams."
"Save as new teams."
"Recovers 4% of their maximum health if damage dealth in a round."
"Export Teams"
"Deals 50% extra damage on the round after bringing a target below 50% health."
"Harmful damage over time effects are reduced by 50%."
"Note: This does not include preferences, notes or anything about this tab. This text just stores the names of each team, their targets, their pets and abilities only."
"Tanaan Jungle"
"Immune to stun, root, and sleep effects."
]]

local _,L = ...
if GetLocale()=="????" then

-- browser.lua
	L["Strong vs"] = "Strong vs"
	L["Tough vs"] = "Tough vs"
	L["Pets:"] = "Pets:"
	L["Owned:"] = "Owned:"
	L["Your pets:"] = "Your pets:"
	L["Owned: \124cffffffff%d\124r\nMissing: \124cffffffff%d\124r\nUnique: \124cffffffff%d\124r\nLevel 25: \124cffffffff%d"] = "Owned: \124cffffffff%d\124r\nMissing: \124cffffffff%d\124r\nUnique: \124cffffffff%d\124r\nLevel 25: \124cffffffff%d"

-- common.lua
	L["Toggle Window"] = "Toggle Window"
	L["Toggle Auto Load"] = "Toggle Auto Load"
	L["Toggle Pets"] = "Toggle Pets"
	L["Toggle Teams"] = "Toggle Teams"
	L["Toggle Notes"] = "Toggle Notes"
	L["You updated Rematch while logged in.\n\nWhich is usually fine!\n\nHowever, this update has changes the game won't pick up while logged in.\n\nTo prevent corruption of your data, Rematch is disabled until you've exited the game and restarted."] = "You updated Rematch while logged in.\n\nWhich is usually fine!\n\nHowever, this update has changes the game won't pick up while logged in.\n\nTo prevent corruption of your data, Rematch is disabled until you've exited the game and restarted."
	L["Toggles the Rematch window to manage battle pets and teams."] = "Toggles the Rematch window to manage battle pets and teams."
	L["Added to the queue:"] = "Added to the queue:"

-- current.lua
	L["Current Battle Pets"] = "Current Battle Pets"

-- dialog.lua
	L["Save in team tab:"] = "Save in team tab:"

-- floatingpetcard.lua
	L["Damage Taken"] = "Damage Taken"
	L["from"] = "from"
	L["abilities"] = "abilities"
	L["This pet is currently slotted."] = "This pet is currently slotted."
	L["When this team loads, your active leveling pet will go in this spot."] = "When this team loads, your active leveling pet will go in this spot."
	L["From"] = "From"
	L["This is an NPC pet."] = "This is an NPC pet."
	L["Leveling Pet"] = "Leveling Pet"
	L["%s \1244Team:Teams;"] = "%s \1244Team:Teams;"
	L["\124cffddddddPossible Breeds"] = "\124cffddddddPossible Breeds"
	L["\124cffddddddPossible level 25 \124cff0070ddRares"] = "\124cffddddddPossible level 25 \124cff0070ddRares"
	L["No breeds known :("] = "No breeds known :("
	L["From: %s"] = "From: %s"

-- leveling.lua
	L["Queued:"] = "Queued:"
	L["Leveling"] = "Leveling"
	L["Active"] = "Active"
	L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t This pet can't level"] = "\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t This pet can't level"
	L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t Active Sort is enabled"] = "\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t Active Sort is enabled"
	L["This pet is already in the queue.\n\nYou can't rearrange the order of pets while the queue is actively sorted."] = "This pet is already in the queue.\n\nYou can't rearrange the order of pets while the queue is actively sorted."
	L["\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t Active Sort is enabled"] = "\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t Active Sort is enabled"
	L["The queue is actively sorted. This pet will be sorted with the rest."] = "The queue is actively sorted. This pet will be sorted with the rest."
	L["This is the leveling slot.\n\nDrag a level 1-24 pet here to set it as the active leveling pet.\n\nWhen a team is saved with a leveling pet, that pet's place on the team is reserved for future leveling pets.\n\nThis slot can contain as many leveling pets as you want. When a pet reaches 25 the topmost pet in the queue becomes your new leveling pet."] = "This is the leveling slot.\n\nDrag a level 1-24 pet here to set it as the active leveling pet.\n\nWhen a team is saved with a leveling pet, that pet's place on the team is reserved for future leveling pets.\n\nThis slot can contain as many leveling pets as you want. When a pet reaches 25 the topmost pet in the queue becomes your new leveling pet."
	L["Next leveling pet:"] = "Next leveling pet:"
	L["All done leveling pets!"] = "All done leveling pets!"
	L["Rematch's leveling queue is empty"] = "Rematch's leveling queue is empty"
	L["a pet battle"] = "a pet battle"
	L["pet PVP"] = "pet PVP"
	L["In Pet Battle"] = "In Pet Battle"
	L["You are in %s.\n\nThe leveling slot and queue are locked while you are in %s."] = "You are in %s.\n\nThe leveling slot and queue are locked while you are in %s."
	L["Choose a new pet"] = "Choose a new pet"
	L["Choosing a pet will turn off Active Sort"] = "Choosing a pet will turn off Active Sort"

-- main.lua
	L["Teams"] = "Teams"
	L["You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"] = "You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"
	L["Auto Load is now"] = "Auto Load is now"
	L["\124cff00ff00Enabled"] = "\124cff00ff00Enabled"
	L["\124cffff0000Disabled"] = "\124cffff0000Disabled"
	L["This team did not automatically load because you've already auto-loaded a team from where you're standing."] = "This team did not automatically load because you've already auto-loaded a team from where you're standing."
	L["Summon a leveling pet."] = "Summon a leveling pet."
	L["Summon a favorite pet."] = "Summon a favorite pet."
	L["Target treat onto the pet."] = "Target treat onto the pet."
	L["Cast this treat."] = "Cast this treat."
	L["Dismiss the summoned pet."] = "Dismiss the summoned pet."
	L["Your pets are already at full health."] = "Your pets are already at full health."
	L["Save As..."] = "Save As..."
	L["Options"] = "Options"
	L["Undo"] = "Undo"
	L["Revert to the last saved notes. Changes are saved when leaving these notes."] = "Revert to the last saved notes. Changes are saved when leaving these notes."
	L["Clear Notes"] = "Clear Notes"

-- npcs.lua
	L["Eastern Kingdom"] = "Eastern Kingdom"
	L["Kalimdor"] = "Kalimdor"
	L["Outland"] = "Outland"
	L["Northrend"] = "Northrend"
	L["Cataclysm"] = "Cataclysm"
	L["Pandaria"] = "Pandaria"
	L["Beasts of Fable"] = "Beasts of Fable"
	L["Celestial Tournament"] = "Celestial Tournament"
	L["Draenor"] = "Draenor"
	L["Garrison"] = "Garrison"
	L["Menagerie"] = "Menagerie"
	L["No Target"] = "No Target"

-- options.lua
	L["Targeting Options"] = "Targeting Options"
	L["Auto show on target"] = "Auto show on target"
	L["When targeting something with a saved team not already loaded, show the Rematch window."] = "When targeting something with a saved team not already loaded, show the Rematch window."
	L["Stay after loading"] = "Stay after loading"
	L["Keep the Rematch window on screen after loading a team when the window was shown via 'Auto show on target'."] = "Keep the Rematch window on screen after loading a team when the window was shown via 'Auto show on target'."
	L["Auto load"] = "Auto load"
	L["When your mouseover or target has a saved team not already loaded, load the team immediately."] = "When your mouseover or target has a saved team not already loaded, load the team immediately."
	L["Show after loading"] = "Show after loading"
	L["When a team is automatically loaded, show the Rematch window if it's not already shown."] = "When a team is automatically loaded, show the Rematch window if it's not already shown."
	L["On target only"] = "On target only"
	L["Auto load will only happen when you target, not mouseover. \124cffff2222WARNING!\124cffffd200 This option is not recommended! It is often too late to load pets when a battle starts if you target with right-click!"] = "Auto load will only happen when you target, not mouseover. \124cffff2222WARNING!\124cffffd200 This option is not recommended! It is often too late to load pets when a battle starts if you target with right-click!"
	L["Discard loaded team on changes"] = "Discard loaded team on changes"
	L["\124cffff2222WARNING!\124cffffd200 This option is not recommended!\124r\n\nThis option changes the normal behavior of Rematch and its interaction with teams and targets.\n\nSpecifically:\n- Anytime you change pets or abilities, it will 'unload' the team.\n- It will forget what's loaded in the past and always offer to load/show teams.\n- It will be very difficult to save changes to teams.\n-The Reload button will be disabled.\n\n\124cffff2222This option will be going away very soon!"] = "\124cffff2222WARNING!\124cffffd200 This option is not recommended!\124r\n\nThis option changes the normal behavior of Rematch and its interaction with teams and targets.\n\nSpecifically:\n- Anytime you change pets or abilities, it will 'unload' the team.\n- It will forget what's loaded in the past and always offer to load/show teams.\n- It will be very difficult to save changes to teams.\n-The Reload button will be disabled.\n\n\124cffff2222This option will be going away very soon!"
	L["Window Options"] = "Window Options"
	L["Larger window"] = "Larger window"
	L["Make the Rematch window larger for easier viewing."] = "Make the Rematch window larger for easier viewing."
	L["Larger text"] = "Larger text"
	L["Make the text in the scrollable lists (pets, teams and options) and menus a little bigger."] = "Make the text in the scrollable lists (pets, teams and options) and menus a little bigger."
	L["Keep window expanded"] = "Keep window expanded"
	L["Keep the window expanded at all times while on screen."] = "Keep the window expanded at all times while on screen."
	L["Lock window position"] = "Lock window position"
	L["Prevent the Rematch window from being dragged unless Shift is held."] = "Prevent the Rematch window from being dragged unless Shift is held."
	L["Lock window size"] = "Lock window size"
	L["Prevent the window from being resized with the resize grip along the edge of the window."] = "Prevent the window from being resized with the resize grip along the edge of the window."
	L["Reverse pullout"] = "Reverse pullout"
	L["When the Pets or Teams tab is opened, expand the window down the screen instead of up."] = "When the Pets or Teams tab is opened, expand the window down the screen instead of up."
	L["Reverse dialog direction"] = "Reverse dialog direction"
	L["This setting controls which side of the Rematch window popup dialogs will appear.\n\nRegardless of this setting, when the window is expanded, unless the 'Show dialogs at side' option is checked, they will appear in the middle of the window.\n\n\Otherwise:\n\n\124cffffd200When this option is disabled:\124r Dialogs will appear in the direction that the pullout drawer grows.\n\n\124cffffd200When this option is enabled:\124r Dialogs will appear in the opposite direction that the pullout drawer grows."] = "This setting controls which side of the Rematch window popup dialogs will appear.\n\nRegardless of this setting, when the window is expanded, unless the 'Show dialogs at side' option is checked, they will appear in the middle of the window.\n\n\Otherwise:\n\n\124cffffd200When this option is disabled:\124r Dialogs will appear in the direction that the pullout drawer grows.\n\n\124cffffd200When this option is enabled:\124r Dialogs will appear in the opposite direction that the pullout drawer grows."
	L["Show dialogs at side"] = "Show dialogs at side"
	L["Instead of making popup dialogs appear in the middle of the expanded Rematch window, make them appear to the side."] = "Instead of making popup dialogs appear in the middle of the expanded Rematch window, make them appear to the side."
	L["Stay through logouts"] = "Stay through logouts"
	L["If the Rematch window is up when you logout, summon it back on next login after pets load."] = "If the Rematch window is up when you logout, summon it back on next login after pets load."
	L["Escape Key Behavior"] = "Escape Key Behavior"
	L["Disable ESC for window"] = "Disable ESC for window"
	L["Prevent the Rematch window from being dismissed with the Escape key."] = "Prevent the Rematch window from being dismissed with the Escape key."
	L["Disable ESC for drawer"] = "Disable ESC for drawer"
	L["Prevent the pullout drawer from being collapsed with the Escape key."] = "Prevent the pullout drawer from being collapsed with the Escape key."
	L["Disable ESC for notes"] = "Disable ESC for notes"
	L["Prevent the notes card from being dismissed with the Escape key."] = "Prevent the notes card from being dismissed with the Escape key."
	L["Close everything with ESC"] = "Close everything with ESC"
	L["Close all Escape-enabled Rematch windows at once with the Escape key instead of one at a time."] = "Close all Escape-enabled Rematch windows at once with the Escape key instead of one at a time."
	L["Battle Options"] = "Battle Options"
	L["Stay for pet battle"] = "Stay for pet battle"
	L["When a pet battle begins, keep Rematch on screen instead of hiding it. Note: the window will still close on player combat."] = "When a pet battle begins, keep Rematch on screen instead of hiding it. Note: the window will still close on player combat."
	L["Show after pet battle"] = "Show after pet battle"
	L["When leaving a pet battle, automatically show the Rematch window."] = "When leaving a pet battle, automatically show the Rematch window."
	L["Show notes in battle"] = "Show notes in battle"
	L["If the loaded team has notes, display and lock the notes when you enter a pet battle."] = "If the loaded team has notes, display and lock the notes when you enter a pet battle."
	L["Only once per team"] = "Only once per team"
	L["Only display notes automatically the first time entering battle, until another team is loaded."] = "Only display notes automatically the first time entering battle, until another team is loaded."
	L["Loading Options"] = "Loading Options"
	L["One-click loading"] = "One-click loading"
	L["When clicking a team in the Teams tab, instead of locking the team card, load the team immediately. If this is unchecked you can double-click a team to load it."] = "When clicking a team in the Teams tab, instead of locking the team card, load the team immediately. If this is unchecked you can double-click a team to load it."
	L["Don't warn about missing pets"] = "Don't warn about missing pets"
	L["Don't display a popup when a team loads and a pet within the team can't be found."] = "Don't display a popup when a team loads and a pet within the team can't be found."
	L["Keep companion"] = "Keep companion"
	L["After a team is loaded, summon back the companion that was at your side before the load."] = "After a team is loaded, summon back the companion that was at your side before the load."
	L["Show on injured"] = "Show on injured"
	L["When pets load, show the window if any pets are injured. The window will show if any pets are dead or missing regardless of this setting."] = "When pets load, show the window if any pets are injured. The window will show if any pets are dead or missing regardless of this setting."
	L["Leveling Queue Options"] = "Leveling Queue Options"
	L["Keep current pet on new sort"] = "Keep current pet on new sort"
	L["When sorting the queue, keep the top-most pet at the top so the current leveling pet doesn't change.\n\nThis option has no effect when the queue is actively sorted."] = "When sorting the queue, keep the top-most pet at the top so the current leveling pet doesn't change.\n\nThis option has no effect when the queue is actively sorted."
	L["Hide pet toast"] = "Hide pet toast"
	L["Don't display the popup 'toast' when a new pet is automatically loaded from or added to the leveling queue."] = "Don't display the popup 'toast' when a new pet is automatically loaded from or added to the leveling queue."
	L["Prefer live pets"] = "Prefer live pets"
	L["When loading pets from the queue, skip dead pets and load living ones first."] = "When loading pets from the queue, skip dead pets and load living ones first."
	L["Automatically level new pets"] = "Automatically level new pets"
	L["When you capture or learn a pet, automatically add it to the leveling queue."] = "When you capture or learn a pet, automatically add it to the leveling queue."
	L["Only pets not at 25 or queued"] = "Only pets not at 25 or queued"
	L["Only automatically level pets which don't already have a version at 25 or in the queue."] = "Only automatically level pets which don't already have a version at 25 or in the queue."
	L["Only rare pets"] = "Only rare pets"
	L["Only automatically level rare quality pets."] = "Only automatically level rare quality pets."
	L["Pet Tab Options"] = "Pet Tab Options"
	L["Use type bar"] = "Use type bar"
	L["Show the tabbed bar near the top of the pet browser to filter pet types, pets that are strong or tough vs chosen types."] = "Show the tabbed bar near the top of the pet browser to filter pet types, pets that are strong or tough vs chosen types."
	L["Only battle pets"] = "Only battle pets"
	L["Never list pets that can't battle in the pet browser, such as Guild Heralds. Note: most filters like rarity, level or stats will not include non-battle pets already."] = "Never list pets that can't battle in the pet browser, such as Guild Heralds. Note: most filters like rarity, level or stats will not include non-battle pets already."
	L["List real names"] = "List real names"
	L["Even if a pet has been renamed, list each pet by its real name."] = "Even if a pet has been renamed, list each pet by its real name."
	L["Inclusive \"Strong Vs\" filter"] = "Inclusive \"Strong Vs\" filter"
	L["When filtering Strong Vs multiple types, list pets that have an ability that's strong vs one of the chosen types, instead of requiring at least one ability to be strong vs each chosen type."] = "When filtering Strong Vs multiple types, list pets that have an ability that's strong vs one of the chosen types, instead of requiring at least one ability to be strong vs each chosen type."
	L["Reset filters on login"] = "Reset filters on login"
	L["Reset all pet browser filters (including sort) when logging in."] = "Reset all pet browser filters (including sort) when logging in."
	L["Don't reset sort with filters"] = "Don't reset sort with filters"
	L["When a non-standard sort is chosen, don't reset it when clicking the filter reset button at the bottom of the pet browser.\n\n\124cffffd200Note:\124r If 'Reset filters on login' is enabled, sort will still be reset on login regardless of this option."] = "When a non-standard sort is chosen, don't reset it when clicking the filter reset button at the bottom of the pet browser.\n\n\124cffffd200Note:\124r If 'Reset filters on login' is enabled, sort will still be reset on login regardless of this option."
	L["Team Tab Options"] = "Team Tab Options"
	L["Spam when teams move"] = "Spam when teams move"
	L["Display in your chat window when a team moves to another tab."] = "Display in your chat window when a team moves to another tab."
	L["Spam when teams save"] = "Spam when teams save"
	L["Display in your chat window when a team is saved and the tab it was saved to."] = "Display in your chat window when a team is saved and the tab it was saved to."
	L["Require Shift to drag"] = "Require Shift to drag"
	L["Lock teams in place so they require holding Shift to drag them."] = "Lock teams in place so they require holding Shift to drag them."
	L["Hide Target buttons"] = "Hide Target buttons"
	L["In the team list, hide the \124TInterface\\AddOns\\Rematch\\textures\\targeted:16:16:0:0:64:64:48:16:16:48\124t buttons that mark when a team is saved for a specific target."] = "In the team list, hide the \124TInterface\\AddOns\\Rematch\\textures\\targeted:16:16:0:0:64:64:48:16:16:48\124t buttons that mark when a team is saved for a specific target."
	L["Show mouseover buttons"] = "Show mouseover buttons"
	L["When you mouseover a team in the team list, show faded buttons to set notes, preferences and a target when the team lacks any of them.\n\nNote: This is experimental and may disappear."] = "When you mouseover a team in the team list, show faded buttons to set notes, preferences and a target when the team lacks any of them.\n\nNote: This is experimental and may disappear."
	L["Show ability numbers"] = "Show ability numbers"
	L["In the ability flyout, show the numbers 1 and 2 to help with the common notation such as \"Pet Name 122\" to know which abilities to use."] = "In the ability flyout, show the numbers 1 and 2 to help with the common notation such as \"Pet Name 122\" to know which abilities to use."
	L["Use actual ability icons"] = "Use actual ability icons"
	L["In the pet card, display the actual icon of each ability instead of an icon showing the ability's type."] = "In the pet card, display the actual icon of each ability instead of an icon showing the ability's type."
	L["Hide rarity borders"] = "Hide rarity borders"
	L["Hide the colored borders to indicate rarity around current pets and pets on the team cards."] = "Hide the colored borders to indicate rarity around current pets and pets on the team cards."
	L["Disable sharing"] = "Disable sharing"
	L["Disable the Send button and also block any incoming pets sent by others. Import and Export still work."] = "Disable the Send button and also block any incoming pets sent by others. Import and Export still work."
	L["Jump to key"] = "Jump to key"
	L["While the mouse is over the team list or pet browser, hitting a key will jump to the next team or pet that begins with that letter."] = "While the mouse is over the team list or pet browser, hitting a key will jump to the next team or pet that begins with that letter."
	L["Hide tooltips"] = "Hide tooltips"
	L["Hide the more common tooltips within Rematch."] = "Hide the more common tooltips within Rematch."
	L["Even options"] = "Even options"
	L["Also hide tooltips that appear here in the options panel. This is not recommended if you're new to the addon."] = "Also hide tooltips that appear here in the options panel. This is not recommended if you're new to the addon."
	L["Use minimap button"] = "Use minimap button"
	L["Place a button on the minimap to toggle Rematch."] = "Place a button on the minimap to toggle Rematch."
	L["Hide journal button"] = "Hide journal button"
	L["Do not place a Rematch button along the bottom of the default Pet Journal."] = "Do not place a Rematch button along the bottom of the default Pet Journal."
	L["Go to the key binding window to create or change bindings for Rematch."] = "Go to the key binding window to create or change bindings for Rematch."
	L["Import Pet Battle Teams"] = "Import Pet Battle Teams"
	L["Copy the teams from the addon Pet Battle Teams to the current team tab in Rematch."] = "Copy the teams from the addon Pet Battle Teams to the current team tab in Rematch."
	L["Toggle Rematch"] = "Toggle Rematch"
	L["%s copied."] = "%s copied."
	L["%s not copied. A team of that name already exists."] = "%s not copied. A team of that name already exists."
	L["Pet Battle Teams Imported"] = "Pet Battle Teams Imported"
	L["Copy again and overwrite?"] = "Copy again and overwrite?"
	L["%d teams copied successfully."] = "%d teams copied successfully."
	L["\n\n%d teams were not copied because teams already exist in Rematch with the same names."] = "\n\n%d teams were not copied because teams already exist in Rematch with the same names."
	L["Start Leveling"] = "Start Leveling"
	L["Add to Leveling Queue"] = "Add to Leveling Queue"
	L["Stop Leveling"] = "Stop Leveling"
	L["Find Similar"] = "Find Similar"

-- petloading.lua
	L["Loading..."] = "Loading..."
	L["Pets are missing!"] = "Pets are missing!"

-- preferences.lua
	L["Leveling Pet Preferences"] = "Leveling Pet Preferences"
	L["Minimum Health"] = "Minimum Health"
	L["Maximum Level"] = "Maximum Level"
	L["Or any"] = "Or any"
	L["This is the minimum health preferred for a leveling pet."] = "This is the minimum health preferred for a leveling pet."
	L["Allow low-health Magic and Mechanical pets to ignore the Minimum Health, since their racials allow them to often survive a hit that would ordinarily kill them."] = "Allow low-health Magic and Mechanical pets to ignore the Minimum Health, since their racials allow them to often survive a hit that would ordinarily kill them."
	L["This is the maximum level preferred for a leveling pet.\n\nLevels can be partial amounts. Level 23.45 is level 23 with 45% xp towards level 24."] = "This is the maximum level preferred for a leveling pet.\n\nLevels can be partial amounts. Level 23.45 is level 23 with 45% xp towards level 24."
	L["Expected damage taken"] = "Expected damage taken"
	L["Leveling Preferences"] = "Leveling Preferences"
	L["  For %s pets: \124cffffd200%d"] = "  For %s pets: \124cffffd200%d"
	L["Damage expected"] = "Damage expected"
	L["Save Preferences?"] = "Save Preferences?"
	L["The minimum health of pets can be adjusted by the type of damage they are expected to receive."] = "The minimum health of pets can be adjusted by the type of damage they are expected to receive."

-- rmf.lua
	L["Empty Slot"] = "Empty Slot"
	L["Choose a name."] = "Choose a name."
	L["Restore original name"] = "Restore original name"
	L["Release this pet?"] = "Release this pet?"
	L["Once released, this pet is gone forever!"] = "Once released, this pet is gone forever!"
	L["Cage this pet?"] = "Cage this pet?"
	L["Save Filters"] = "Save Filters"
	L["Do you want to overwrite the existing saved filters?"] = "Do you want to overwrite the existing saved filters?"
	L["List %d \1244Team:Teams;"] = "List %d \1244Team:Teams;"
	L["Current Zone"] = "Current Zone"
	L["Strong Vs"] = "Strong Vs"
	L["Tough Vs"] = "Tough Vs"
	L["Load Filters"] = "Load Filters"
	L["Reset All"] = "Reset All"
	L["Use Type Bar"] = "Use Type Bar"
	L["Reverse Sort"] = "Reverse Sort"
	L["Favorites First"] = "Favorites First"
	L["Not Leveling"] = "Not Leveling"
	L["Tradable"] = "Tradable"
	L["Not Tradable"] = "Not Tradable"
	L["Can Battle"] = "Can Battle"
	L["Can't Battle"] = "Can't Battle"
	L["Only Level 25s"] = "Only Level 25s"
	L["Without Any 25s"] = "Without Any 25s"
	L["Moveset Not At 25"] = "Moveset Not At 25"
	L["1 Pet"] = "1 Pet"
	L["2+ Pets"] = "2+ Pets"
	L["3+ Pets"] = "3+ Pets"
	L["In a Team"] = "In a Team"
	L["Not In a Team"] = "Not In a Team"
	L["Put Leveling Pet Here"] = "Put Leveling Pet Here"
	L["Move to Top"] = "Move to Top"
	L["Move Up"] = "Move Up"
	L["Move Down"] = "Move Down"
	L["Move to End"] = "Move to End"
	L["Fill Queue"] = "Fill Queue"
	L["This will add %d pets to the leveling queue.\n%s\nAre you sure you want to fill the leveling queue?"] = "This will add %d pets to the leveling queue.\n%s\nAre you sure you want to fill the leveling queue?"
	L["\nYou can reduce the number of pets by filtering them in Rematch's pet browser\n\nFor instance: search for \"21-24\" and filter Rare only to fill the queue with rares between level 21 and 24.\n"] = "\nYou can reduce the number of pets by filtering them in Rematch's pet browser\n\nFor instance: search for \"21-24\" and filter Rare only to fill the queue with rares between level 21 and 24.\n"
	L["\nAll species with a pet that can level already have a pet in the queue.\n"] = "\nAll species with a pet that can level already have a pet in the queue.\n"
	L["Empty Queue"] = "Empty Queue"
	L["Are you sure you want to remove all pets from the leveling queue?"] = "Are you sure you want to remove all pets from the leveling queue?"
	L["Queue"] = "Queue"
	L["Sort By:"] = "Sort By:"
	L["Ascending"] = "Ascending"
	L["Sort:Ascending"] = "Sort:Ascending"
	L["Sort all pets in the queue from level 1 to level 24."] = "Sort all pets in the queue from level 1 to level 24."
	L["Median"] = "Median"
	L["Sort:Median"] = "Sort:Median"
	L["Sort all pets in the queue for levels closest to 10.5."] = "Sort all pets in the queue for levels closest to 10.5."
	L["Descending"] = "Descending"
	L["Sort:Descending"] = "Sort:Descending"
	L["Sort all pets in the queue from level 24 to level 1."] = "Sort all pets in the queue from level 24 to level 1."
	L["Sort:Type"] = "Sort:Type"
	L["Sort all pets in the queue by their types."] = "Sort all pets in the queue by their types."
	L["Time"] = "Time"
	L["Sort:Time"] = "Sort:Time"
	L["Sort all pets in the queue by when they were added, earliest pets first."] = "Sort all pets in the queue by when they were added, earliest pets first."
	L["Active Sort"] = "Active Sort"
	L["When sorting the queue, Rematch will keep it sorted. The order of pets may change as they gain xp or get added/removed from the queue.\n\nYou cannot manually change the order of pets while the queue is actively sorted."] = "When sorting the queue, Rematch will keep it sorted. The order of pets may change as they gain xp or get added/removed from the queue.\n\nYou cannot manually change the order of pets while the queue is actively sorted."
	L["No Preferences"] = "No Preferences"
	L["Suspend all preferred loading of pets from the queue, except for pets that can't load."] = "Suspend all preferred loading of pets from the queue, except for pets that can't load."
	L["Fill the leveling queue with one of each species that can level from the filtered pet browser, and for which you don't have a level 25 already."] = "Fill the leveling queue with one of each species that can level from the filtered pet browser, and for which you don't have a level 25 already."
	L["Fill Queue More"] = "Fill Queue More"
	L["Fill the leveling queue with one of each species that can level from the filtered pet browser, regardless whether you have any at level 25 already."] = "Fill the leveling queue with one of each species that can level from the filtered pet browser, regardless whether you have any at level 25 already."
	L["Remove all leveling pets from the queue."] = "Remove all leveling pets from the queue."
	L["Remove custom sort?"] = "Remove custom sort?"
	L["The saved order will be lost and teams will be listed alphabetically again."] = "The saved order will be lost and teams will be listed alphabetically again."
	L["Custom Sort"] = "Custom Sort"
	L["Edit"] = "Edit"
	L["Delete this team?"] = "Delete this team?"
	L["Load Team"] = "Load Team"
	L["You can also double-click a team to load it."] = "You can also double-click a team to load it."
	L["Preferences"] = "Preferences"
	L["Edit Team"] = "Edit Team"
	L["Set Notes"] = "Set Notes"
	L["Move To"] = "Move To"
	L["Share"] = "Share"
	L["Send"] = "Send"
	L["Send this team to another Rematch user online right now."] = "Send this team to another Rematch user online right now."
	L["Export"] = "Export"
	L["Create a text string you can copy/paste to share teams."] = "Create a text string you can copy/paste to share teams."
	L["Import"] = "Import"
	L["Create a team from a text string created with the Export feature."] = "Create a team from a text string created with the Export feature."
	L["Reload Team"] = "Reload Team"
	L["Unload Team"] = "Unload Team"
	L["Close Rematch"] = "Close Rematch"

-- roster.lua
	L["Battle"] = "Battle"
	L["Quantity"] = "Quantity"
	L["Favorite"] = "Favorite"
	L["Zone"] = "Zone"
	L["Team"] = "Team"
	L["Level"] = "Level"
	L["Filters: \124cffffffff"] = "Filters: \124cffffffff"
	L["Similar, "] = "Similar, "
	L["Search, "] = "Search, "
	L["Type, "] = "Type, "
	L["Strong, "] = "Strong, "
	L["Tough, "] = "Tough, "
	L["Sources, "] = "Sources, "
	L["Rarity, "] = "Rarity, "
	L["Collected, "] = "Collected, "
	L["Sort, "] = "Sort, "

-- save.lua
	L["Team name:"] = "Team name:"
	L["Save for target:"] = "Save for target:"
	L["Save leveling pets as themselves"] = "Save leveling pets as themselves"
	L["Save changes?"] = "Save changes?"
	L["Save As..."] = "Save As..."
	L["Save this team?"] = "Save this team?"
	L["Noteworthy Targets"] = "Noteworthy Targets"
	L["The team must be named before it can be saved."] = "The team must be named before it can be saved."
	L["Confirm you want to overwrite the team already saved for %s."] = "Confirm you want to overwrite the team already saved for %s."
	L["Confirm you want to overwrite the team already named \124cffffd200%s\124r."] = "Confirm you want to overwrite the team already named \124cffffd200%s\124r."
	L["Save changes to this team."] = "Save changes to this team."
	L["Save changes to the loaded team."] = "Save changes to the loaded team."
	L["Create a new team for %s."] = "Create a new team for %s."
	L["Create a new team named \124cffffd200%s\124r."] = "Create a new team named \124cffffd200%s\124r."
	L["Overwrite this team?"] = "Overwrite this team?"
	L["Save as a new team."] = "Save as a new team."
	L["Overwrite existing team."] = "Overwrite existing team."
	L["This target already has a team."] = "This target already has a team."
	L["A team already has this name."] = "A team already has this name."
	L["Press CTRL+C to copy this team to the clipboard."] = "Press CTRL+C to copy this team to the clipboard."
	L["Import Team"] = "Import Team"
	L["Press CTRL+V to paste a team from the clipboard."] = "Press CTRL+V to paste a team from the clipboard."
	L["Import As..."] = "Import As..."
	L["Send this team?"] = "Send this team?"
	L["Who would you like to send this team to?"] = "Who would you like to send this team to?"
	L["Team received!"] = "Team received!"
	L["Sending..."] = "Sending..."
	L["No response. Lag or no Rematch?"] = "No response. Lag or no Rematch?"
	L["They do not appear to be online."] = "They do not appear to be online."
	L["They're busy. Try again later."] = "They're busy. Try again later."
	L["They're in combat. Try again later."] = "They're in combat. Try again later."
	L["They have team sharing disabled."] = "They have team sharing disabled."
	L["Incoming Rematch Team"] = "Incoming Rematch Team"
	L["\124cffffd200%s\124r has sent you a team for %s."] = "\124cffffd200%s\124r has sent you a team for %s."
	L["\124cffffd200%s\124r has sent you a team named \124cffffd200%s\124r."] = "\124cffffd200%s\124r has sent you a team named \124cffffd200%s\124r."

-- sideline.lua
	L["New Team"] = "New Team"
	L["\124cffffd200%s\124r saved to \124T%s:14\124t%s"] = "\124cffffd200%s\124r saved to \124T%s:14\124t%s"

-- teams.lua
	L["New Tab"] = "New Tab"
	L["Move to \124T%s:16\124t%s"] = "Move to \124T%s:16\124t%s"
	L["Create a new tab."] = "Create a new tab."
	L["Choose a name and icon."] = "Choose a name and icon."
	L["Delete this tab?"] = "Delete this tab?"
	L["Teams in this tab will be moved to the General tab."] = "Teams in this tab will be moved to the General tab."
	L["Load this team?"] = "Load this team?"
	L["%s \124cffffd200moved to\124r \124T%s:14\124t %s"] = "%s \124cffffd200moved to\124r \124T%s:14\124t %s"
	L["Team Target"] = "Team Target"
	L["Import"] = "Import"

end
