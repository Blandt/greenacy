Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY

  s.name = 'kitco'
  s.version = '0.0.7'
  s.date = '2015-02-02'

  s.description = "An API for accessing data from Kitco Charts. Also includes a command line utility. This is a fork that adds platinum to  mikeycgto gem Found here : https://github.com/mikeycgto/kitco"
  s.summary = "#{s.description}!"

  s.authors = ["Ben Meddeb"]
  s.email = "ben@meddeb.me"

  s.files = %w[
    lib/kitco.rb
    bin/kitco
  ]

  s.add_dependency 'httparty',    '>= 0.7.8'
  s.executables = ['kitco']
  s.has_rdoc = false

  s.homepage = "https://github.com/Blandt/kitco"
  s.require_paths = %w[lib]
end

