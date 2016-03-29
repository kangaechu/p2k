require 'open-uri'
require 'nokogiri'
require 'json'

class SpeakerDeck
  def self.get_image_url(url)
    # スライドのuRLからスライドIDを取得
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    data_id = doc.xpath('//div[@class="speakerdeck-embed"]').attribute('data-id').value

    # スライドステータスを含むurlを開く
    charset = nil
    html = open('https://speakerdeck.com/player/' + data_id) do |f|
      charset = f.charset
      f.read
    end

    # JavaScript talk編集のパース
    html =~ /var talk = (.*);/
    json = Regexp.last_match(1)
    slide_status = JSON.parse(json)
    slide_status['slides'].map { |item| item['original'] }
  end

  def self.generate_image_html(url)
    image_urls = get_image_url(url)
    html = ''
    image_urls.each { |url| html = html + '<img src="' + url + '">' + "\n" }
    html
  end
end
