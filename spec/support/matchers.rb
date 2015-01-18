RSpec::Matchers.define :be_same_time_as do |expected|
  match do |actual|
    actual.respond_to?(:to_time) && actual.to_time.to_i == expected.to_time.to_i
  end
end
