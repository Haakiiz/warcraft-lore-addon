startAddon({ [4949] = 111 })
MOCK.units.target = { guid = "Creature-0-1-2-3-4949-0001", name = "Thrall" }
SlashCmdList.WARCRAFTLORE("")
MOCK.dump(SHOTDIR .. "/lore.json")
