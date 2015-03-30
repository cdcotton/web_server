require 'socket'               # Get sockets from stdlib
require 'json'

server = TCPServer.open(2000)  # Socket to listen on port 2000

loop do                        # Servers run forever
  client = server.accept       # Wait for a client to connect
  request = client.read_nonblock(256)

  header, body = request.split("\r\n\r\n", 2)
  method = header.split[0]
  path = header.split[1][0..-1]

  if File.exist?(path)
    body = File.read(path)
    client.puts("HTTP/1.0 200 OK\r\n\r\n")
    response = ''

    case method
    when 'GET'
      response = body
    when 'PUSH'
      params = JSON.parse(body)
      template = File.read('thanks.html')
      content = "<li>Name: #{params['viking']['name']}</li>" \
                "<li>Email: #{params['viking']['email']}</li>"
      response = template.sub("<%= yield %>", content)
    end
  else
    client.puts("HTTP/1.0 404 Not Found\r\n\r\n")
    client.puts('You messed up.')
  end

  client.puts(response)

  client.close                 # Disconnect from the client
end
