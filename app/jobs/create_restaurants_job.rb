class CreateRestaurantsJob < ApplicationJob
  queue_as :default

  def expiration
    @expiration = 60 * 60 * 24 * 30 # 30 days
  end

  def perform(location)
    start = 0
    counter = 0
    hash = {}

    5.times do

      url = "https://www.yelp.com/search?find_desc=Restaurants&find_loc=#{location[0]} #{location[1]}&start=#{start}"
      email = "#{rand(99999..999999999999)}@gmail.com"
      html_file = open(url, "User-Agent" => "Ruby/2.6.5",
          "From" => email,
          "Referer" => "http://www.ruby-lang.org/").read
      html_doc = Nokogiri::HTML(html_file)

      break if html_doc.search("h3").first.text.include?("We're sorry, the page of results you requested is unavailable.")

      css_class = "li.lemon--li__373c0__1r9wz > div.lemon--div__373c0__1mboc > div.lemon--div__373c0__1mboc"

      html_doc.search(css_class).each_with_index do |element, index|

        next if element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').empty?

        hash[counter.to_s] = {}

        element.search('.lemon--h4__373c0__1yd__').each do |el|
          hash[counter.to_s]["name"] = el.text.gsub(/[[0-9].]/, "")[1..-1]
        end

        element.search('.lemon--p__373c0__3Qnnj .lemon--span__373c0__3997G').each do |el|
          hash[counter.to_s]["address"] = el.text unless el.text.include?("Miles") ||  el.text.include?("Offers") ||  el.text.include?("more")
        end

        element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').each do |el|
          hash[counter.to_s]["price"] = el.text.size
        end

        hash[counter.to_s]["category"] = element.search('.lemon--span__373c0__3997G .lemon--span__373c0__3997G .lemon--a__373c0__IEZFH').map(&:text).join(",")

        element.search('.lemon--a__373c0__IEZFH .lemon--img__373c0__3GQUb').each do |el|
          hash[counter.to_s]["photo"] = el.attribute('src').value if el.attribute('src').value.include?("bphoto")
        end

        element.search('.lemon--span__373c0__3997G .i-stars__373c0__tb0kH').each do |el|
          hash[counter.to_s]["rating"] = el.values[-2][0..-13].to_f
        end
        counter += 1
      end
      start += 30
      hash.each do |key, _value|
        hash[key]["category"].split(",").each do |category|
          Category.find_or_create_by(name: category)
        end
      end

      hash.each do |key, _value|
        Restaurant.find_or_create_by(
          name: hash[key]["name"],
          address: hash[key]["address"],
          rating: hash[key]["rating"],
          price_range: hash[key]["price"],
          image: hash[key]["photo"],
          category_id: Category.find_by(name: hash[key]["category"].split(",")[0]).id
        )
      end
    end
  end
end
