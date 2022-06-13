# Pyroscope

This addon is built based [Pyroscope](https://github.com/pyroscope-io/pyroscope), which consist of server and agent. It allows the user to collect, store, and query the profiling data in a CPU and disk efficient way.

## install

```shell
vela addon enable pyroscope
```
After enable pyroscope successfully, you can execute command to expose the port `4040` for Dashboard UI.
```shell
vela port-forward addon-pyroscope -n vela-system
```

# How to start
Use a component typed webservice to start, keep the following to pyroscope-demo.yaml, then vela up -f app-demo.yaml
```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: pyroscope-app
  namespace: fourier
spec:
  components:
    - name: pyroscope-comp-01
      type: webservice
      properties:
        image: nginx:latest
        ports:
          - expose: true
            port: 80
            protocol: TCP
        imagePullPolicy: IfNotPresent
      traits:
        - type: pyroscope
          properties:
            server: "http://pyroscope-server:9084"
            logger: "pyroscope.StandardLogger"
            appName: "pyroscope-test"
        - type: scaler
          properties:
            replicas: 1
```
And the parameter `appName` is a optional field, default value is the component name.

## Note
### Pyroscope for Golang applications

- To start profiling a Go application, you need to include our go module in your app
    ```shell
    # make sure you also upgrade pyroscope server to version 0.3.1 or higher
    go get github.com/pyroscope-io/client/pyroscope
    ```
- Then add the following code to your application:
```go
package main

import "github.com/pyroscope-io/client/pyroscope"

func main() {
  pyroscope.Start(pyroscope.Config{
    ApplicationName: "simple.golang.app",
    // replace this with the address of pyroscope server
    ServerAddress:   "http://pyroscope-server:4040",
    // you can disable logging by setting this to nil
    Logger:          pyroscope.StandardLogger,

    // optionally, if authentication is enabled, specify the API key:
    // AuthToken: os.Getenv("PYROSCOPE_AUTH_TOKEN"),

    // by default all profilers are enabled, but you can select the ones you want to use:
    ProfileTypes: []pyroscope.ProfileType{
      pyroscope.ProfileCPU,
      pyroscope.ProfileAllocObjects,
      pyroscope.ProfileAllocSpace,
      pyroscope.ProfileInuseObjects,
      pyroscope.ProfileInuseSpace,
    },
  })

  // your code goes here
}
```
- Check out the [examples](https://github.com/pyroscope-io/pyroscope/tree/main/examples/golang-push) directory in our repository to learn more

### Pyroscope for Java applications

- Java integration is distributed as a single jar file: pyroscope.jar. It contains native async-profiler libraries
- To start profiling a Java application, run your application with pyroscope.jar javaagent:
```shell
export PYROSCOPE_APPLICATION_NAME=my.java.app
export PYROSCOPE_SERVER_ADDRESS=http://pyroscope-server:4040

# Optionally, if authentication is enabled, specify the API key.
# export PYROSCOPE_AUTH_TOKEN={YOUR_API_KEY}

java -javaagent:pyroscope.jar -jar app.jar
```
- Check out the [examples](https://github.com/pyroscope-io/pyroscope/tree/main/examples/java) folder in our repository to learn more

### Pyroscope for .net applications

- To start profiling a .NET application inside a container, you may wrap your application with pyroscope exec as an entrypoint of your image. The tricky part is that you need to copy pyroscope binary to your docker container. To do that, use COPY --from command in your Dockerfile. 
The following example Dockerfile shows how to build the image:
```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:5.0

WORKDIR /dotnet

COPY --from=pyroscope/pyroscope:latest /usr/bin/pyroscope /usr/bin/pyroscope
ADD my-app .
RUN dotnet publish -o . -r $(dotnet --info | grep RID | cut -b 6- | tr -d ' ')

# optionally you may set the pyroscope server address as well as the app name and other configuration options.
ENV PYROSCOPE_SERVER_ADDRESS=http://pyroscope-server:4040
ENV PYROSCOPE_APPLICATION_NAME=my.dotnet.app
ENV PYROSCOPE_LOG_LEVEL=debug

CMD ["pyroscope", "exec", "dotnet", "/dotnet/my-app.dll"]
```
- If you are using Docker Compose, you can run both pyroscope server and agent with this configuration:
```yaml
---
version: "3.9"
services:
  pyroscope-server:
    image: "pyroscope/pyroscope:latest"
    ports:
      - "4040:4040"
    command:
      - "server"
  app:
    image: "my-app:latest"
    environment:
      PYROSCOPE_APPLICATION_NAME: my.dotnet.app
      PYROSCOPE_SERVER_ADDRESS: http://pyroscope-server:4040
      PYROSCOPE_LOG_LEVEL: debug
      ASPNETCORE_URLS: http://*:5000
    ports:
      - "5000:5000"
    cap_add:
      - SYS_PTRACE
```
- Check out the [examples](https://github.com/pyroscope-io/pyroscope/tree/main/examples/dotnet) folder in our repository to learn more

### Pyroscope for Python applications

- First, install pyroscope-io pip package:
```shell
pip install pyroscope-io
```
- Add the following code to your application. This code will initialize pyroscope profiler and start profiling:
```shell
import pyroscope

pyroscope.configure(
  app_name       = "my.python.app", # replace this with some name for your application
  server_address = "http://my-pyroscope-server:4040", # replace this with the address of your pyroscope server
# auth_token     = "{YOUR_API_KEY}", # optionally, if authentication is enabled, specify the API key
)
```
- Check out the [example python project in pyroscope repository](https://github.com/pyroscope-io/pyroscope/tree/main/examples/python) for examples of how you can use these features.

### Pyroscope for PHP applications

- To start profiling a PHP application in a container, you may wrap your application with pyroscope exec as an entrypoint of your image. The tricky part is that you need to copy pyroscope binary to your docker container. To do that, use COPY --from command in your Dockerfile.
The following example Dockerfile shows how to build the image:
```dockerfile
FROM php:7.3.27

WORKDIR /var/www/html

# this copies pyroscope binary from pyroscope image to your image:
COPY --from=pyroscope/pyroscope:latest /usr/bin/pyroscope /usr/bin/pyroscope
COPY main.php ./main.php

# optionally you may set the pyroscope server address as well as the app name, make sure you change these:
ENV PYROSCOPE_APPLICATION_NAME=my.php.app
ENV PYROSCOPE_SERVER_ADDRESS=http://pyroscope:4040/

# this starts your app with pyroscope profiler, make sure to change "php" and "main.php" to the actual command.
CMD ["pyroscope", "exec", "php", "main.php"]
```
- If you are using Docker Compose, you can run both pyroscope server and agent with this configuration:
```yaml
---
services:
  pyroscope-server:
    image: "pyroscope/pyroscope:latest"
    ports:
      - "4040:4040"
    command:
      - "server"
  app:
    image: "my-app:latest"
    env:
      PYROSCOPE_SERVER_ADDRESS: http://pyroscope-server:4040
      PYROSCOPE_APPLICATION_NAME: my.php.app
    cap_add:
      - SYS_PTRACE
```
- Check out the [examples](https://github.com/pyroscope-io/pyroscope/tree/main/examples/php) folder in our repository to learn more

### Pyroscope for NodeJS applications

- To start profiling a NodeJS application, you need to include the npm module in your app:
```shell
npm install @pyroscope/nodejs

# or
yarn add @pyroscope/nodejs
```
- Then add the following code to your application:
```js
const Pyroscope = require('@pyroscope/nodejs');

Pyroscope.init({
  serverAddress: 'http://pyroscope:4040',
  appName: 'myNodeService'
});

Pyroscope.start()
```
- Check out the [examples](https://github.com/pyroscope-io/pyroscope/tree/main/examples/nodejs) directory in our repository to learn more.

## uninstall

```shell
vela addon disable pyroscope
```