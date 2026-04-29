#!/bin/bash

echo "🛑 Deteniendo contenedor SQL Server..."
docker stop sql_server_container

echo "📦 Creando volumen persistente..."
docker volume create sqlserver_data

echo "🔄 Removiendo contenedor antiguo..."
docker rm sql_server_container

echo "✅ Recreando contenedor con volumen persistente..."
docker run -e "ACCEPT_EULA=Y" \
  -e "SA_PASSWORD=k8nCPVsa!@#$" \
  -p 1433:1433 \
  -v sqlserver_data:/var/opt/mssql/data \
  --name sql_server_container \
  -d mcr.microsoft.com/mssql/server:2025-latest

echo "⏳ Esperando a que SQL Server inicie..."
sleep 10

echo "✓ Contenedor recreado con volumen persistente!"
echo ""
echo "Verifica el estado:"
docker ps -a | grep sql_server_container
docker volume ls | grep sqlserver_data
