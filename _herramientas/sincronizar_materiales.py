"""Copia los datos y el código de práctica del libro al repositorio de materiales.

El repositorio del libro es la fuente. Este script copia, en un solo sentido,
los archivos que git sigue en el libro y que el lector necesita, con las
mismas rutas, para que el código del libro funcione igual en materiales.

Uso, desde la raíz del libro:

    python _herramientas/sincronizar_materiales.py            # solo muestra
    python _herramientas/sincronizar_materiales.py --aplicar  # copia

Por defecto busca materiales en ../codigo-datos-criterio-material; otra ruta
se indica con --destino. Nunca borra archivos: los que están en materiales y
ya no existen en el libro se listan como huérfanos para revisarlos a mano.
"""

import argparse
import filecmp
import shutil
import subprocess
from pathlib import Path

# Qué se copia: prefijos de ruta, relativos a la raíz del libro.
INCLUIR = (
    "datos/",
    "scripts/",
    "tests/",
    "reportes/",
    "air.toml",
    "ruff.toml",
)

# Qué no se copia aunque esté en esas carpetas.
EXCLUIR = (
    "datos/cap10/",  # todo son salidas del capítulo 10; el lector las genera
    "scripts/portada.R",  # herramienta del libro, no material de práctica
)

# Carpetas de materiales donde se buscan huérfanos.
REVISAR_HUERFANOS = ("datos/", "scripts/", "tests/", "reportes/")


def archivos_del_libro(raiz):
    salida = subprocess.run(
        ["git", "ls-files"],
        cwd=raiz,
        capture_output=True,
        text=True,
        encoding="utf-8",
        check=True,
    ).stdout.splitlines()
    return sorted(
        ruta
        for ruta in salida
        if ruta.startswith(INCLUIR) and not ruta.startswith(EXCLUIR)
    )


def iguales(a, b):
    """Compara el contenido sin tener en cuenta los finales de línea."""
    if filecmp.cmp(a, b, shallow=False):
        return True
    return a.read_bytes().replace(b"\r\n", b"\n") == b.read_bytes().replace(
        b"\r\n", b"\n"
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--destino", default="../codigo-datos-criterio-material"
    )
    parser.add_argument("--aplicar", action="store_true")
    args = parser.parse_args()

    libro = Path(__file__).resolve().parent.parent
    destino = (libro / args.destino).resolve()
    if not (destino / ".git").exists():
        raise SystemExit(
            f"No encuentro el repositorio de materiales en {destino}"
        )

    rutas = archivos_del_libro(libro)
    nuevos, cambiados = [], []
    for ruta in rutas:
        origen, copia = libro / ruta, destino / ruta
        if not copia.exists():
            nuevos.append(ruta)
        elif not iguales(origen, copia):
            cambiados.append(ruta)

    huerfanos = sorted(
        str(p.relative_to(destino)).replace("\\", "/")
        for carpeta in REVISAR_HUERFANOS
        if (destino / carpeta).exists()
        for p in (destino / carpeta).rglob("*")
        if p.is_file()
        and "__pycache__" not in p.parts
        and str(p.relative_to(destino)).replace("\\", "/") not in rutas
    )

    for titulo, lista in [
        ("Nuevos", nuevos),
        ("Cambiados", cambiados),
        ("Huérfanos (no se tocan)", huerfanos),
    ]:
        print(f"\n{titulo}: {len(lista)}")
        for ruta in lista:
            print(f"  {ruta}")

    if not args.aplicar:
        print("\nNo se copió nada. Para copiar, agrega --aplicar.")
        return
    for ruta in nuevos + cambiados:
        (destino / ruta).parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(libro / ruta, destino / ruta)
    print(f"\nCopiados {len(nuevos) + len(cambiados)} archivos a {destino}")


if __name__ == "__main__":
    main()
