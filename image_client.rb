# frozen_string_literal: true

# A client to download image URLs with.
# You can assume you will be supplied with a working implementation.
# You do not need to implement this class yourself.
class ImageClient
  # Downloads the image referenced by url.
  #
  # @param url [String, #read] The url of the image to download.
  # @return [String] The image data in bytes.
  def get(url); end
end
