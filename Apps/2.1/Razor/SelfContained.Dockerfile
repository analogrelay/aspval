ARG SUBTAG
FROM mcr.microsoft.com/dotnet/core-nightly/sdk:3.1${SUBTAG} AS builder
WORKDIR /src
COPY . /src
RUN dotnet publish /src --output /app --runtime linux-musl-x64

FROM mcr.microsoft.com/dotnet/core-nightly/runtime-deps:3.1${SUBTAG}
WORKDIR /app
COPY --from=builder /app /app
ENV ASPNETCORE_URLS http://*:80
ENTRYPOINT [ "/app/Razor" ]
