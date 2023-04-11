-- Create a httpclient in Lua to send a request to the server
-- and get the response
-- Create a httpclient in Lua to send a request to the server
-- and get the response
local http = require("socket.http")
local ltn12 = require("ltn12")

-- Create the table to store the response
local response_body = {}

-- Create the request
local res, code, response_headers = http.request{
    url = "https://localhost:44321/WeatherForecast",
    method = "GET",
    sink = ltn12.sink.table(response_body),
}

-- Print the response
print(code)
print(table.concat(response_body))