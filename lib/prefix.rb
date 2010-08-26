require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'json/pure'

class Prefix

  HOME = ENV["HOME"] || ENV["HOMEPATH"] || File::expand_path("~")
  CONFIG_DIR = File::join HOME, ".prefix-cmd"
  CONFIG_FILE = File::join CONFIG_DIR, "prefixes.json"
   
  def Prefix.init()
    puts "Initializing prefix cache"
    doc = Hpricot( open("http://prefix.cc/popular/all") )
    
    prefixes = {}
    doc.search("a").each do |el|     
     prefixes[ el.inner_html ] = el["resource"]  if el["rel"] && el["rel"].match("rdfs:seeAlso")
    end
    
    FileUtils::mkdir_p CONFIG_DIR unless test ?d, CONFIG_DIR
    test ?e, CONFIG_FILE and FileUtils::mv CONFIG_FILE, "#{CONFIG_FILE}.bak"    
    
    File.open(CONFIG_FILE, "w") do |f|
      f.puts( prefixes.to_json )
    end
    
  end
  
  def Prefix.uri(prefix)
    init() unless test ?e, CONFIG_FILE
    json = JSON.load( File.open(CONFIG_FILE, "r") )
    puts json[prefix] || "Unknown prefix #{prefix}"
  end
  
  def Prefix.prefix(uri)
    init() unless test ?e, CONFIG_FILE    
    json = JSON.load( File.open(CONFIG_FILE, "r") )
    json.each do |k,v|
      puts k if v == uri
    end
  end
  
end