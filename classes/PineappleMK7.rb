require('json')
require('net/ssh')
require('fileutils')
require('rest-client')
include(RestClient)

## HELPERS

# Downloader helper
#
require_relative('../includes/Helpers/Downloader.rb')

# Requester helper
#
require_relative('../includes/Helpers/Requester.rb')

## MODULES

# Dashboard module
#
require_relative('../includes/Modules/Dashboard/Notifications.rb')

# Logging module
#
require_relative('../includes/Modules/Logging/Activity.rb')

# PineAP modules
#
require_relative('../includes/Modules/PineAP/Clients.rb')
require_relative('../includes/Modules/PineAP/Filtering.rb')
require_relative('../includes/Modules/PineAP/Settings.rb')

# Recon modules
#
require_relative('../includes/Modules/Recon/Handshakes.rb')
require_relative('../includes/Modules/Recon/Scanning.rb')

# System modules
#
require_relative('../includes/System/Authentication.rb')
require_relative('../includes/System/LED.rb')

module PineappleMK7

    class Modules

        class Dashboard

            class Notifications
                include(Requester)
                include(M_Notifications)
            end

        end

        class Logging

            class Activity
                include(Requester)
                include(M_Activity)
            end

        end

        class PineAP

            class Clients
                include(Requester)
                include(M_Clients)
            end

            class Filtering
                include(Requester)
                include(M_Filtering)
            end

            class Settings
                attr_accessor(
                    :enablePineAP, 
                    :autostartPineAP, 
                    :armedPineAP, 
                    :ap_channel,
                    :karma,
                    :logging,
                    :connect_notifications,
                    :disconnect_notifications,
                    :capture_ssids,
                    :beacon_responses,
                    :broadcast_ssid_pool,
                    :pineap_mac,
                    :target_mac,
                    :beacon_response_interval,
                    :beacon_interval
                )
                include(Requester)
                include(M_Settings)
            end

        end

        class Recon

            class Handshakes
                include(Requester)
                include(Downloader)
                include(M_Handshakes)
            end

            class Scanning
                include(Requester)
                include(M_Scanning)
            end

        end

    end

    class System

        class Authentication
            attr_accessor(:host, :port, :mac)
            attr_writer(:password)
            include(M_Authentication)
        end

        class LED
            include(M_LED)
        end

    end

end