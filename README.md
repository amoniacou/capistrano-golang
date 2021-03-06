# capistrano-golang

Use capistrano to deploy Go projects

### Usage

1. Add the following line to your Gemfile:

  ```ruby
  gem 'capistrano-golang'
  ```
2. Add the following line to your Capfile:

  ```ruby
  require 'capistrano/golang'
  ```
3. Configure in config/deploy.rb:

  ```ruby
  set :go_version, "go1.7.4"
  ```

For all configuration options, please see the [defaults](https://github.com/amoniacou/capistrano-golang/blob/master/lib/capistrano/tasks/golang.rake#L52) section.

### Licence

```
Copyright (c) 2017 Amoniac OU
Copyright (c) 2015 Black Square Media

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
