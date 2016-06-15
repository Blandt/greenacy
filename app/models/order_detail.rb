class OrderDetail < ActiveRecord::Base
    belongs_to :order, :class_name => 'Order'
    belongs_to :product

    def self.to_csv(options = {})
        headers = ["Product Name", "Serial", "Make", "Quantity", "Price" ]

        CSV.generate(options) do |csv|
          csv << headers
          all.each do |order|
            @orderid = order.order_id
            product = Product.find(order.product_id)
            attributes = ["#{product.title}", "#{product.serial}", "#{product.make}", "#{order.quantity}", "$#{order.price}"]
            csv << attributes
            #csv << order.attributes.values_at(*attributes)
            #vals = [order.view_order_id order.company.name order.company.contact_number order.start_date order.quantity order.total_price]
            #csv << vals
          end
          ord = Order.find(@orderid)
          attributes = ["", "", "", "Total", "$#{ord.total_price}"]
          csv << attributes
        end
    end
end
