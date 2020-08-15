require 'minitar'
require 'deb822/parser'
require 'openapi_client'

class Crawler
  def initialize(api_instance = OpenapiClient::DefaultApi.new, logger = Logger.new(STDOUT))
    @api_instance = api_instance
    @logger = logger
  end

  def get_all_packages

      File.open(@api_instance.get_all_packages) do |f|
        parse_deb822(unpack_gz(f))
      end
    rescue OpenapiClient::ApiError => e
      @logger.error "Exception when calling get_all_packages: #{e}"

  end

  def get_package_details(name, version)

      result = @api_instance.get_package_details(name, version)
      destination = File.join(Dir.tmpdir(), name + version)
      File.open(result) do |f|
        unpack_tar_gz(f, destination)
      end
      description = File.join(destination, name, 'DESCRIPTION')
      File.open(description) do |f|
        parse_deb822(f)
      end
    rescue OpenapiClient::ApiError => e
      @logger.error "Exception when calling get_all_packages: #{e}"

  end

  private def unpack_gz(file)

      Zlib::GzipReader.open(file, &:read)
    rescue Zlib::Error => e
      @logger.error "Exception unpacking .gz: #{e}"

  end

  private def unpack_tar_gz(file, destination)

      # TODO: reuse unpack_gz
      Minitar.unpack(Zlib::GzipReader.new(file), destination)
    rescue Minitar::Error => e
      @logger.error "Exception unpacking .tar: #{e}"

  end

  private def parse_deb822(input)
    parser = Deb822::Parser.new(input)
    parser.paragraphs.to_a
  end
end
