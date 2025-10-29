# ===== Build stage =====
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# คัดลอกไฟล์โครงสร้างก่อนเพื่อให้ cache ทำงานดี
COPY *.sln . 
COPY *.csproj ./
RUN dotnet restore

# คัดลอกที่เหลือแล้ว publish
COPY . .
RUN dotnet publish -c Release -o /app/publish

# ===== Runtime stage (เล็ก/เบากว่า) =====
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
# ถ้าไม่ใช้ HTTPS ในคอนเทนเนอร์ ให้ปิด Redirect ได้ใน appsettings หรือโค้ด
COPY --from=build /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "FrontJenkin.dll"]
