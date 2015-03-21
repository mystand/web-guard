path = require "path"
fs = require "fs"

# мне было лень разбираться с монгой, так что встречаем мою СУБД)))
class Storage
  constructor: (filename = "db")->
    @path = path.join(__dirname, '../db', "#{filename}.json")
    try
      JSON.parse(fs.readFileSync @path)
    catch
      fs.writeFileSync @path, "{}"

  set: (key, value) =>
    data = fs.readFileSync @path
    db = JSON.parse data
    db[key] = value
    fs.writeFileSync @path, JSON.stringify(db)

  push: (key, obj) =>
    data = fs.readFileSync @path
    db = JSON.parse data
    db[key] = [] unless db[key]
    db[key].push obj
    fs.writeFileSync @path, JSON.stringify(db)

  get: (key) =>
    data = fs.readFileSync @path
    db = JSON.parse data
    if key
      db[key]
    else
      db

  json: =>
    fs.readFileSync @path

module.exports = new Storage()