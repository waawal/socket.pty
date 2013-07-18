exports.module = io = require('socket.io').listen Number(process.env.PORT) or 8888
ptyjs = require 'pty.js'

io.configure ->
  io.disable 'logging', 'match origin protocol'
  io.set('close timeout', 10)

io.sockets.on 'connection', (client) ->
  unless client.pty
    client.pty = ptyjs.fork 'docker', ['run', '-i', '-t', '-m=4194304', 'waawal/browser'],
      rows: 24
      cols: 80
      name: 'xterm'
      cwd: process.env.HOME

    # Sending data to the client.
    client.pty.on 'data', (data) ->
      client.emit 'data', data

    client.pty.on 'exit', ->
      client.disconnect()

    # Processing data from the client.
    client.on 'data', (data) ->
      client.pty.write data

    client.on 'disconnect', ->
      client.pty.end('\u0004')
      client.pty.destroy()