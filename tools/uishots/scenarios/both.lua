startAddon({ [4949] = 111, [3230] = 222 })
SlashCmdList.WARCRAFTLORE("list")
MOCK.click(rowFor("Thrall"))
MOCK.dump(SHOTDIR .. "/both.json")