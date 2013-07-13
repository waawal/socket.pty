io = require "socket.io"
pty = require "pty.js"

io = io.listen(server)
io.configure ->
  io.disable "log"

io.sockets.on "connection", (socket) ->
  # New client connected

  term = pty.fork process.env.SHELL or "sh", [],
    name: "xterm"
    cols: 80
    rows: 24
    cwd: process.env.HOME

  term.on "data", (data) ->
    socket.emit("data", data)

  #term.on 'exit', ->
  #  noop

  #console.log "" + "Created shell with pty master/slave" + " pair (master: %d, pid: %d)", term.fd, term.pid


  socket.on "data", (data) ->
    term.write data

  socket.on "disconnect", ->
    term.destroy()