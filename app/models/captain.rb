class Captain < ActiveRecord::Base
  has_many :boats


  def self.catamaran_operators
  	Captain.joins(:boats).where(:boats => 
  		{id: BoatClassification.where(classification_id: Classification.find_by(name: "Catamaran").id).map{|i| i.boat_id}})
  end

  def self.sailors
  	Captain.joins(:boats).where(:boats => {id: BoatClassification.where(classification_id: Classification.find_by(name: "Sailboat").id).map{|i| i.boat_id}}).uniq
  	#includes(boats: :classifications).where(classifications: {name: "Sailboat"}).uniq
  end

   def self.motorboaters
  	Captain.joins(:boats).where(:boats => {id: BoatClassification.where(classification_id: Classification.find_by(name: "Motorboat").id).map{|i| i.boat_id}}).uniq
  end

  def self.talented_seamen
  	Captain.where(id: Captain.sailors.pluck(:id) & Captain.motorboaters.pluck(:id)) # & is intersect!
  	#where("id IN (?)", self.sailors.pluck(:id) & self.motorboaters.pluck(:id))
  end

  def self.non_sailors
  	Captain.where.not(id: Captain.sailors.map(&:id))

  end
end


