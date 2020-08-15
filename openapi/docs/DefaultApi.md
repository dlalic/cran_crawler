# OpenapiClient::DefaultApi

All URIs are relative to *http://cran.r-project.org/src/contrib*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_all_packages**](DefaultApi.md#get_all_packages) | **GET** /PACKAGES.gz | 
[**get_package_details**](DefaultApi.md#get_package_details) | **GET** /{name}.{version}.tar.gz | 



## get_all_packages

> File get_all_packages



### Example

```ruby
# load the gem
require 'openapi_client'

api_instance = OpenapiClient::DefaultApi.new

begin
  result = api_instance.get_all_packages
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling DefaultApi->get_all_packages: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

**File**

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/gzip


## get_package_details

> File get_package_details(name, version)



### Example

```ruby
# load the gem
require 'openapi_client'

api_instance = OpenapiClient::DefaultApi.new
name = 'name_example' # String | 
version = 'version_example' # String | 

begin
  result = api_instance.get_package_details(name, version)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling DefaultApi->get_package_details: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**|  | 
 **version** | **String**|  | 

### Return type

**File**

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/gzip

