module Validator
    def valid_date?(date)
        (date =~ /^\d{4}-\d{2}-\d{2}$/ || false) && Date.parse(date)
    rescue Date::Error
        false
    end
end