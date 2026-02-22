<a href="https://rubygems.org/gems/lowkey" title="Install gem"><img src="https://badge.fury.io/rb/lowkey.svg" alt="Gem version" height="18"></a> <a href="https://github.com/low-rb/lowkey" title="GitHub"><img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" alt="GitHub repo" height="18"></a> <a href="https://codeberg.org/Iow/key" title="Codeberg"><img src="https://img.shields.io/badge/Codeberg-2185D0?style=for-the-badge&logo=Codeberg&logoColor=white" alt="Codeberg repo" height="18"></a>

# Lowkey

PRISM is amazing and opens up new ways to access metadata in Ruby. However:
- Loading the Abstract Syntax Tree (AST) multiple times is inefficient
- We need higher level abstractions such as classes and methods
- Navigating the AST can be difficult

Lowkey provides a central API for storing this metadata once and accessing it multiple times. It's the secret sauce 🌶️ behind [LowType](https://github.com/low-rb/low_type), [LowLoad](https://github.com/low-rb/low_load) and [Raindeer](https://github.com/raindeer-rb/raindeer) in general.

## Usage

Load a file:
```ruby
Lowkey.load(file_path: 'my_class.rb')
```

Access the resulting proxies:
```ruby
Lowkey['my_class.rb'] # => FileProxy
Lowkey['my_class.rb']['MyNamespace::MyClass'] # => ClassProxy
```

## Proxies

Proxies provide a "flat" abstraction over the Abstract Syntax Tree.

**Proxy Types:**
- `FileProxy` - The file path, its definitions and dependencies
- `ClassProxy` - The class and its methods
- `MethodProxy` [UNRELEASED]
- `ParamProxy` [UNRELEASED]
- `ReturnProxy` [UNRELEASED]

### Method access

```ruby
Lowkey['my_class.rb']['MyNamespace::MyClass'][:my_method] # => MethodProxy
```

## Queries

Queries access nested nodes within the AST via keypath syntax:
```ruby
Lowkey['my_class.rb::MyNamespace::MyClass.my_method'] # => MethodDefNode
```

A query can start at any proxy and still use the keypath syntax:
```ruby
# Query from a file proxy.
file_proxy = Lowkey['my_class.rb']
file_proxy['MyNamespace::MyClass.my_method'] # => MethodDefNode

# Query from a class proxy.
class_proxy = Lowkey['my_class.rb']['MyNamespace::MyClass']
class_proxy['.my_method'] # => MethodDefNode
```

ℹ️ Query keypaths contain dots "`.`" and return nodes. They target the `name` attribute of nodes.

## Mutations

You can mutate a file using either Proxies or Queries:

|             | **Difficulty** | **Structure** | **Mutations**                                          |
|-------------|----------------|---------------|--------------------------------------------------------|
| **Proxies** | Easy           | Flat          | Preserves existing code and line numbers when possible |
| **Queries** | Medium         | Nested        | Generates new code from the Abstract Syntax Tree       |

ℹ️ Both approaches can be mixed together, for example; using queries to get data for a proxy.

### Proxy Mutations

Replacing a method's source code:
```ruby
Lowkey['my_class.rb']['MyNamespace::MyClass'][:my_method].source_code = my_string_of_code
```

### Query Mutations [UNRELEASED]

Using the query keypath we can manipulate the AST:
```ruby
Lowkey['my_class.rb::MyNamespace::MyClass.my_method'] = my_node
```

## Exports

### Proxy Exports

Export the source code for mutated proxies to memory:
```ruby
Lowkey['my_class.rb'].export
Lowkey['my_class.rb']['MyNamespace::MyClass'].export
Lowkey['my_class.rb']['MyNamespace::MyClass'][:my_method].export
```

Save the source code for mutated proxies to disk: [UNRELEASED]
```ruby
Lowkey['my_class.rb'].save(file_path:) # Replaces entire file.
Lowkey['my_class.rb']['MyNamespace::MyClass'].save(file_path:) # Replaces part of a file.
Lowkey['my_class.rb']['MyNamespace::MyClass'][:my_method].save(file_path:) # Replaces part of a file.
```

### Query Exports [UNRELEASED]

Export generated code for mutated nodes to memory: [UNRELEASED]
```ruby
Lowkey['my_class.rb.root_node'].export # Special selector for the top level node.
Lowkey['my_class.rb::MyNamespace::MyClass.root_node'].export
Lowkey['my_class.rb::MyNamespace::MyClass.my_method'].export
```

Save generated code for mutated nodes to disk: [UNRELEASED]
```ruby
Lowkey['my_class.rb.root_node'].save(file_path:) # Replaces entire file.
Lowkey['my_class.rb::MyNamespace::MyClass'].save(file_path:) # Replaces entire file.
Lowkey['my_class.rb::MyNamespace::MyClass.my_method'].save(file_path:) # Replaces entire file.
```

ℹ️ Code is generated from the AST and will not match the source code that was originally loaded.

## Config

Copy and paste the following and change the defaults to configure Lowkey:

```ruby
# This configuration should be set before calling "Lowkey.load".
Lowkey.configure do |config|
  # A big benefit of Lowkey is its caching of abstract syntax trees, file proxies and class proxies.
  # But to save memory you should clear them after the "class load"/setup stage of your application.
  # Set to "false" or call "Lowkey.clear" after you no longer need Lowkey, such as in a boot script.
  config.cache = true
end
```

## Installation

Add `gem 'lowkey'` to your Gemfile then:
```
bundle install
```
