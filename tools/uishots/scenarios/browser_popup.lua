startAddon({ [4949] = 111, [3230] = 222 })
SlashCmdList.WARCRAFTLORE("list")
MOCK.click(btnWithText("Campaign "))
MOCK.dump(SHOTDIR .. "/browser_popup.json")
