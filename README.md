# JRuby Sinatra Server Template.
Jruby app server is a sinatra app running in jruby environment. You can easy use ruby in java, and develop a web app use sinatra with ruby and java.

# How to install

1. git clone  this project

```bash
git clone git@git.dehuinet.com:ruby_server/jruby_app_server.git

```

2. install bundles

edite the Gemfile, and add the gems you need.

```bash
ant bundle:install
```
all gem will be installed in ./jruby/1.9

3. migrate database

```bash
ant db:migrate
```

4. create a jar and runtime environment.

```bash
ant jar
java -jar server.jar
```
Your server will start in a java vm.

5. build ruby code to class file and zip all files.

```bash
ant zip
```

6. run the server in jruby environment.

```bash
jruby boot.rb 
```


