module FixtureContentReader
  def fixture_contents(filename)
    path = File.expand_path("spec/fixtures/#{filename}", Rails.root)
    IO.read(path)
  end
end