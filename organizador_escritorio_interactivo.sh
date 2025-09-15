#!/bin/bash

# Rutas
DESKTOP="$HOME/Escritorio"
DESTINO="$DESKTOP/Organizado"

# Diccionario de categorías
declare -A CATEGORIAS=(
    ["Imágenes"]="jpg jpeg png gif webp"
    ["PDFs"]="pdf"
    ["Comprimidos"]="zip rar tar gz 7z"
    ["Scripts"]="sh py pl exe"
    ["Media"]="mp4 avi flv"
    ["Texto"]="csv txt"
    ["Docs"]="docx odt"
    ["Hojas"]="xlsx ods"
)

# Mostrar categorías actuales
echo "📁 Categorías actuales:"
for categoria in "${!CATEGORIAS[@]}"; do
    echo "- $categoria: ${CATEGORIAS[$categoria]}"
done

# Preguntar si se quiere agregar nueva categoría
read -p "¿Deseas agregar una nueva categoría? (s/n): " RESPUESTA
if [[ "$RESPUESTA" =~ ^[sS]$ ]]; then
    read -p "Nombre de la nueva categoría: " NUEVA_CAT
    read -p "Extensiones asociadas (separadas por espacio, sin punto, ej: txt md): " NUEVAS_EXT
    CATEGORIAS["$NUEVA_CAT"]="$NUEVAS_EXT"
    echo "✅ Categoría '$NUEVA_CAT' agregada con extensiones: $NUEVAS_EXT"
fi

# Crear carpetas necesarias
mkdir -p "$DESTINO"
for categoria in "${!CATEGORIAS[@]}"; do
    mkdir -p "$DESTINO/$categoria"
done
mkdir -p "$DESTINO/Otros"

# Clasificación
echo "🗂️ Organizándote el escritorio..."
for archivo in "$DESKTOP"/*; do
    [ -f "$archivo" ] || continue
    extension="${archivo##*.}"
    encontrado=false
    for categoria in "${!CATEGORIAS[@]}"; do
        for ext in ${CATEGORIAS[$categoria]}; do
            if [[ "$extension" == "$ext" ]]; then
                mv "$archivo" "$DESTINO/$categoria/"
                encontrado=true
                break 2
            fi
        done
    done
    if [ "$encontrado" = false ]; then
        mv "$archivo" "$DESTINO/Otros/"
    fi
done

echo "✅ Escritorio organizado correctamente."
