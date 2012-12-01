source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.

gem "builder"
gem "httparty"
gem "activemodel"

group :development do
  gem "rdoc", "~> 3.12"
  gem "bundler", ">= 0"
  gem "jeweler", "~> 1.8.4"
  gem "turn"
  gem "mocha", require: false
  gem "vcr"
  # Version requirement caused by VCR's warning.
  # Can be removed after merge of https://github.com/vcr/vcr/commit/f75353b75e1ac1e4309faa9323e7c01d8ce28e46
  gem "webmock", "< 1.9.0"
end
