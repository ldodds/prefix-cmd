require 'rake'

require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rake/clean'

require "redis"
require "digest/md5"

NAME = "prefix-cmd"
VER = "0.2"

PKG_FILES = %w( README.rdoc Rakefile ) + 
  Dir.glob("{bin,lib}/**/*")

CLEAN.include ['*.gem', 'pkg']  
SPEC =
  Gem::Specification.new do |s|
    s.name = NAME
    s.version = VER
    s.platform = Gem::Platform::RUBY
    s.required_ruby_version = ">= 1.8.7"    
    s.has_rdoc = true
    s.extra_rdoc_files = ["README.rdoc"]
    s.summary = "Prefix.cc Command"
    s.description = s.summary
    s.author = "Leigh Dodds"
    s.email = 'leigh.dodds@talis.com'
    s.homepage = 'http://github.org/ldodds/prefix-cmd'
    s.files = PKG_FILES
    s.require_path = "lib" 
    s.bindir = "bin"
    s.executables = ["prefix-cmd"]
#    s.test_file = "tests/unit/ts_api.rb"
    s.add_dependency("hpricot")
    s.add_dependency("json_pure")    
    
  end
      
Rake::GemPackageTask.new(SPEC) do |pkg|
    pkg.need_tar = true
end

Rake::TestTask.new do |test|
  test.test_files = FileList['tests/unit/tc_*.rb']
end

desc "Install from a locally built copy of the gem"
task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VER}}
end

desc "Uninstall the gem"
task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
