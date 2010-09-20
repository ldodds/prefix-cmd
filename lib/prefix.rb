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
  
  def Prefix.uri(prefix_or_curie)
    init() unless test ?e, CONFIG_FILE
    json = JSON.load( File.open(CONFIG_FILE, "r") )
    if Prefix.curie? prefix_or_curie
      match = prefix_or_curie.match /([^:]*):(.*)/
      if json[match[1]]
        puts json[match[1]] + match[2]
      else
        puts "Unknown prefix #{match[1]}"
      end
    else
      puts json[prefix_or_curie] || "Unknown prefix #{prefix_or_curie}"
    end
  end
  
  def Prefix.prefix(uri)
    init() unless test ?e, CONFIG_FILE    
    json = JSON.load( File.open(CONFIG_FILE, "r") )
    json.each do |k,v|
      puts k if v == uri
    end
  end
  
  def Prefix.curie?(prefix_or_curie)
    prefix_or_curie.include? ':'
  end
end
