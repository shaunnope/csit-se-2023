class Hotel
    include Mongoid::Document

    field :city, type: String
    field :hotelName, type: String
    field :price, type: Integer
    field :date, type: Date

end