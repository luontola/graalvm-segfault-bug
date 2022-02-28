# GraalVM segfault bug

**EDIT: snowflake-jdbc 3.13.15 fixes this bug**

**Issue:** https://github.com/oracle/graal/issues/4149

[Snowflake JDBC drivers](https://docs.snowflake.com/en/user-guide/jdbc.html) crash when compiled with GraalVM native
image. The last GraalVM release where it still worked was GraalVM 21.1.0.

The crash happens on the following line where `sun.misc.Unsafe.putObjectVolatile` is used to
set `jdk.internal.module.IllegalAccessLogger.logger` to `null`:
https://github.com/snowflakedb/snowflake-jdbc/blob/v3.13.12/src/main/java/net/snowflake/client/jdbc/SnowflakeDriver.java#L85

It can be reproduced by running `test.sh`. The file `output.log` contains the output of running it with the latest dev
build: https://github.com/graalvm/graalvm-ce-dev-builds/releases/tag/22.1.0-dev-20211221_0005
