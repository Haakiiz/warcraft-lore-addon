startProgress()
SlashCmdList.WARCRAFTLORE("list")
MOCK.click(btnWithText("Memorials"))
MOCK.dump(SHOTDIR .. "/m_memorials.json")
