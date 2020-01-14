ARG SUBTAG
FROM mcr.microsoft.com/dotnet/core-nightly/sdk:2.1${SUBTAG} AS builder
WORKDIR /src
COPY . /src
RUN dotnet publish /src --output /app

FROM mcr.microsoft.com/dotnet/core-nightly/aspnet:2.1${SUBTAG}
WORKDIR /app
COPY --from=builder /app /app
ENV ASPNETCORE_URLS http://*:80
ENTRYPOINT [ "dotnet", "/app/EmptyWeb.dll" ]
