<a href="https://rubygems.org/gems/lowkey" title="Install gem"><img src="https://badge.fury.io/rb/lowkey.svg" alt="Gem version" height="18"></a> <a href="https://github.com/low-rb/lowkey" title="GitHub"><img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" alt="GitHub repo" height="18"></a> <a href="https://codeberg.org/Iow/key" title="Codeberg"><img src="https://img.shields.io/badge/Codeberg-2185D0?style=for-the-badge&logo=Codeberg&logoColor=white" alt="Codeberg repo" height="18"></a>

# Lowkey

PRISM is amazing and opens a new way to access metadata in Ruby. However:
- Loading and reloading the Abstract Syntax Tree (AST) multiple times is inefficient
- Navigating the AST can be difficult

Lowkey provides a central API to make storing and accessing the AST more efficient and easier.

## Config

Copy and paste the following and change the defaults to configure Lowkey:

```ruby
# This configuration should be set before calling "Lowkey.load".
Lowkey.configure do |config|
  # A big benefit of Lowkey is its caching of abstract syntax trees, file proxies and class proxies.
  # But to save memory you should clear them after the "class load"/setup stage of your application.
  # There is no "setup complete" stage in Ruby so it can't be automated, why it defaults to "false".
  # Set to "true" then call "Lowkey.clear" after you no longer need Lowkey. Example: in a boot file.
  config.cache = false
end
```

## Installation

Add `gem 'lowkey'` to your Gemfile then:
```
bundle install
```
