require 'open-uri'
require 'nokogiri'

location = "rua bento lisboa"
start = 0

url = "https://www.yelp.com/search?find_desc=Restaurants&find_loc=329%203rd%20Ave%2C%20New%20York%2C%20NY%2C%20United%20States"

html_file = open(url, "User-Agent" => "Ruby/2.6.5",
    "From" => "foo@gmail.com",
    "Referer" => "http://www.ruby-lang.org/").read
html_doc = Nokogiri::HTML(html_file)

css_class = "li.lemon--li__373c0__1r9wz > div.lemon--div__373c0__1mboc > div.lemon--div__373c0__1mboc"

hash = {}

html_doc.search(css_class).each_with_index do |element, index|

  next if element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').empty?

  element.search('.lemon--p__373c0__3Qnnj .lemon--span__373c0__3997G').each do |el|
    p el.text unless tl.text.include?("Miles") ||  tl.text.include?("Offers")

    end
    # hash["#{index}"]["address"] = el.text if el.text.size > 9
  end
end


