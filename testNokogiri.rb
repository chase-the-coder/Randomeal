require 'open-uri'
require 'nokogiri'

location = "rua bento lisboa"
start = 0

url = "https://www.yelp.com/search?find_desc=Restaurants&find_loc=#{location}&start=#{start}"

html_file = open(url, "User-Agent" => "Ruby/2.6.5",
    "From" => "foo@gmail.com",
    "Referer" => "http://www.ruby-lang.org/").read
html_doc = Nokogiri::HTML(html_file)

css_class = "li.lemon--li__373c0__1r9wz > div.lemon--div__373c0__1mboc > div.lemon--div__373c0__1mboc"

hash = {}

html_doc.search(css_class).each_with_index do |element, index|

  next if element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').empty?

  hash["#{index}"] = {}

  element.search('.lemon--h4__373c0__1yd__').each do |el|
    hash["#{index}"]["name"] = el.text.gsub(/[[0-9].]/, "")[1..-1]
  end

  element.search('.lemon--p__373c0__3Qnnj .lemon--span__373c0__3997G').each do |el|
    hash["#{index}"]["address"] = el.text if el.text.size > 9
  end

  element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').each do |el|
    hash["#{index}"]["price"] = el.text.size
  end

  hash["#{index}"]["category"] = element.search('.lemon--span__373c0__3997G .lemon--span__373c0__3997G .lemon--a__373c0__IEZFH').map(&:text).join(",")

  element.search('.lemon--a__373c0__IEZFH .lemon--img__373c0__3GQUb').each do |el|
    hash["#{index}"]["photo"] = el.attribute('src').value if el.attribute('src').value.include?("bphoto")
  end

  element.search('.lemon--span__373c0__3997G .i-stars__373c0__tb0kH').each do |el|
    p el.values[-2][0..-13].to_f
  end
end

# p hash[hash.keys[0]]["rating"]
