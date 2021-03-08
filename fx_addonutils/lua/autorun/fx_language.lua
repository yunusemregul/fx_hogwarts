fxLanguage = {}

-- I choose this approach because I want to do something interesting not just something casual
-- even tho this is an overkill

function fxLanguage:new(name)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self._name = name and name or "unnamed language library"
    return o
end

function fxLanguage:set(lang)
    assert(lang, "lang expected")
    assert(self[lang], string.format("language called '%s' is not defined in %s language library", lang, self._name))
    self._selectedLang = lang
end

function fxLanguage:add(lang, data)
    assert(lang, "parameter #1 expected")
    assert(data,  "parameter #2 expected")
    if self._selectedLang==nil then self._selectedLang = lang end

    self[lang] = self[lang] or {}
    self[lang] = data
end

function fxLanguage:get(id, ...)
    assert(self._selectedLang, string.format("no language was set on this language library"))
    assert(self[self._selectedLang], string.format("nothing was defined in language '%s' of this language library",self._selectedLang))
    assert(self[self._selectedLang][id], string.format("'%s' was not defined in '%s' language of '%s'", id, self._selectedLang, self._name))

    return string.format(self[self._selectedLang][id], arg)
end