class Product < ActiveRecord::Base
     belongs_to :category
     has_attached_file :image, :styles => { :small => "150x150>", listing: "200x200>", search: "248x200>", detail: "300x300>" },
                       :url  => "/assets/products/:id/:style/:basename.:extension",
                       :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"
     validates_attachment :image, content_type: { content_type: [ "image/jpg", "image/jpeg", "image/png" ] }

      def self.search(query)
         # where(:title, query) -> This would return an exact match of the query
         where("serial like ?", "%#{query}%")
       end
end
