module M_Scanning

    # WPA3 missing
    PROTOCOLS_FLAGS = {
        'WPA' => 0x01,
        'WPA2' => 0x02,
        'WEP' => 0x04
    }

    # WEP AKMS missing
    # WPA3 AKMS missing
    AKMS_FLAGS = {
        'WPA_AKM_PSK' => 0x800,
        'WPA_AKM_ENTERPRISE' => 0x1000,
        'WPA_AKM_ENTERPRISE_FT' => 0x2000,
        'WPA2_AKM_PSK' => 0x4000,
        'WPA2_AKM_ENTERPRISE' => 0x8000,
        'WPA2_AKM_ENTERPRISE_FT' => 0x10000
    }

    # WEP PAIRWISES missing
    # WPA3 PAIRWISES missing
    PAIRWISES_FLAGS = {
        'WPA_PAIRWISE_WEP40' => 0x08,
        'WPA_PAIRWISE_WEP104' => 0x10,
        'WPA_PAIRWISE_TKIP' => 0x20,
        'WPA_PAIRWISE_CCMP' => 0x40,
        'WPA2_PAIRWISE_WEP40' => 0x80,
        'WPA2_PAIRWISE_WEP104' => 0x100,
        'WPA2_PAIRWISE_TKIP' => 0x200,
        'WPA2_PAIRWISE_CCMP' => 0x400
    }

    private def convert_encryption(encryption)

        protocols = []
        PROTOCOLS_FLAGS.each do |key, value|
            if ( ((encryption & value) != 0) )
                protocols << key
            end
        end

        akms = []
        AKMS_FLAGS.each do |key, value|
            if ( ((encryption & value) != 0) )
                akms << key
            end
        end

        pairwises = []
        PAIRWISES_FLAGS.each do |key, value|
            if ( ((encryption & value) != 0) )
                pairwises << key
            end
        end

        encryption = ""
        if (!protocols.empty?())
            encryption += (protocols.join('/') + ' ')
            encryption += (akms.map { |akm| akm.gsub(Regexp.new('(?:'+protocols.join('|')+')_AKM_'), '') }.uniq.join + ' ')
            encryption += ('(' + pairwises.map { |pairwise| pairwise.gsub(Regexp.new('(?:'+protocols.join('|')+')_PAIRWISE_'), '') }.uniq.join(' ') + ')')
        else
            encryption = "Open"
        end

        return(encryption)
        
    end

    public def start(scan_time)
        response = self.call(
            'POST',
            'recon/start',
            {
                "live" => false,
                "scan_time" => (scan_time === 0) ? 30 : scan_time,
                "band" => "0"
            },
            '{"scanRunning":true,"scanID":'   
        )
        sleep(scan_time + 10)
        return(response)
    end

    public def output(scanID)
        response = self.call(
            'GET',
            ('recon/scans/' + scanID.to_s()),
            '',
            '{"APResults":['
        )
        response.APResults = (response.APResults.nil? ? [] : response.APResults)
        response.APResults.each do |ap|
            ap.encryption = self.convert_encryption(ap.encryption)
        end
        response.UnassociatedClientResults = (response.UnassociatedClientResults.nil? ? [] : response.UnassociatedClientResults)
        response.OutOfRangeClientResults = (response.OutOfRangeClientResults.nil? ? [] : response.OutOfRangeClientResults)
        return(response)
    end

    public def deauth_ap(ap)

        clients_mac = []
        ap.clients.each do |client|
            clients_mac << client.client_mac
        end

        self.call(
            'POST',
            'pineap/deauth/ap',
            {
                "bssid" => ap.bssid,
                "multiplier" => 7,
                "channel" => ap.channel,
                "clients" => clients_mac
            },
            '{"success":true}'
        )

    end

    public def delete(scanID)
        self.call(
            'DELETE',
            ('recon/scans/' + scanID.to_s()),
            '',
            '{"success":true}'
        )
    end

end