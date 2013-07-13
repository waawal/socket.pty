exports.module = io = require('socket.io').listen Number(process.env.PORT) or 8080
pty = require 'pty.js'

io.configure ->
  io.disable 'log', 'browser client', 'match origin protocol'

io.sockets.on 'connection', (client) ->

  terminal = pty.fork process.env.SHELL or 'sh', [],
    name: 'xterm'
    cols: 80
    rows: 24
    cwd: process.env.HOME

  # Sending data to the client.
  terminal.on 'data', (data) ->
    client.emit 'data', data

  terminal.on 'exit', ->
    client.disconnect()

  # Processing data from the client.
  client.on 'data', (data) ->
    terminal.write data

  client.on 'disconnect', ->
    terminal.destroy()