# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'image_cache'

describe ImageCache do
  before do
    @image_client = Minitest::Mock.new
    @image_cache =  ImageCache.new(@image_client)
    @bytes = 'some bytes'.bytes
  end

  describe 'leasing' do
    it 'returns from cache when present' do
      url = 'http://canva-interview.com/image.png'

      @image_client.expect :get, @bytes, [url]

      # populate the cache
      image1 = @image_cache.lease(url)

      # request the same image a second time
      image2 = @image_cache.lease(url)

      # assert that each subsequent call to lease returned the same File
      # reference for the cached image
      assert_equal(image1, image2)
      # and that the image_client was only called once with this url
      @image_client.verify

      # release the image as many times as leased to enable cleanup
      @image_cache.release(url)
      @image_cache.release(url)
    end

    it 'does not return the same image for different urls' do
      url1 = 'http://canva-interview.com/image.png'
      url2 = 'http://canva-interview.com/image2.png'

      @image_client.expect :get, @bytes, [url1]
      @image_client.expect :get, @bytes, [url2]

      # fetch two different image urls
      image1 = @image_cache.lease(url1)
      image2 = @image_cache.lease(url2)

      # assert that the file handles are different (images are stored in different files)
      refute_equal(image1, image2)
      # ant that the image_client was called twice with different urls
      @image_client.verify

      # release the image as many times as leased to enable cleanup
      @image_cache.release(url1)
      @image_cache.release(url2)
    end
  end

  describe 'releasing' do
    it 'does not cleanup actively leased images' do
      url = 'http://canva-interview.com/image.png'
      @image_client.expect :get, @bytes, [url]

      # lease the same image twice
      @image_cache.lease(url)
      image = @image_cache.lease(url)

      # assert that the image is present on the filesystem
      assert_equal(true, File.exist?(image))

      # release the image once
      @image_cache.release(url)

      # assert that the image is still present on the filesystem
      assert_equal(true, File.exist?(image))

      @image_cache.release(url)

      # assert that the image is still present in the cache
      assert_equal(false, File.exist?(image))
    end
  end
end
