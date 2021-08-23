module M_Handshakes

    public def start(ap)
        self.call(
            'POST',
            'pineap/handshakes/start',
            ap.to_h,
            '{"success":true}'
        )
    end

    public def stop()
        self.call(
            'POST',
            'pineap/handshakes/stop',
            '',
            '{"success":true}'
        )
    end

    public def output()
        response = self.call(
            'GET',
            'pineap/handshakes',
            '',
            '{"handshakes":'
        )
        response.handshakes = (response.handshakes.nil? ? [] : response.handshakes)
        return(response)
    end

    public def download(handshake, destination)
        self.fetch(
            (handshake.location + handshake.mac + '_' + handshake.type + '.' + handshake.extension),
            (destination + 'handshakes/' + Time.now.to_i.to_s + '/')
        )
    end

    public def clear()
        self.output.handshakes.each do |handshake|
            self.call(
                'DELETE',
                'pineap/handshakes/delete',
                handshake.to_h,
                '{"success":true}'
            )
        end
    end

end