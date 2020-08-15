# frozen_string_literal: true

require 'rspec'

RSpec.describe Crawler do
  it 'retrieves all packages' do
    VCR.use_cassette('packages') do
      crawler = Crawler.new
      result = crawler.retrieve_all_packages
      expected = { 'Depends' => 'R (>= 2.15.0), xtable, pbapply',
                   'License' => 'GPL (>= 2)',
                   'Md5sum' => '027ebdd8affce8f0effaecfcd5f5ade2',
                   'Needscompilation' => 'no',
                   'Package' => 'A3',
                   'Suggests' => 'randomForest, e1071',
                   'Version' => '1.0.0' }
      expected.keys.each do |k|
        expect(result[0][k]).to eq(expected[k])
      end
    end
  end

  it 'retrieves package details' do
    VCR.use_cassette('package') do
      crawler = Crawler.new
      result = crawler.retrieve_package_details('A3', '1.0.0')
      expected = { 'Package' => 'A3',
                   'Type' => 'Package',
                   'Title' => "Accurate, Adaptable, and Accessible Error Metrics for Predictive\n       Models\n",
                   'Version' => '1.0.0',
                   'Date' => '2015-08-15',
                   'Author' => 'Scott Fortmann-Roe',
                   'Maintainer' => 'Scott Fortmann-Roe <scottfr@berkeley.edu>',
                   'Description' => 'Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.',
                   'License' => 'GPL (>= 2)',
                   'Depends' => 'R (>= 2.15.0), xtable, pbapply',
                   'Suggests' => 'randomForest, e1071',
                   'Needscompilation' => 'no',
                   'Packaged' => '2015-08-16 14:17:33 UTC; scott',
                   'Repository' => 'CRAN',
                   'Date/publication' => '2015-08-16 23:05:52' }
      expected.keys.each do |k|
        expect(result[0][k]).to eq(expected[k])
      end
    end
  end
end
