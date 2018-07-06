$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "camaleon_pagenotfound/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "camaleon_pagenotfound"
  s.version     = CamaleonPagenotfound::VERSION
  s.authors     = ["superchell"]
  s.email       = ["for.oleg.mozolev@gmail.com"]
  s.homepage    = "https://siteon.com.ua"
  s.summary     = ": Summary of CamaleonPagenotfound."
  s.description = "Sets 404 status for selected pages"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "camaleon_cms", "~> 2.0"

  s.add_development_dependency "sqlite3"
end
