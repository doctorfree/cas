# CAS Identity and Single Sign On Server and WAR Overlay Build

Build, configuration, and integration of CAS Identity & Single Sign On
for all earthlings and beyond.

See https://apereo.github.io/cas/development/planning/Getting-Started.html
to get started with CAS.

## Requirements

See https://apereo.github.io/cas/development/planning/Installation-Requirements.html

- [JDK 21](https://openjdk.java.net/projects/jdk/21)
- [Apache Tomcat](http://tomcat.apache.org)
- [Git](https://git-scm.com/downloads)
- Operating system (Linux preferably)
- Internet connectivity
- Minimum hardware requirements
  - dual-core 3.00Ghz processor
  - 4GB of memory

## Deployment

See https://apereo.github.io/cas/development/installation/WAR-Overlay-Installation.html

### WAR Overlay Method

Rather than downloading the CAS codebase and building from source, overlays
allow you to download a pre-built vanilla CAS web application server provided
by the project itself and override/insert specific behavior into it. At build
time, the build installation process will attempt to download the provided
binary artifact first. Then the tool will locate your configuration files and
settings made available inside the same project directory and will merge those
into the downloaded artifact in order to produce one wholesome archive
(i.e. `cas.war`). Overridden artifacts may include resources, java classes,
images, CSS and javascript files. In order for the merge process to successfully
execute, the location and names of the overridden artifacts locally must EXACTLY
match that of those provided by the project inside the originally downloaded
archive. Java code in the overlay project's `src/main/java` folder and resources
in `src/main/resources` will end up in the `WEB-INF\classes` folder of `cas.war`
and they will be loaded by the classloader instead of resources with the same
names in jar files inside `WEB-INF\lib`.

### Managing Overlays

Most if not all aspects of CAS can be controlled by adding, removing,
or modifying files in the overlay; it's also possible and indeed common
to customize the behavior of CAS by adding third-party components that
implement CAS APIs as Java source files or dependency references.

The process of working with an overlay can be summarized in the following steps:

- Start with and build the provided basic vanilla build/deployment.
- Identify the artifacts from the produced build that need changes. These artifacts are generally produced by the build in the build directory for Gradle.
- Copy the identified artifacts from the identified above directories over to the `src/main/resources` directory.
  - Create the `src/main/resources` directories, if they don't already exist.
  - Copied paths and file names MUST EXACTLY MATCH their build counterparts, or the change won't take effect.
- After changes, rebuild and repeat the process as many times as possible.
- Double check your changes inside the built binary artifact to make sure the overlay process is working.

### CAS Overlay Initializr

Apereo CAS Initializr is a service provided by the Apereo CAS project that
allows you as the deployer to generate CAS WAR Overlay projects on the fly
with just what you need to start quickly.

To learn more about the initializr,
[review this guide](https://apereo.github.io/cas/development/installation/WAR-Overlay-Initializr.html).

### Dockerized Deployment

See
[this guide](https://apereo.github.io/cas/development/installation/Docker-Installation.html)
for more info on dockerized deployment.

### Servlet Container

CAS can be deployed to a number of servlet containers. See
[this guide](https://apereo.github.io/cas/development/installation/Configuring-Servlet-Container.html)
for more info on servlet containers.

### Dependency Management

Each release of CAS provides a curated list of dependencies it supports. In
practice, you do not need to provide a version for any of these dependencies in
your build configuration as the CAS distribution is managing that for you. When
you upgrade CAS itself, these dependencies will be upgraded as well in a consistent way.

The curated list of dependencies contains a refined list of third party libraries.
The list is available as a standard Bills of Materials (BOM). Not everyone likes
inheriting from the BOM. You may have your own corporate standard parent that you
need to use, or you may just prefer to explicitly declare all your configuration.

To take advantage of the CAS BOM, see
[this guide](https://apereo.github.io/cas/development/installation/BOM-Dependency-Management.html).

## CAS Server build scripts

The CAS Server build scripts reside in the `scripts` folder.

## Apereo CAS WAR Overlay Template

WAR Overlay Type: `cas-overlay`

### Versions

- CAS Server `7.1.0-SNAPSHOT`
- JDK `21`
                     
### Build

To build the project, use:

```bash
# Use --refresh-dependencies to force-update SNAPSHOT versions
./gradlew[.bat] clean build
```

To see what commands/tasks are available to the build script, run:

```bash
./gradlew[.bat] tasks
```

If you need to, on Linux/Unix systems, you can delete all the existing artifacts
(artifacts and metadata) Gradle has downloaded using:

```bash
# Only do this when absolutely necessary
rm -rf $HOME/.gradle/caches/
```

Same strategy applies to Windows too, provided you switch `$HOME` to its equivalent in the above command.

### Keystore

For the server to run successfully, you might need to create a keystore file.
This can either be done using the JDK's `keytool` utility or via the following command:

```bash
./gradlew[.bat] createKeystore
```

Use the password `changeit` for both the keystore and the key/certificate entries. 
Ensure the keystore is loaded up with keys and certificates of the server.

### Extension Modules

Extension modules may be specified under the `dependencies` block of the [Gradle build script](build.gradle):

```gradle
dependencies {
    implementation "org.apereo.cas:cas-server-some-module"
    ...
}
```

To collect the list of all project modules and dependencies in the overlay:

```bash
./gradlew[.bat] dependencies
```                                                                       

### Deployment

On a successful deployment via the following methods, the server will be available at:


* `https://localhost:8443/cas`

### Executable WAR

Run the server web application as an executable WAR. Note that running an executable WAR requires CAS to use an embedded container such as Apache Tomcat, Jetty, etc.

The current servlet container is specified as `-tomcat`.

```bash
java -jar build/libs/cas.war
```

Or via:

```bash
./gradlew[.bat] run
```

Debug the CAS web application as an executable WAR:

```bash
./gradlew[.bat] debug
```
       
Or via:

```bash
java -Xdebug -Xrunjdwp:transport=dt_socket,address=5000,server=y,suspend=y -jar build/libs/cas.war
```

Run the CAS web application as a *standalone* executable WAR:

```bash
./gradlew[.bat] clean executable
```

### External

Deploy the binary web application file in `build/libs` after a successful build to a servlet container of choice.

## Docker

The following strategies outline how to build and deploy CAS Docker images.

### Jib

The overlay embraces the [Jib Gradle Plugin](https://github.com/GoogleContainerTools/jib) to provide easy-to-use out-of-the-box tooling for building CAS docker images. Jib is an open-source Java containerizer from Google that lets Java developers build containers using the tools they know. It is a container image builder that handles all the steps of packaging your application into a container image. It does not require you to write a Dockerfile or have Docker installed, and it is directly integrated into the overlay.

```bash
# Running this task requires that you have Docker installed and running.
./gradlew build jibDockerBuild
```

### Dockerfile

You can also use the Docker tooling and the provided `Dockerfile` to build and run.
There are dedicated Gradle tasks available to build and push Docker images using the supplied `DockerFile`:

```bash
./gradlew build casBuildDockerImage
```

Once ready, you may also push the images:

```bash
./gradlew casPushDockerImage
```

If credentials (username+password) are required for pull and push operations, they may be specified
using system properties via `-DdockerUsername=...` and `-DdockerPassword=...`.

A `docker-compose.yml` is also provided to orchestrate the build:

```bash  
docker-compose build
```

## CAS Command-line Shell

To launch into the CAS command-line shell:

```bash
./gradlew[.bat] downloadShell runShell
```

## Retrieve Overlay Resources

To fetch and overlay a CAS resource or view, use:

```bash
./gradlew[.bat] getResource -PresourceName=[resource-name]
```

## Create User Interface Themes Structure

You can use the overlay to construct the correct directory structure for custom user interface themes:

```bash
./gradlew[.bat] createTheme -Ptheme=redbeard
```

The generated directory structure should match the following:

```
├── redbeard.properties
├── static
│ └── themes
│     └── redbeard
│         ├── css
│         │ └── cas.css
│         └── js
│             └── cas.js
└── templates
    └── redbeard
        └── fragments
```

HTML templates and fragments can be moved into the above directory structure, 
and the theme may be assigned to applications for use.

## List Overlay Resources
 
To list all available CAS views and templates:

```bash
./gradlew[.bat] listTemplateViews
```

To unzip and explode the CAS web application file and the internal resources jar:

```bash
./gradlew[.bat] explodeWar
```

## Configuration

- The `etc` directory contains the configuration files and directories that need to be copied to `/etc/cas/config`.

```bash
./gradlew[.bat] copyCasConfiguration
```

- The specifics of the build are controlled using the `gradle.properties` file.

### Configuration Metadata

Configuration metadata allows you to export collection of CAS properties as a report into a file 
that can later be examined. You will find a full list of CAS settings along with notes, types, default and accepted values:

```bash
./gradlew exportConfigMetadata
```                           

## Puppeteer

> [Puppeteer](https://pptr.dev/) is a Node.js library which provides a high-level API to control Chrome/Chromium over the DevTools Protocol.
> Puppeteer runs in headless mode by default, but can be configured to run in full (non-headless) Chrome/Chromium.

Puppeteer scenarios, used here as a form of acceptance testing, allow you to verify CAS functionality to address a particular authentication flow. The scenarios, which may be
found inside the `./puppeteer/scenarios` directory are designed as small Node.js scripts that spin up a headless browser and walk through a test scenario. You may
design your own test scenarios that verify functionality specific to your CAS deployment or feature.

To execute Puppeteer scenarios, run:

```bash
./puppeteer/run.sh
```

This will first attempt to build your CAS deployment, will install Puppeteer and all other needed libraries. It will then launch the CAS server,
and upon its availability, will iterate through defined scenarios and will execute them one at a time.

The following defaults are assumed:

- CAS will be available at `https://localhost:8443/cas/login`.
- The CAS overlay is prepped with an embedded server container, such as Apache Tomcat.

You may of course need to make adjustments to account for your specific environment and deployment settings, URLs, etc.


## Duct

`duct` is a Gradle task to do quick smoke tests of multi-node CAS high-availability deployments. In particular, it tests correctness of ticket
sharing between multiple individual CAS server nodes backed by distributed ticket registries such as Hazelcast, Redis, etc.

This task requires CAS server nodes to **enable the CAS REST module**. It will **NOT** work without it.

The task accepts the following properties:

- Arbitrary number of CAS server nodes specified via the `duct.cas.X` properties.
- URL of the service application registered with CAS specified via `duct.service`, for which tickets will be requested.
- `duct.username` and `duct.password` to use for authentication, when requesting ticket-granting tickets.

It automates the following scenario:

- Authenticate and issue a service ticket on one CAS node
- Validate this service ticket on the another node
- Repeat (You may cancel and stop the task at any time with `Ctrl+C`)

If the task succeeds, then we effectively have proven that the distributed ticket registry has been set up and deployed
correctly and that there are no connectivity issues between CAS nodes.

To run the task, you may use:

```bash
./gradlew duct
    -Pduct.cas.1=https://node1.example.org/cas \
    -Pduct.cas.2=https://node2.example.org/cas \
    -Pduct.cas.3=https://node3.example.org/cas \
    -Pduct.cas.4=https://node4.example.org/cas \
    -Pduct.service=https://apereo.github.io \
    -Pduct.username=casuser \
    -Pduct.password=Mellon
```

You may also supply the following options:

- `duct.debug`: Boolean flag to output debug and verbose logging.
- `duct.duration`: Number of seconds, i.e. `30` to execute the scenario.
- `duct.count`: Number of iterations, i.e. `5` to execute the scenario.


## OpenRewrite

[OpenRewrite](https://docs.openrewrite.org/) is a tool used by the CAS in form of a Gradle plugin
that allows the project to upgrade in place. It works by making changes to the project structure representing
your CAS build and printing the modified files back. Modifications are packaged together in form of upgrade
scripts called `Recipes` that are automatically packaged and presented to the build and may be discovered via:

```bash
./gradlew --init-script openrewrite.gradle rewriteDiscover -PtargetVersion=X.Y.Z --no-configuration-cache | grep "org.apereo.cas"
```

**NOTE:** All CAS specific recipes begin with `org.apereo.cas`. The `targetVersion` must be the CAS version to which you want to upgrade.

OpenRewrite recipes make minimally invasive changes to your CAS build allowing you to upgrade from one version
to the next with minimal effort. The recipe contains *almost* everything that is required for a CAS build system to navigate
from one version to other and automated tedious aspects of the upgrade such as finding the correct versions of CAS,
relevant libraries and plugins as well as any possible structural changes to one's CAS build.

To run, you will need to find and select the name of the recipe first. Then, you can dry-run the selected recipes and see which files would be changed in the build log.
This does not alter your source files on disk at all. This goal can be used to preview the changes that would be made by the active recipes.

```bash
./gradlew --init-script openrewrite.gradle rewriteDryRun -PtargetVersion=X.Y.Z -DactiveRecipe=[recipe name] --no-configuration-cache
```

When you are ready, you can run the actual recipe:

```bash
./gradlew --init-script openrewrite.gradle rewriteRun -PtargetVersion=X.Y.Z -DactiveRecipe=[recipe name] --no-configuration-cache
```

This will run the selected recipes and apply the changes. This will write changes locally to your source files on disk.
Afterward, review the changes, and when you are comfortable with the changes, commit them.
The run goal generates warnings in the build log wherever it makes changes to source files.
