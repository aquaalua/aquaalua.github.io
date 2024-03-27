--[[
  
  This used in script to use for
  files, search and others, this is
  open source you can use this.

  Sample usage!

  ```
  local plugin = load(gg.makeRequest('https://aquaalua.github.io/src/plugin.lua').content)()
  plugin:notify({text="sample"})
  ```

]]--

local plugin = {}

function plugin:notify(tab)
    gg.toast(tab.text)
end

function plugin:alert(tab)
    gg.alert(tab.text, tab.option)
end

function plugin:sleep(tab)
    gg.sleep(tab.time)
end

function plugin:read(tab)
    local system = io.open(tab.path, "r")
    if system then
        local content = system:read("*a")
        system:close()
        return content
    else
        plugin:notify("Failed to read content, try again!")
    end
end

function plugin:write(tab)
    local system = io.open(tab.path, "w")
    if system then
        system:write(tab.content)
        system:close()
    else
        plugin:notify("Failed to write content, try again!")
    end
end

function plugin:append(tab)
    local system = io.open(tab.path, "a")
    if system then
        system:write(tab.content)
        system:close()
    else
        plugin:notify("Failed to append content, try again!")
    end
end

function plugin:search(tab)
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(tab.range)
    gg.searchNumber(tab.search, tab.memory)
    gg.getResults(gg.getResultsCount())
    gg.editAll(tab.change, tab.memory)
    gg.clearResults()
end

function plugin:refine(tab)
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(tab.range)
    gg.searchNumber(tab.search, tab.memory)
    gg.getResults(gg.getResultsCount())
    gg.refineNumber(tab.short, tab.memory)
    gg.getResults(gg.getResultsCount())
    gg.editAll(tab.change, tab.memory)
    gg.clearResults()
end

function plugin:address(isrefine, tab)
    if isrefine == true then
        gg.clearResults()
        gg.setRanges(tab.range)
        gg.setVisible(false)
        gg.searchNumber(tab.search, tab.memory)
        gg.getResults(gg.getResultsCount())
        gg.refineNumber(tab.short, tab.memory)
        local onResult = gg.getResults(gg.getResultsCount())
        for i,v in pairs(onResult) do
            onResult[i].address = onResult[i].address + tab.value
            onResult[i].flags = tab.flags
            onResult[i].value = tab.change
            onResult[i].freeze = false
            gg.setValues(onResult)
            gg.addListItems(onResult)
            gg.removeListItems(gg.getListItems())
            gg.clearResults()
        end
    else
        gg.clearResults()
        gg.setRanges(tab.range)
        gg.setVisible(false)
        gg.searchNumber(tab.search, tab.memory)
        local onResult = gg.getResults(gg.getResultsCount())
        for i,v in pairs(onResult) do
            onResult[i].address = onResult[i].address + tab.value
            onResult[i].flags = tab.flags
            onResult[i].value = tab.change
            onResult[i].freeze = false
            gg.setValues(onResult)
            gg.addListItems(onResult)
            gg.removeListItems(gg.getListItems())
            gg.clearResults()
        end
    end
end

return plugin
