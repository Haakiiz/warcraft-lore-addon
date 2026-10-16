// Usage: node run.js <addonDir> <scenario.lua>
const fs = require("fs");
const path = require("path");
const { lua, lauxlib, lualib, to_luastring, to_jsstring } = require("fengari");

const [addonDir, ...scenarios] = process.argv.slice(2);
const L = lauxlib.luaL_newstate();
lualib.luaL_openlibs(L);

function fail(where) {
  console.error("ERROR in " + where + ": " + to_jsstring(lua.lua_tostring(L, -1)));
  process.exit(1);
}
function runFile(file, args) {
  const src = fs.readFileSync(file);
  if (lauxlib.luaL_loadbuffer(L, src, null, to_luastring("@" + path.basename(file))) !== 0) fail(file + " (compile)");
  for (const a of args) a();
  if (lua.lua_pcall(L, args.length, 0, 0) !== 0) fail(file);
}

// __writefile(path, content): lets scenarios write dump files (fengari has no usable io).
lua.lua_pushjsfunction(L, function (L) {
  fs.mkdirSync(path.dirname(to_jsstring(lua.lua_tostring(L, 1))), { recursive: true });
  fs.writeFileSync(to_jsstring(lua.lua_tostring(L, 1)), Buffer.from(lua.lua_tostring(L, 2)));
  return 0;
});
lua.lua_setglobal(L, to_luastring("__writefile"));
runFile(path.join(__dirname, "widths.lua"), []);
runFile(path.join(__dirname, "wowmock.lua"), []);
// Shared addon namespace table, kept in the registry-ish global __NS.
runFile(path.join(__dirname, "pre.lua"), []);

const toc = fs.readFileSync(path.join(addonDir, "WarcraftLore.toc"), "utf8");
const files = toc.split(/\r?\n/).map(s => s.trim()).filter(s => s && !s.startsWith("#"));
console.log("TOC: " + files.join(", "));
for (const f of files) {
  runFile(path.join(addonDir, f), [
    () => lua.lua_pushstring(L, to_luastring("WarcraftLore")),
    () => lua.lua_getglobal(L, to_luastring("__NS")),
  ]);
}
lua.lua_pushstring(L, to_luastring(path.join(__dirname, "shots").replace(/\\/g, "/")));
lua.lua_setglobal(L, to_luastring("SHOTDIR"));
for (const s of scenarios) runFile(s, []);

