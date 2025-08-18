function Linemode:size_and_mtime()
  local time = math.floor(self._file.cha.modified or 0)
  if time == 0 then
    time = ""
  elseif os.date("%Y", time) == os.date("%Y") then
    time = os.date("%d %b %H:%M", time)
  else
    time = os.date("%d %b %Y", time)
  end

  local size = self._file:size()
  return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "-", time))
end

function Linemode:permis_and_owner()
  -- !!!!!!!!!!! I framtiden kommer den til at hedde "self._file.cha:perm()" !!!!!!!!!!!!!!
  local permissions = self._file.cha:permissions() or ""
  local user = self._file.cha.uid and ya.user_name(self._file.cha.uid) or self._file.cha.uid
  local group = self._file.cha.gid and ya.group_name(self._file.cha.gid) or self._file.cha.gid
  return ui.Line(string.format("%s - %s:%s", permissions or "-", user or "-", group or "-"))
end

require("session"):setup {
  sync_yanked = true,
}
