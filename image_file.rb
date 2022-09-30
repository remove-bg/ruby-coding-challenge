# frozen_string_literal: true

require 'fileutils'

# Convenient File handling utilities.
# This module has some file handling functions that are available for
# convenience or to jog your memory.
# In your implementation of the cache, you may choose to use all,
# some or none of the functions listed here.
class ImageFile
  # Utility function to write bytes to a file path.
  # Takes care of creating the directory if it doesn't exist.
  #
  # @param path [String] The path to write to.
  # @param bytes [String] The bytes to write.
  def self.write(path, bytes)
    dirname = File.dirname(path)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

    File.open(path, 'wb') do |f|
      f.write(bytes)
    end
  end

  # Utility function to delete a file path.
  #
  # @param path [String] The path of the file to be deleted
  def self.delete(path)
    File.unlink(path)
  end

  # Utility function to confirm whether a file path exists or not.
  #
  # @param path [String] The path of the file to be checked
  def self.exists?(path)
    File.exist?(path)
  end
end
