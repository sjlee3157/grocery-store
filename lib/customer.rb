require "csv"

class Customer
  attr_accessor :email, :address
  attr_reader :id

# Integer, String, Hash
# { street: "123 Main", city: "Seattle", state: "WA", zip: "98101" }
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    all_customers = []
    # return collection of Customers from CSV
    # TODO: do this ONLY if new file doesn't exist yet
    headers = [:customer_id, :email, :address_1, :city, :state, :zip_code]
    new_csv = CSV.read("../data/customers.csv").unshift(headers)
    CSV.open("../data/customers_with_headers.csv", "w", headers: headers) { |f| new_csv.each { |a| f << a } }

    imported_csv = CSV.read("../data/customers_with_headers.csv", headers: true, :header_converters => :symbol, :converters => :integer).map{ |r| r.to_h}
    # [{:customer_id=>1, :email=>"leonard.rogahn@hagenes.org",
    # :address_1=>"71596 Eden Route", :city=>"Connellymouth", :state=>"LA",
    # :zip_code=>"98872-9105"}, ... etc. ]

    imported_csv.map{|h|
      address = Hash.new
      address[:address_1] = h.delete(:address_1)
      address[:city] = h.delete(:city)
      address[:state] = h.delete(:state)
      address[:zip_code] = h.delete(:zip_code)
      h[:address] = address
    }
    #[{:customer_id=>1, :email=>"leonard.rogahn@hagenes.org",
    # :address=>{:address_1=>"71596 Eden Route", :city=>"Connellymouth",
    # :state=>"LA", :zip_code=>"98872-9105"}}, ... etc. ]

    imported_csv.each do |h|
      id = h[:customer_id]
      email = h[:email]
      address = h[:address]
      all_customers << Customer.new(id, email, address)
    end

    return all_customers

  end

  # def self.find(id)
  #   # return instance from self.all with id = id
  # end

end

p Customer.all
