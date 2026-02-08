#!/bin/bash

# Comprobar si se pasó un argumento
if [ -z "$1" ]; then
    echo "Uso: source borrar_interactivo.sh 'texto_a_buscar'"
    return 1 2>/dev/null || exit 1
fi

# 1. Buscar y mostrar lo encontrado
echo "Buscando coincidencias para: '$1'..."
echo "------------------------------------------------"
# Guardamos las líneas completas para mostrar al usuario
coincidencias=$(history | grep -i "$1" | grep -v "source borrar_interactivo.sh")

if [ -z "$coincidencias" ]; then
    echo "No se encontraron coincidencias."
    return 0 2>/dev/null || exit 0
fi

echo "$coincidencias"
echo "------------------------------------------------"

# 2. Preguntar al usuario
# Usamos /dev/tty para que 'read' funcione correctamente dentro de un 'source'
echo -n "¿Deseas eliminar estas entradas? (s/n): "
read -r respuesta < /dev/tty

if [[ "$respuesta" =~ ^[sS]$ ]]; then
    # Obtener IDs en orden inverso
    ids=$(echo "$coincidencias" | awk '{print $1}' | sort -nr)
    
    for id in $ids; do
        history -d "$id"
    done
    
    # Guardar cambios en el archivo físico
    history -w
    echo "Eliminación completada y sincronizada con el disco."
else
    echo "Operación cancelada."
fi
