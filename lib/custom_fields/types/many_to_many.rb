module CustomFields

  module Types

    module ManyToMany

      module Field

        extend ActiveSupport::Concern

        included do

          field :class_name
          field :inverse_of

          validates_presence_of :class_name, :if => Proc.new { |f| f.type == 'many_to_many' }

          def many_to_many_to_recipe
            { 'class_name' => self.class_name, 'inverse_of' => self.inverse_of }
          end

        end

      end

      module Target

        extend ActiveSupport::Concern

        module ClassMethods

          # Adds a many_to_many relationship between 2 mongoid models
          #
          # @param [ Class ] klass The class to modify
          # @param [ Hash ] rule It contains the name of the relation and if it is required or not
          #
          def apply_many_to_many_custom_field(klass, rule)
            puts "#{klass.inspect}.many_to_many #{rule['name'].inspect}, :class_name => #{rule['class_name'].inspect}" # DEBUG

            klass.has_and_belongs_to_many rule['name'], :class_name => rule['class_name']

            if rule['required']
              klass.validates_length_of rule['name'], :minimum => 1
            end
          end

        end

      end

    end

  end

end