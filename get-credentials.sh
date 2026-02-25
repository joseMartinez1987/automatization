# scripts/fetch-env.sh

ENVIRONMENT=$1
PROJECT="easy/concurrency-test"

if [ -z "$ENVIRONMENT" ]; then
    echo "Uso: ./fetch-env.sh <enviroment name (staging|production|uat)>"
    exit 1
fi

echo "--- Descargando variables para $ENVIRONMENT ---"

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