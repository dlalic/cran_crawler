# frozen_string_literal: true

require 'minitar'
require 'deb822/parser'
require 'openapi_client'
require 'set'

class Crawler
  def initialize(api_instance = OpenapiClient::DefaultApi.new, logger = Logger.new(STDOUT))
    @api_instance = api_instance
    @logger = logger
  end

  def retrieve_all_packages
    File.open(@api_instance.get_all_packages) do |f|
      parse_deb822(unpack_gz(f))
    end
  rescue OpenapiClient::ApiError => e
    @logger.error "Exception when calling get_all_packages: #{e}"
  end

  def retrieve_package_details(name, version)
    result = @api_instance.get_package_details(name, version)
    destination = File.join(Dir.tmpdir, name + version)
    File.open(result) do |f|
      unpack_tar_gz(f, destination)
    end
    description = File.join(destination, name, 'DESCRIPTION')
    File.open(description) do |f|
      parse_deb822(f)
    end
  rescue OpenapiClient::ApiError => e
    @logger.error "Exception when calling get_package_details: #{e}"
  end

  private

  def unpack_gz(file)
    Zlib::GzipReader.new(file)
  rescue Zlib::Error => e
    @logger.error "Exception unpacking .gz: #{e}"
  end

  def unpack_tar_gz(file, destination)
    Minitar.unpack(unpack_gz(file), destination)
  rescue Minitar::Error => e
    @logger.error "Exception unpacking .tar: #{e}"
  end

  def parse_deb822(input)
    parser = Deb822::Parser.new(input)
    # Set because there seem to be packages with same name and same version
    parser.paragraphs.to_set
  end
end
