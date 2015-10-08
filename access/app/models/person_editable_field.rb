class PersonEditableField < ActiveRecord::Base
  belongs_to :person
  before_validation :set_default

  (self.column_names - %w(id person_id created_at updated_at)).each do |column|
    validates column.to_sym, presence: true
  end

  private
    def set_default
      (self.class.column_names - %w(id person_id created_at updated_at)).map{|col| eval("self.#{col} = true if #{col}.nil?") }
    end
end
