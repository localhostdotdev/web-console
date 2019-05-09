# web-console

forked from [rails/web-console](https://github.com/rails/web-console)

### installation

```ruby
group :development do
  gem 'web-console'
end
```

### usage

```
<% console %>
# or
console
# or
binding.console
```

### configuration

don't mess with the web console too much as it executes arbitrary code on the server (e.g. your computer most likely). **be careful, especially to who you give it access to**.
