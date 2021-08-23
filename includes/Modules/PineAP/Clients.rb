module M_Clients

    def connected_clients()
        response = self.call(
            'GET',
            'pineap/clients',
            '',
            '[{'
        )
        return(
            (response === "null\r\n") ? [] : response
        )
    end

    def kick(mac)
        self.call(
            'DELETE',
            'pineap/clients/kick',
            {
                "mac" => mac
            },
            '{"success":true}'
        )
    end

    def clear_previous()

        previousClients = self.call(
            'GET',
            'pineap/previousclients',
            '',
            '[{'
        )

        (previousClients === "null\r\n" ? [] : previousClients).each do |previous|

            self.call(
                'DELETE',
                'pineap/previousclients/remove',
                {
                    "mac" => previous.mac
                },
                '{"success":true}'
            )

        end

        return(true)

    end
    
end