class Order < ActiveRecord::Base
    has_many :order_detail, :class_name => 'OrderDetail'
    belongs_to :company
    belongs_to :user
    accepts_nested_attributes_for :order_detail, :allow_destroy => true

	

	#def self.to_csv(options = {})
		#headers = ["OrderId", "Company Name", "Company Contact Number", "Date", "Quantity", "Price"]
		#CSV.generate(options) do |csv|
		  #csv << headers
		  #all.each do |order|
			#company = Company.find(order.company_id)
			#attributes = ["#{order.view_order_id}", "#{company.name}", "#{company.contact_number}", "#{order.start_date}", "#{order.quantity}", "#{order.total_price}"]
			#csv << attributes
			#csv << order.attributes.values_at(*attributes)
			#vals = [order.view_order_id order.company.name order.company.contact_number order.start_date order.quantity order.total_price]
			#csv << vals
		  #end
		#end
	#end

	def self.to_csv(options = {})
		headers = ["Product Name", "Serial", "Make", "Quantity", "Price" ]

		CSV.generate(options) do |csv|
		  csv << headers
		  all.each do |order|
			product = Product.find(order.product_id)
			attributes = ["#{product.name}", "#{product.serial}", "#{product.make}", "#{order.quantity}", "$#{order.price}"]
			csv << attributes
			#csv << order.attributes.values_at(*attributes)
			#vals = [order.view_order_id order.company.name order.company.contact_number order.start_date order.quantity order.total_price]
			#csv << vals
		  end
		end
	end
end
