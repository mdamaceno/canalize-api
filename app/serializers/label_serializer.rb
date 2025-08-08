class LabelSerializer
  attr_reader :label

  def initialize(label)
    @label = label
  end

  def as_json
    {
      identifier: label.identifier,
      name: label.name
    }
  end
end
