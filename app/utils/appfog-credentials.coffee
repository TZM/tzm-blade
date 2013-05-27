getAppFogCredentials = (service_type) ->
  json = JSON.parse(process.env.VCAP_SERVICES)
  json[service_type][0]["credentials"]