#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Memoria.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */
	const char* cadena = "Hola desde ASM\0";
    const char* nombreArchivo = "test_output.txt";

    // Abrir archivo para escritura
    FILE* archivo = fopen(nombreArchivo, "w");
    if (!archivo) {
        perror("No se pudo abrir el archivo");
        return 1;
    }

    // Llamar a la función en ASM
    strPrint(cadena, archivo);

    // Cerrar archivo para asegurar que se escriba
    fclose(archivo);
	return 0;
}
