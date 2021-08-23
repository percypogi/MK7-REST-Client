module M_Activity

    public def output()
        response = self.call(
            'GET',
            'logging/pineap',
            '',
            '[{'
        )
        return (
            (response === "null\r\n") ? [] : response
        )
    end

    public def clear()
        self.call(
            'DELETE',
            'logging/pineap',
            '',
            '{"success":true}'
        )
    end

end