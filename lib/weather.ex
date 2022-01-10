defmodule Weather do
  def askForCity do
    city = String.replace(IO.gets("Where are you? >_ "), "\n", "")

    IO.puts "Fine. We're retrieving the requested information for #{city}. Hold on."
    HTTPoison.start

    current_weather = HTTPoison.get! "https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=78e3dba73c17f8dde5e60203118aa72f"
    Poison.decode!(current_weather.body) |> askForOption
    # IO.puts("Weather is: #{json_response["weather"] |> Enum.at(0) |> Map.get("description")}")
  end

  def askForOption(json_response) do
    option = String.replace(IO.gets("Select desired information
    [1] Wind
    [2] Sky
    [3] Temp
    [4] Exit
    >_
    "), "\n", "")

    case option do
      "1" ->
        "#{json_response["wind"]["speed"]} KM/h from #{json_response["wind"]["deg"]}°" |>  IO.puts
      "2" ->
        "The sky is #{json_response["weather"] |> Enum.at(0) |> Map.get("description")}" |> IO.puts
      "3" ->
       "#{json_response["main"]["temp"]} (#{json_response["main"]["feels_like"]})" |> IO.puts
      "4" ->
        IO.puts("Bye bye...")
        Process.exit(self, :normal)
       _ ->
        IO.puts("Invalid option...")
    end

    askForOption(json_response)
  end
end
