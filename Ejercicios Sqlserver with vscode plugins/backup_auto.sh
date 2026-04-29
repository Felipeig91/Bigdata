#!/bin/bash

# Script para hacer backup de la BD SQL Server
# Uso: bash backup_auto.sh

BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="BD_BigData_Relacional_Errores_$BACKUP_DATE.bak"
BACKUP_DIR="/var/opt/mssql/backup"
LOCAL_BACKUP_PATH="/Users/firp-personal/Downloads/db/backups"

# Crear directorio de backups en el host si no existe
mkdir -p "$LOCAL_BACKUP_PATH"

echo "📦 Haciendo backup de BD_BigData_Relacional_Errores..."
echo "   Archivo: $BACKUP_FILE"

# Asegurar que el directorio de backup existe dentro del contenedor
docker exec sql_server_container mkdir -p "$BACKUP_DIR" 2>/dev/null

# Ejecutar backup dentro del contenedor directamente con SQL
docker exec sql_server_container bash -c "
cat << 'SQLEOF' | /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'k8nCPVsa!@#\$'
BACKUP DATABASE BD_BigData_Relacional_Errores 
TO DISK = '$BACKUP_DIR/$BACKUP_FILE'
WITH INIT, COMPRESSION;
GO
SQLEOF
" 2>/dev/null

# Esperar un momento para que se escriba el archivo
sleep 2

# Copiar archivo de backup del contenedor al host
echo "📥 Copiando backup al host..."
docker cp sql_server_container:$BACKUP_DIR/$BACKUP_FILE "$LOCAL_BACKUP_PATH/$BACKUP_FILE" 2>/dev/null

if [ -f "$LOCAL_BACKUP_PATH/$BACKUP_FILE" ]; then
    SIZE=$(du -h "$LOCAL_BACKUP_PATH/$BACKUP_FILE" | cut -f1)
    echo "✅ Backup completado!"
    echo "   📍 Ubicación: $LOCAL_BACKUP_PATH/$BACKUP_FILE"
    echo "   💾 Tamaño: $SIZE"
    exit 0
else
    echo "⚠️  Backup creado en el contenedor pero no se pudo copiar."
    echo "   Ubicación en contenedor: $BACKUP_DIR/$BACKUP_FILE"
    echo "   Puedes copiar manualmente con:"
    echo "   docker cp sql_server_container:$BACKUP_DIR/$BACKUP_FILE $LOCAL_BACKUP_PATH/"
    exit 0
fi
