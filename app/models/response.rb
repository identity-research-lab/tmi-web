class Response < ApplicationRecord

  after_update :sync_to_graph

  belongs_to :case
  belongs_to :question

  def codes
    @codes ||= Code.where(name: self.raw_codes, dimension: self.question.dimension.name)
  end

  def sync_to_graph
    if question.is_identity?
      populate_identities
    else
      populate_codes
    end
  end

  private

    def dimension_name
      @dimension_name ||= question.dimension.name
    end

    def persona
      @persona ||= Persona.find_or_create_by(
        name: "Persona #{self.case.identifier}",
        case_id: self.case.id,
        permalink: self.case.permalink
      )
    end

    # Creates Code nodes and connects them to the associated Persona.
    def populate_codes

      # Break association with previous codes in this dimension
      persona.codes = persona.codes.reject{ |c| c.dimension == dimension_name }

      # Clean up any Codes that are no longer associated with a Persona.
      self.raw_codes.compact.uniq.each do |name|
        if code = Code.find_or_create_by(name: name, dimension: dimension_name)
          persona.codes << code
        end
      end

      # Clean up any Codes that are no longer associated with a Persona.
      Code.reap_orphans

    end

    # Creates Identity nodes and connects them to the associated Persona.
    def populate_identities

      persona.identities = persona.identities.reject{ |i| i.dimension == dimension_name }

      self.raw_codes.compact.uniq.each do |name|
        if identity = Identity.find_or_create_by(name: name.strip, dimension: dimension_name)
          persona.identities << identity
        end
      end

      # Clean up any Identities that are no longer associated with a Persona.
      Identity.reap_orphans

    end

end
