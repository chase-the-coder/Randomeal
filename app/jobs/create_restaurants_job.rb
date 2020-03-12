class CreateRestaurantsJob < ApplicationJob
  queue_as :default

  def perform(location)
    Restaurant.delete_all
    rests = scrape(location)
    rests.each do |key, _value|
      rests[key]["category"].split(",").each do |category|
        Category.find_or_create_by(name: category)
      end
    end

    rests.each do |key, _value|
      Restaurant.create!(
        name: rests[key]["name"],
        address: rests[key]["address"],
        rating: rests[key]["rating"],
        price_range: rests[key]["price"],
        image: rests[key]["photo"],
        category_id: Category.find_by(name: rests[key]["category"].split(",")[0]).id
      )
    end
  end

  def scrape(location)
    start = 0
    counter = 0
    hash = {}

    2.times do

      url = "https://www.yelp.com/search?find_desc=Restaurants&find_loc=#{location[0]} #{location[1]}&start=#{start}"

      html_file = open(url, "User-Agent" => "Ruby/2.6.5",
          "From" => "foo@gmail.com",
          "Referer" => "http://www.ruby-lang.org/").read
      html_doc = Nokogiri::HTML(html_file)

      css_class = "li.lemon--li__373c0__1r9wz > div.lemon--div__373c0__1mboc > div.lemon--div__373c0__1mboc"

      html_doc.search(css_class).each_with_index do |element, index|

        next if element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').empty?

        hash[counter.to_s] = {}

        element.search('.lemon--h4__373c0__1yd__').each do |el|
          hash[counter.to_s]["name"] = el.text.gsub(/[[0-9].]/, "")[1..-1]
        end

        element.search('.lemon--p__373c0__3Qnnj .lemon--span__373c0__3997G').each do |el|
          hash[counter.to_s]["address"] = el.text if el.text.size > 9
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
    end
    hash
  end


end
