require 'socket'               # Get sockets from stdlib

server = TCPServer.open(2000)  # Socket to listen on port 2000

loop do                        # Servers run forever
  client = server.accept       # Wait for a client to connect
  request = client.read_nonblock(256)

  header, body = request.split("\r\n\r\n", 2)
  method = header.split[0]
  fname = header.split[1][0..-1]

  if File.exist?(fname)
    body = File.read(fname)
    client.puts("HTTP/1.0 200 OK\r\n\r\n")

    if method == 'GET'
      client.puts(body)
    end
  else
    client.puts("HTTP/1.0 404 Not Found\r\n\r\n")
    client.puts('You messed up.')
  end
  client.close                 # Disconnect from the client
end
