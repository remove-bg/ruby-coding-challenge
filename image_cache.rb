# frozen_string_literal: true

# Caches images on the filesystem.
#
# It should abide to the following contract:
# * If an image doesn't exist in the cache, it will be downloaded and
#   added when first leased (through ImageCache.lease).
# * Downloading an image or returning one from the cache should be
#   transparent to the caller. i.e. Leasing an image (through
#   ImageCache.lease) will return a Path reference to an image,
#   regardless of its presence in the cache before the call to
#   ImageCache.lease.
# * An image will exist in the cache until all leases have been released
#   (through ImageCache.release)
class ImageCache
  def initialize(image_client)
    @image_client = image_client
  end

  # Downloads an image represented by a url or returns a previously
  # downloaded image. Regardless, until a leased image is released, the
  # file should exist on the file system for other processes to access.
  #
  # @param url [String, #read] The url of the image to download.
  # @return [String] A reference to the location on disk which this image can be accessed at.
  def lease(url); end

  # Releases an image from the cache. After an image is released by all
  # processes leasing it, then it is no longer safe for another process to
  # access the referenced image file because it will have been deleted.
  #
  # @param url [String, #read] The url of the image that was leased.
  def release(url); end
end
