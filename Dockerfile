# 构建阶段
FROM openjdk:17-slim AS build
WORKDIR /usr/app
COPY . .
# 确保 mvnw 有执行权限
RUN chmod +x mvnw
# 使用缓存提高构建速度
RUN --mount=type=cache,target=/root/.m2 ./mvnw -f pom.xml clean package

# 运行阶段
FROM openjdk:17-slim
# 明确指定 JAR 文件路径
ARG JAR_FILE=/usr/app/target/*.jar
# 创建应用目录
RUN mkdir -p /app
# 从构建阶段复制 JAR 文件
COPY --from=build ${JAR_FILE} /app/runner.jar
# 暴露端口
EXPOSE 8088
# 启动命令
ENTRYPOINT ["java", "-jar", "/app/runner.jar"]