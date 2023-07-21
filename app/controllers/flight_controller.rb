class FlightController < ApplicationController
    include Validator

    def index
        departureDate = valid_date?(params[:departureDate])
        returnDate = valid_date?(params[:returnDate])
        destination = params[:destination]
        missing = %w(departureDate returnDate destination).select { |param| params[param].nil? }
        if missing.length > 0
            render json: {
                    error: "Missing query parameters", 
                    status: 400,
                    missing: missing
                }, status: :bad_request
            return
        elsif !departureDate || !returnDate
            render json: {
                    error: "Invalid date format", 
                    status: 400,
                    departureDate: departureDate,
                    returnDate: returnDate
                }, status: :bad_request
            return
        end

        origin = "Singapore"

        to_flights = Flight.collection.aggregate([
            { "$match" => {
                "srccity" => origin,
                "destcity" => destination,
                "date" => departureDate
            }},
            { "$group" => {
                "_id" => "$price",
                "airlines" => { "$push" => "$airlinename" },
            }},
            { "$sort" => { _id: 1 }},
            { "$limit" => 1 }
        ])


        from_flights = Flight.collection.aggregate([
            { "$match" => {
                "srccity" => destination,
                "destcity" => origin,
                "date" => returnDate
            }},
            { "$group" => {
                "_id" => "$price",
                "airlines" => { "$push" => "$airlinename" },
            }},
            { "$sort" => { "_id" => 1 }},
            { "$limit" => 1 }
        ])

        @result = []
        dept_price = 0
        dept_airlines = []
        return_price = 0
        return_airlines = []

        to_flights.each do |t|
            dept_price = t["_id"]
            dept_airlines = t["airlines"]
        end

        from_flights.each do |f|
            return_price = f["_id"]
            return_airlines = f["airlines"]
        end

        dept_airlines.each do |t|
            return_airlines.each do |f|
                @result << {
                    "City" => destination,
                    "Departure Date" => departureDate,
                    "Departure Airline" => t,
                    "Departure Price" => dept_price,
                    
                    "Return Date" => returnDate,
                    "Return Airline" => f,
                    "Return Price" => return_price,
                }
            end
        end

        render json: @result, status: :ok
    end
end