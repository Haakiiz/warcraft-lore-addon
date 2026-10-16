startAddon({ [4949] = 111, [3230] = 222 })
SlashCmdList.WARCRAFTLORE("list")
MOCK.click(btnWithText("Show "))   -- Met only: Thrall and Nazgrel
hover(rowFor("Thrall"))
MOCK.dump(SHOTDIR .. "/browser_tip.json")
