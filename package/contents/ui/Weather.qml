import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

Item {
  property var backgroundImages: {
    "UNKOWN": Qt.resolvedUrl("../images/backgrounds/WIND.webp"),
    "CLEAR_DAY": Qt.resolvedUrl("../images/backgrounds/CLEAR_DAY.webp"),
    "CLEAR_NIGHT": Qt.resolvedUrl("../images/backgrounds/CLEAR_NIGHT.webp"),
    "PARTLY_CLOUDY_DAY": Qt.resolvedUrl("../images/backgrounds/PARTLY_CLOUDY_DAY.webp"),
    "PARTLY_CLOUDY_NIGHT": Qt.resolvedUrl("../images/backgrounds/PARTLY_CLOUDY_NIGHT.webp"),
    "CLOUDY": Qt.resolvedUrl("../images/backgrounds/CLOUDY.webp"),
    "LIGHT_HAZE": Qt.resolvedUrl("../images/backgrounds/HAZEY.webp"),
    "MODERATE_HAZE": Qt.resolvedUrl("../images/backgrounds/HAZEY.webp"),
    "HEAVY_HAZE": Qt.resolvedUrl("../images/backgrounds/HAZEY.webp"),
    "LIGHT_RAIN": Qt.resolvedUrl("../images/backgrounds/RAINY.webp"),
    "MODERATE_RAIN": Qt.resolvedUrl("../images/backgrounds/RAINY.webp"),
    "HEAVY_RAIN": Qt.resolvedUrl("../images/backgrounds/RAINY.webp"),
    "STORM_RAIN": Qt.resolvedUrl("../images/backgrounds/STORM.webp"),
    "FOG": Qt.resolvedUrl("../images/backgrounds/CLOUDY.webp"),
    "LIGHT_SNOW": Qt.resolvedUrl("../images/backgrounds/SNOWY.webp"),
    "MODERATE_SNOW": Qt.resolvedUrl("../images/backgrounds/SNOWY.webp"),
    "HEAVY_SNOW": Qt.resolvedUrl("../images/backgrounds/SNOWY.webp"),
    "STORM_SNOW": Qt.resolvedUrl("../images/backgrounds/SNOWY.webp"),
    "DUST": Qt.resolvedUrl("../images/backgrounds/HAZEY.webp"),
    "SAND": Qt.resolvedUrl("../images/backgrounds/HAZEY.webp"),
    "WIND": Qt.resolvedUrl("../images/backgrounds/WIND.webp")
  }

  property var skyconImages: {
    "UNKOWN": Qt.resolvedUrl("../images/skycons/sunny.svg"),
    "CLEAR_DAY": Qt.resolvedUrl("../images/skycons/sunny.svg"),
    "CLEAR_NIGHT": Qt.resolvedUrl("../images/skycons/sunny.svg"),
    "PARTLY_CLOUDY_DAY": Qt.resolvedUrl("../images/skycons/cloudy.svg"),
    "PARTLY_CLOUDY_NIGHT": Qt.resolvedUrl("../images/skycons/cloudy.svg"),
    "CLOUDY": Qt.resolvedUrl("../images/skycons/cloudy.svg"),
    "OVERCAST": Qt.resolvedUrl("../images/skycons/overcast.svg"),
    "LIGHT_HAZE": Qt.resolvedUrl("../images/skycons/haze.svg"),
    "MODERATE_HAZE": Qt.resolvedUrl("../images/skycons/haze.svg"),
    "HEAVY_HAZE": Qt.resolvedUrl("../images/skycons/haze.svg"),
    "LIGHT_RAIN": Qt.resolvedUrl("../images/skycons/rainy.svg"),
    "MODERATE_RAIN": Qt.resolvedUrl("../images/skycons/rainy.svg"),
    "HEAVY_RAIN": Qt.resolvedUrl("../images/skycons/rainy.svg"),
    "STORM_RAIN": Qt.resolvedUrl("images/skycons/rainy.svg"),
    "FOG": Qt.resolvedUrl("../images/skycons/haze.svg"),
    "LIGHT_SNOW": Qt.resolvedUrl("../images/skycons/snowy.svg"),
    "MODERATE_SNOW": Qt.resolvedUrl("../images/skycons/snowy.svg"),
    "HEAVY_SNOW": Qt.resolvedUrl("../images/skycons/snowy.svg"),
    "STORM_SNOW": Qt.resolvedUrl("../images/skycons/snowy.svg"),
    "DUST": Qt.resolvedUrl("../images/skycons/haze.svg"),
    "SAND": Qt.resolvedUrl("../images/skycons/haze.svg"),
    "WIND": Qt.resolvedUrl("../images/skycons/windy.svg")
  }

  property var statusList: {
    "UNKOWN": "--",
    "CLEAR_DAY": i18nc("Status CLEAR_DAY", "Clear"),
    "CLEAR_NIGHT": i18nc("Status CLEAR_NIGHT", "Clear"),
    "PARTLY_CLOUDY_DAY": i18nc("Status PARTLY_CLOUDY_DAY", "Partly Cloud"),
    "PARTLY_CLOUDY_NIGHT": i18nc("Status PARTLY_CLOUDY_NIGHT", "Partly Cloud"),
    "CLOUDY": i18nc("Status CLOUDY", "Cloudy"),
    "LIGHT_HAZE": i18nc("Status LIGHT_HAZE", "Light Haze"),
    "MODERATE_HAZE": i18nc("Status MODERATE_HAZE", "Moderate Haze"),
    "HEAVY_HAZE": i18nc("Status HEAVY_HAZE", "Heavy Haze"),
    "LIGHT_RAIN": i18nc("Status LIGHT_RAIN", "Light Rain"),
    "MODERATE_RAIN": i18nc("Status MODERATE_RAIN", "Moderate Rain"),
    "HEAVY_RAIN": i18nc("Status HEAVY_RAIN", "Heavy Rain"),
    "STORM_RAIN": i18nc("Status STORM_RAIN", "Storm Rain"),
    "FOG": i18nc("Status FOG", "Foggy"),
    "LIGHT_SNOW": i18nc("Status LIGHT_SNOW", "Light Snow"),
    "MODERATE_SNOW": i18nc("Status MODERATE_SNOW", "Moderate Snow"),
    "HEAVY_SNOW": i18nc("Status HEAVY_SNOW", "Heavy Snow"),
    "STORM_SNOW": i18nc("Status STORM_SNOW", "Storm Snow"),
    "DUST": i18nc("Status DUST", "Dusty"),
    "SAND": i18nc("Status SAND", "Sand"),
    "WIND": i18nc("Status WIND", "Windy")
  }

  property string scriptPath: Plasmoid.configuration.Command

  property string currentTemperature: "--°"
  property string currentRange: "H: --° L: --°"
  property string currentStatus: "UNKOWN"
  property string currentCity: Plasmoid.configuration.City
  property string weatherSource: "Weather7"
  property string updateTime: i18nc("Updated at --:--", "Updated at --:--")
  property var forecastList: [
    { time: "-- AM", high: "--°", low: "--°", status: "CLOUDY" },
    { time: "-- AM", high: "--°", low: "--°", status: "CLOUDY" },
    { time: "-- PM", high: "--°", low: "--°", status: "WIND" }
  ]


  Plasma5Support.DataSource {
    id: executable
    engine: "executable"
    connectedSources: []
    onNewData: function(source, data) {
      var result = data.stdout.trim()
      // console.log("Data received:", result)
      parseWeatherData(result)
      executable.disconnectSource(source)
    }
  }

  function parseWeatherData(result) {
    try {
      var json = JSON.parse(result)

      currentTemperature = Math.round(json.result.realtime.temperature) + "°"
      currentStatus = json.result.realtime.skycon

      var daily = json.result.daily.temperature[0]
      currentRange = "H: " + Math.round(daily.max) + "° L:" + Math.round(daily.min) + "°"

      var temps = json.result.hourly.temperature
      var skycons = json.result.hourly.skycon
      var forecast = []
      for (var i = 0; i < 3; ++i) {
        var hour = temps[i]
        var sky = skycons[i]
        var time = formatHourAMPM(hour.datetime)
        forecast.push({
          time: time,
          high: Math.round(hour.value) + "°",
          low: Math.round(hour.value) - 1 + "°", // fake it empty
          status: sky.value
        })
      }
      forecastList = forecast

      updateTime = formatUpdateTime()
    } catch (e) {
      console.log("JSON parse error:", e)
    }
  }

  function updateWeather() {
    executable.connectSource(scriptPath)
  }

  function formatHourAMPM(datetime) {
    var dateObj = new Date(datetime)
    var hours = dateObj.getHours()
    var ampm = hours >= 12 ? "PM" : "AM"
    var displayHour = hours % 12
    if (displayHour === 0) displayHour = 12
    return displayHour + " " + ampm
  }

  function formatUpdateTime() {
    var now = new Date()
    var hh = now.getHours()
    var mm = now.getMinutes()
    if (hh < 10) hh = "0" + hh
    if (mm < 10) mm = "0" + mm
    return i18np("Updated at %1:" + "%2", "Updated at %1:" + "%2", hh, mm)
  }

  onScriptPathChanged: {
    updateWeather()
  }
} 
