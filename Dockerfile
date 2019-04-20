FROM  weiotcontainer.azurecr.io/microsoft/dotnet:2.1-sdk AS build-env
WORKDIR /app

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out

FROM  weiotcontainer.azurecr.io/microsoft/dotnet:2.1-aspnetcore-runtime-stretch-slim

WORKDIR /app

COPY --from=build-env /app/out ./
RUN useradd -ms /bin/bash moduleuser

USER moduleuser

ENTRYPOINT ["dotnet", "RestfulAPICore.dll"]
