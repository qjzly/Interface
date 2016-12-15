local GNOME, Sequences = ...
local modversion = GetAddOnMetadata(GNOME, "Version")
local GSHP = LibStub("AceAddon-3.0"):NewAddon("GSHP", "AceEvent-3.0")
GSWLMHPOptions = {}
GSWLMHPOptions.warnupdate = false
GSWLMHPOptions.currentversion = modversion



for k,_ in pairs(Sequences) do
  if GSisEmpty(Sequences[k].source) then
    Sequences[k].source = GNOME
  end
  if GSisEmpty(Sequences[k].authorversion) then
    Sequences[k].authorversion = modversion
  end
end

GSImportMacroCollection(Sequences)

local function processAddonLoaded()
  for k,_ in pairs(Sequences) do
    if GSMasterOptions.SequenceLibrary[k][GSGetActiveSequenceVersion(k)].source ~= GNOME then
      GSPrint("You have made edits to " .. k .. ".  If you have updated ".. GNOME .. " recently, there may be updates to version 1 of this macro.", GNOME)
    end
  end
  if GSWLMHPOptions.currentversion ~= modversion  then
    GSPrint("The HP Macros mod has been updated.  The following Macros may have been updated.  Please check your talents still match and any local modifications.", GNOME)
    for k,_ in pairs(KnownSequences) do
      GSPrint("  - ".. k, GNOME)
    end
    GSWLMHPOptions.currentversion = modversion
  end

end

GSHP:RegisterMessage(GSStaticCoreLoadedMessage,  processAddonLoaded)
