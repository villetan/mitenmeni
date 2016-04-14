Geocoder.configure(

    # geocoding service (see below for supported options):
    :lookup => :google,

    # IP address geocoding service (see below for supported options):
    :ip_lookup => :ipinfo_io,

    # to use an API key:
    #:api_key => ENV["GMAPS_KEY"],

    # geocoding service request timeout, in seconds (default 3):
    :timeout => 10,

    # set default units to kilometers:
    :units => :km,



)