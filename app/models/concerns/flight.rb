class Flight
    include Mongoid::Document

    field :airline, type: String
    field :airlineid, type: Integer
    field :srcairport, type: String
    field :srcairportid, type: Integer
    field :destairport, type: String
    field :destairportid, type: Integer

    field :codeshare, type: String

    field :stop, type: Integer
    field :eq, type: String
    field :airlinename, type: String
    field :srcairportname, type: String
    field :srccity, type: String
    field :srccountry, type: String

    field :destairportname, type: String
    field :destcity, type: String
    field :destcountry, type: String

    field :price, type: Integer
    field :date, type: Date

end