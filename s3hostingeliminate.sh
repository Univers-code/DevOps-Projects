#!/bin/bash

set -e

read -r -p "BUCKET NAME: " NOMBRE
read -r -p "REGION [us-east-1]: " REGION
REGION="${REGION:-us-east-1}"
BUCKET=$NOMBRE

# Confirmacion
echo "⚠️  Se eliminará permanentemente: $BUCKET"
read -r -p "¿Confirmas? (escribe 'si'): " CONFIRM
[[ "$CONFIRM" != "si" ]] && echo "Cancelado." && exit 0


# vaciar bucket
echo "Vaciando bucket..."
aws s3 rm s3://$BUCKET --recursive

# Eliminando el policy
echo "Eliminando la policy..."
aws s3api delete-bucket-policy --bucket $BUCKET


# Para restaurar el bloqueo automatico
echo "Colocando el block public access..."
aws s3api put-public-access-block --bucket $BUCKET --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true


# DEleting hosting.
echo "Eliminando el hosting web S3...."
aws s3api delete-bucket-website --bucket $BUCKET 

# Archivos locales
echo "Eliminando archivos locales..."
rm -f index.html error.html

# Eliminar bucket
echo "Eliminando bucket...."
aws s3api delete-bucket --bucket $BUCKET --region $REGION

echo "✓ Bucket $BUCKET eliminado correctamente!"