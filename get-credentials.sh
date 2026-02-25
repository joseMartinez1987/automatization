# scripts/fetch-env.sh

ENVIRONMENT=$1
PROJECT="concurrency-test"

if [ -z "$ENVIRONMENT" ]; then
    echo "Uso: ./fetch-env.sh main"
    exit 1
fi

echo "--- Descargando variables para $ENVIRONMENT ---"

# 1. Obtener parámetros de AWS
# 2. Limpiar el path (/mi-proyecto/staging/VARIABLE -> VARIABLE)
# 3. Formatear como KEY=VALUE
aws ssm get-parameters-by-path \
    --path "/$PROJECT/$ENVIRONMENT/" \
    --recursive \
    --with-decryption \
    --query "Parameters[*].[Name,Value]" \
    --output text | awk -v path="/$PROJECT/$ENVIRONMENT/" '{
        gsub(path, "", $1); 
        print $1"="$2
    }' > .env.$ENVIRONMENT

echo "✅ Archivo .env.$ENVIRONMENT generado con éxito."