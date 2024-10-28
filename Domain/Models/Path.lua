Path = {}

---comment
---@param Path table
---@param PathName string
---@param InProgress boolean
---@return table
function Path:new(Path, PathName, InProgress)
    local object = {}
    object.Path = Path
    object.Name = PathName
    object.InProgress = InProgress

    setmetatable(object, self)
    self.__index = self
    return object
end