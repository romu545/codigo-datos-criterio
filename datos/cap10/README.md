# Datos del capítulo 10: Guardar y compartir los datos

Esta carpeta **no tiene datos de entrada**: todo lo que contiene lo escribe el capítulo al ejecutarse, a partir de la cartera limpia (`datos/cap08/`), las sucursales (`datos/cap07/`) y los clientes (`datos/cap06/`). Se puede borrar en cualquier momento; el capítulo la vuelve a crear.

| Archivo o carpeta | Ejemplo | Contenido |
|---|---|---|
| `cartera_analitica.parquet` y `cartera_analitica_diccionario.csv` | 10.1 | La cartera con sucursal y región, con metadatos, y su diccionario de datos |
| `prueba_ida_vuelta.*` | 10.1 | La prueba de guardar y volver a leer en CSV y en Parquet |
| `cierres/` y `almacen.duckdb` | 10.2 y 10.3 | Los cierres mensuales, particionados por corte y en una base DuckDB |
| `cierres_agregados.csv` | 10.2 | La forma frágil: marzo cargado dos veces |
| `por_sucursal/` | 10.4 | Un CSV por sucursal para Excel y el manifiesto |
| `cartera_pendiente_2026-03-31.xlsx` | 10.5 | Un libro con una hoja de resumen y una hoja por sucursal |
| `cartera_contable_2026-03-31.csv` | 10.6 | El CSV con contrato para el sistema contable |

Los archivos con sufijo `_py` o `_duckdb` son las versiones de las pestañas de Python y DuckDB.

Si reportas un error en los datos o en el libro, hazlo en el [repositorio del libro](https://github.com/romu545/codigo-datos-criterio/issues).
