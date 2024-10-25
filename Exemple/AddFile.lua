function ajouterFile(sourceFile,added_lignes)
    local file = io.open(sourceFile,'r')
    local file_temp_name = path_acc.."temporary"..instance_number
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    for _,line in ipairs(added_lignes) do
        table.insert(lines,line)
    end
    local out = io.open(file_temp_name,"w")
    for _, line in ipairs(lines) do
        out:write(line..'\n')
    end
    out:close()
    os.remove(sourceFile)
    os.rename(file_temp_name,sourceFile)
end