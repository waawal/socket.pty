io = require("socket.io")
pty = require("pty.js")

###
Sockets
###
io = io.listen(server)
io.configure ->
  io.disable "log"

io.sockets.on "connection", (socket) ->
# New client connected

  buff = []
  term = pty.fork process.env.SHELL or "sh", [],
    name: "xterm"
    cols: 80
    rows: 24
    cwd: process.env.HOME

  term.on "data", (data) ->
    (if not socket then buff.push(data) else socket.emit("data", data))

  #term.on 'exit', ->
  #  noop

  #console.log "" + "Created shell with pty master/slave" + " pair (master: %d, pid: %d)", term.fd, term.pid


  socket.on "data", (data) ->
    term.write data

  socket.on "disconnect", ->
    term.destroy()

  socket.emit "data", buff.shift() while buff.length

  
