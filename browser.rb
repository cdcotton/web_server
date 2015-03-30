require 'socket'
require 'json'

host = 'localhost'                  # The web server
port = 2000                         # Default HTTP port

def get_request
  print 'What type of request would you like to send: ' \
        "'GET' or 'PUSH'?: "
  method = gets.chomp.upcase
  print 'Path: '
  path = gets.chomp

  case method
  when 'GET'
    return request = "GET #{path} HTTP/1.0\r\n\r\n"
  when 'POST'
    print 'Name: '
    name = gets.chomp
    print 'Email: '
    email = gets.chomp

    body = {:viking => {:name => name, :email => email}}.to_json

    return request = "POST #{path} HTTP/1.0\r\n" \
              "Content-Type: text/json\r\n" \
              "Content-Length: #{body}.size\r\n\r\n#{body}"
  end
end

request = get_request

socket = TCPSocket.open(host, port) # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers, body = response.split("\r\n\r\n", 2)
puts body                           # And display it

socket.close
