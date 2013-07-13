server = require('http').Server()
io = require('socket.io')(server)
pty = require 'pty.js'

io.configure ->
  io.disable 'log'

io.sockets.on 'connection', (socket) ->

  term = pty.fork process.env.SHELL or 'sh', [],
    name: 'xterm'
    cols: 80
    rows: 24
    cwd: process.env.HOME

  # Sending data to the client.
  term.on 'data', (data) ->
    socket.emit('data', data)

  term.on 'exit', ->
    socket.disconnect()

  # Processing data from the client.
  socket.on 'data', (data) ->
    term.write data

  socket.on 'disconnect', ->
    term.destroy()