#!/usr/bin/env bash
set -euxo pipefail
export GRAAL_HOME=~/Downloads/graalvm-ce-java11-22.1.0-dev/Contents/Home

mvn clean package

# GraalVM native-image fails because java.nio.file.Files$FileTypeDetectors.<clinit>
# is initialized at build time, but it loads net.snowflake.client.core.FileTypeDetector
# which loads javax.xml.parsers.FactoryFinder and jdk.xml.internal.SecuritySupport
# which should be initialized at runtime.
# As workaround, exclude the service file which comes with snowflake-jdbc.jar
zip target/graalvm-segfault-bug-0.1.0.jar -d META-INF/services/java.nio.file.spi.FileTypeDetector

#$GRAAL_HOME/bin/java \
#  -agentlib:native-image-agent=config-merge-dir=src/main/resources/META-INF/native-image/generated,config-write-period-secs=5 \
#  -jar target/graalvm-segfault-bug-0.1.0.jar

: Running with GraalVM
$GRAAL_HOME/bin/java -jar target/graalvm-segfault-bug-0.1.0.jar

: Compile with native image
$GRAAL_HOME/bin/native-image \
    --no-fallback \
    --report-unsupported-elements-at-runtime \
    --allow-incomplete-classpath \
    -H:+ReportExceptionStackTraces \
    -jar target/graalvm-segfault-bug-0.1.0.jar \
    target/graalvm-segfault-bug

: Running native app
./target/graalvm-segfault-bug
