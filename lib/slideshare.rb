require 'open-uri'
require 'nokogiri'
require 'json'

class SlideShare
  def self.get_image_url(url)
    # スライドのuRLからスライドIDを取得
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    # スライドIDの取得
    item = doc.xpath('/html/head/meta[@name="thumbnail"]').first
    thumbnail_url = item.attributes['content'].value
    slide_id = thumbnail_url.gsub(/^.*ss_thumbnails\/(.+?)-thumbnail.*$/, '\1')
    p slide_id

    # スライド枚数の取得
    total_slides = doc.xpath('//span[@id="total-slides"]').first.text.to_i
    p total_slides

    # スライド名の取得
    slide_name = doc.xpath('/html/head/link[@rel="canonical"]')
                    .first.attribute('href').to_s
                    .split('/')[4]
    p slide_name

    image_urls = []
    total_slides.times do |i|
      image_urls.push "http://image.slidesharecdn.com/#{slide_id}/95/#{slide_name}-#{i + 1}-1024.jpg"
    end
    image_urls
  end

  def self.generate_image_html(url)
    image_urls = get_image_url(url)
    html = ''
    image_urls.each { |url| html = html + '<img src="' + url + '">' + "\n" }
    html
  end
end

# p SlideShare.generate_image_html("http://www.slideshare.net/You_Kinjoh/siergithub-enterprise?qid=83b40434-750a-4f54-bd86-839c060aad62&v=&b=&from_search=3")
