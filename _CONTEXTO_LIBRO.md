# Pendientes y contexto del libro

> Archivo de trabajo, no forma parte del libro. Empieza con `_` para que Quarto no lo renderice (no está en `chapters`). Sirve para retomar el proyecto sin perder las decisiones tomadas.

## Contexto

- **Título:** Código, datos y criterio. **Autor:** Rafael Mendoza. **Idioma:** español (`es-CO`).
- **Enfoque:** análisis de datos de principio a fin, práctico y reproducible. R es el lenguaje principal y Python aparece en pestañas para comparar. También se usan SQL (DuckDB) y PowerShell.
- **Herramientas del entorno:** Positron, R, Python (instalado con `uv`), DuckDB. Git es opcional al inicio.
- **Sistemas operativos:** Windows (`winget`) y macOS (instaladores oficiales o Homebrew).
- **Ritmo de construcción (autor):** bloques de trabajo de aproximadamente dos horas por sesión para avanzar en la redacción y materiales. El lector avanza a su propio ritmo, ya sea por capítulo completo o por secciones específicas. Las dos horas **no son una regla** para la extensión de un capítulo (decisión nov. 2026): un tema puede necesitar más tiempo; desde el Cap. 9 los capítulos no dicen cuánto duran.

## Repositorios y flujo de trabajo

- Libro (público): `https://github.com/romu545/codigo-datos-criterio`
- Materiales (público): `https://github.com/romu545/codigo-datos-criterio-material`
- Los issues se reportan en el repositorio del libro.
- `main` está protegida: todo cambio entra por rama + pull request (`gh pr create --fill`, `gh pr merge --squash --delete-branch`).
- No proteger la rama `gh-pages` si se publica con `quarto publish gh-pages`.

## Licencias

- Texto del libro: CC BY-NC-SA 4.0.
- Código de los materiales: MIT.
- Datos: conservan la licencia de su fuente; documentarla en el README del repositorio de materiales.

## Estructura (la introducción es el capítulo 1)

2. Fundamentos y preparación del entorno
Partes (Quarto `part:`): I Punto de partida (1-2), II Obtener los datos (3-5), III Preparar y guardar los datos (6-10), IV Analizar y programar (11-13), V Automatizar, comunicar y mantener (14-16). El número de cada archivo coincide con su capítulo.

3. Importación de datos I: el contrato de lectura (`03-importacion-de-datos.qmd`)
4. Importación de datos II: formatos y fuentes (`04-importacion-formatos-y-fuentes.qmd`)
5. Importación de datos III: limpieza temprana (`05-importacion-limpieza-temprana.qmd`)
6. Tipos de datos y calidad
7. Transformación y limpieza I: transformar y ordenar (`07-transformacion-y-ordenado.qmd`)
8. Transformación y limpieza II: limpiar (`08-limpieza-de-datos.qmd`)
9. Transformación y limpieza III: transformar a escala (`09-transformar-a-escala.qmd`)
10. Guardar y compartir los datos (`10-guardar-y-compartir-datos.qmd`)
11. Estadística descriptiva, exploración y gráficos
12. Funciones personalizadas
13. Flujos reproducibles y depuración
14. Automatización y programación de tareas
15. Reportes reproducibles y comunicación
16. Pruebas, seguridad, publicación y mantenimiento

## Decisiones de alcance y avance: capítulos 3 y 4 (Importación de datos)

### Decisiones cerradas

- **Capítulo 13, Flujos reproducibles y depuración (nov. 2026):** apertura narrativa (3 de abril: llega el archivo de abril y el script falla con `Can't combine ..3$fecha <date> and ..4$fecha <character>`). Reproducibilidad (tabla de dependencias: datos, rutas, orden, estado de la sesión, azar, versiones con `renv`/`uv.lock`, pasos manuales). Flujo como tubería (*pipeline*): pasos con nombre en `scripts/flujo_entregas.R` y `.py` (leer como texto, armonizar, validar como punto de control, resumir, guardar), `ejecutar_flujo()` con bitácora (`message()`/`logging`) y errores con el nombre del paso; equivalente a `reduce()`. DuckDB como cadena de vistas. Sesión limpia con `Rscript` vía `system2()` (objeto no encontrado) y `subprocess` en Python; `sys.nframe() == 0` como `__main__`. Rehacer solo lo que cambió (`file.mtime()`, `mmap = FALSE` por Windows), `targets` (sin instalar, código `eval: false`), Snakemake, `make`. Depurar con método en cinco pasos (leer el mensaje, reproducir con lo mínimo, aislar, corregir, blindar); abril trae dos cambios (fecha dd/mm/aaaa y `tiempo_entrega_min`); R falla con error críptico, `pandas` une en silencio (1.312 tiempos vacíos), DuckDB da el mejor mensaje; con validación, el flujo se detiene con «820 fechas sin leer en entregas_2026_04.csv». Herramientas: `traceback()`, `rlang::last_trace()`, `browser()`, `debugonce()`, `options(error = recover)`, `breakpoint()`, `pdb.pm()`, puntos de interrupción de Positron, `reprex`. Diagramas `imagenes/flujos/` (`flujo`, `incremental`, `depurar`). Datos `datos/cap13/` (generador `scripts/generar_datos_cap13.R`, depende de `datos/cap11/`).
- **Revisión de diagramas anteriores (nov. 2026):** se quitaron de `mapa-importacion.svg` las etiquetas «una sesión de unas 2 horas». Candidatos a rehacer con el estilo explicativo (mecanismo, pasos numerados, valores reales): `transformacion/volumen.svg` (solo cajas de texto), `calidad/flujo-auditoria.svg` y `limpieza/flujo-limpieza.svg` (agregar cifras reales: 55 facturas con problemas, 379 limpias, 23 en cuarentena), `importacion/flujo-hibrido.svg` y `guardar/capas.svg` (abstractos), `transformacion/verbos.svg` (cuadros sin valores). Los demás ya muestran el mecanismo con ejemplos concretos.
- **Capítulo 12, Funciones propias (nov. 2026):** abre con la pregunta de dónde saca una regla de calidad las variables `inicio` y `corte` (alcance), y con la tabla de funciones escritas en los Cap. 3 a 11, para mostrar que el tema no se sale del hilo del libro. Anatomía (diagrama `imagenes/funciones/anatomia.svg`), `tasa()` vectorizada, `None` sin `return` en Python, macros de DuckDB (`:=` para valores por defecto, macros de tabla). Argumentos por posición y nombre, coincidencia parcial de R, `...` (parámetros después de `...` solo por nombre), `*args`/`**kwargs`, `/` y `*` en Python, `do.call()`, `with()`, desempaque con `*` y `**`; políticas de inventario con `pmap_dbl()`. Funciones anónimas (`\(x)`, `function`, `~ .x`, `lambda`), llamada inmediata `(\() {...})()` frente a `local()`, anónima en el *pipe*. Orden superior y fábricas (`regla_rango()`; `Map`, `Filter`, `Reduce`, `Position`; `functools.partial`; `list_transform` en DuckDB). Alcance léxico y clausuras (diagrama `alcance.svg`), variables globales, trampas (funciones creadas en un `for`, `lambda` en comprensiones, valores por defecto mutables en Python, LEGB, `<<-`). Validación (`stopifnot` con nombres, `match.arg`, `raise`, anotaciones de tipo no comprobadas, `error()` en DuckDB); clase S3 `politica_inventario` con `print`; `@dataclass(frozen=True)` con `__post_init__` (sin él no valida tipos; `pydantic` como opción). Criterio sobre clases: pocas y pequeñas (configuración con reglas, resultados con su propio print, paquetes); S3, S4, R6, S7. Organizar: `source()` frente a `import` (espacio de nombres), `#'` de roxygen2, docstrings, hacia paquetes (`usethis`, `devtools::load_all`, `uv init --package`). Diagramas rehechos para explicar el mecanismo (anatomía con el recorrido de una llamada; alcance con un `minimo = 100` global que nunca se consulta) y uno nuevo, `orden-superior.svg`. Subsección de evaluación perezosa (argumento no usado no se evalúa; valor por defecto que depende de otro argumento; `force()` en fábricas, tercera trampa del alcance). Sección «Para profundizar» con citas a `wickham2023` (R4DS 2.ª ed.) y `wickham2019` (Advanced R 2.ª ed.) y enlaces al tutorial de Python y a `dataclasses`. Nuevos `scripts/inventario.R` y `scripts/inventario.py` (con `nueva_politica()`, `simular_con()`, `PoliticaInventario`). Cap. 11 ampliado con facetas, matriz de pares (`pairs()` de R base y `sns.pairplot`), mapa de calor de correlaciones y calendario; DuckDB sin pestaña en esa sección (no dibuja). Hallazgo del Cap. 11: unidades y valor del pedido no se relacionan (pregunta para la fuente).
- **Capítulo 11, Explorar los datos (nov. 2026):** abre la parte «Analizar y programar» con el mito del 80 % (citas formales: `wickham2014`, `gelman2013`; menciones con enlace: Lohr/NYT 2014, CrowdFlower 2016, Dodds 2020, Anaconda 2020). Gráficos de trabajo, no para comunicar (solo `theme_minimal()`). Guía de preguntas (@tbl-guia-explorar): qué es una fila, faltantes (no aplica, azar, informativo; mapa de faltantes con `geom_tile`; promedio ponderado por pedidos), centro y dispersión (media, recortada, mediana, sd, IQR, MAD con 1,4826; robustez), forma (histograma: escala log y ancho de intervalo; ECDF), cuarteto de Anscombe (base R) y mención del Datasaurus, comparar grupos (boxplot de Tukey frente a violín + `geom_jitter` + n; menciones de raincloud/`ggdist`, beeswarm, ridgeline), categorías (torta frente a puntos ordenados, cita `cleveland1984`; mapa de calor de proporciones), relaciones (Pearson frente a Spearman; `geom_bin2d`/`geom_hex` para muchos puntos). DuckDB: `SUMMARIZE`, histogramas de texto con `bar()`, Spearman con `rank()`. Python con `seaborn` (instalado en el entorno de Positron: seaborn 0.13.2, matplotlib 3.11.2; los bloques de Python no muestran imágenes, se verificaron con backend Agg). En R solo `ggplot2` y `forcats` (sin `ggdist`, `ggridges`, `naniar`, `skimr`). Datos `datos/cap11/entregas_2026_t1.parquet` (generador `scripts/generar_datos_cap11.R`) con patrones sembrados: S03 bimodal (moto y transportadora; hueco entre 9 y 18 h), S07 con 11 pedidos (9 con tiempo), faltantes estructurales en retiro, calificación faltante informativa (46 % en tardías frente a 15 %), seis pedidos corporativos. `pandas` necesita `scipy` para `corr(method="spearman")`; se usó `rank()`.
- **Capítulo 10, Guardar y compartir los datos (nov. 2026):** reemplaza a los antiguos «Estructuras, formatos y almacenamiento» y «Exportación de datos» (los formatos ya están en el Cap. 4). Hilo: ¿quién va a leer esto? Guardar (para el propio proceso), compartir (datos para compañeros u otras herramientas) y comunicar (reportes y observaciones, que van al capítulo de reportes con muchas más funciones de `openxlsx2`; en Python, `XlsxWriter`). Primera mitad: capas cruda/limpia/analítica; ida y vuelta (Parquet idéntico; CSV depende del lector: `read_csv()` acierta, `read.csv()` pierde ceros y fechas, `pandas` también); metadatos Parquet (`arrow_table()$metadata`, `replace_schema_metadata`, `KV_METADATA`/`parquet_kv_metadata`) y diccionario de datos; idempotencia (agregar a un CSV duplica; `write_dataset(existing_data_behavior = "delete_matching")`; DuckDB con clave primaria y `DELETE`+`INSERT BY NAME` en transacción); historia de cierres (94, 141 y 201 facturas pendientes en ene, feb y mar; cartera por edades) y dimensiones lentamente cambiantes. Segunda mitad: un archivo por sucursal (`split()`+`iwalk()`, `nest()`+`pwalk()` como tabla de envíos y manifiesto, partición), comprobaciones leyendo los archivos (`all()` de un vector vacío es `TRUE`), Excel con una hoja por grupo (`write_xlsx()` con lista; `pd.ExcelWriter`; DuckDB escribe una sola hoja por archivo), CSV con contrato para un sistema (pesos enteros: los valores tienen centavos; `pandas` y DuckDB escriben `.0`), nota de Power BI (Parquet en modelo estrella). La apertura enumera los caminos posibles de los datos y sirve de mapa del resto del libro. Salidas en `datos/cap10/` (sin datos de entrada). Diagramas en `imagenes/guardar/` (`capas`, `repartir`). En Windows, un Parquet leído queda mapeado y no se puede sobrescribir en la misma sesión (recuadro en el Ejemplo 10.1). La columna de partición vuelve como texto. El libro queda con 16 capítulos.
- **Capítulo 9, Transformar a escala (nov. 2026):** tercer capítulo de transformación, sobre la repetición: muchas columnas (`across()` con `.names`, `lapply()` sobre columnas, `COLUMNS()` con renombre ``), muchas tablas (`reduce()`/`accumulate()` con `.init`, `Reduce()`, `functools.reduce`, `itertools.accumulate`; el valor inicial define cuántas filas debe tener el resultado), uniones por desigualdad (`join_by(closest())` y rangos, `merge_asof()` y `pd.cut()`, `ASOF JOIN`), completar la estructura (`complete()`, `reindex()`, `CROSS JOIN`; el universo lo define el negocio), columnas-lista (`nest()` + `map()` + `lm`, `groupby().apply()`, `regr_slope()` y `list()` en DuckDB) e iterar con criterio (vectorizar, `map`/`vapply` o bucle; `sapply()` inestable; copia al modificar celda por celda; simulación de inventario como bucle necesario; `safely()` y `try/except` para reunir errores). **Apertura distinta:** empieza con código copiado y pegado, no con el resumen del capítulo anterior. Datos en `datos/cap09/` (generador `scripts/generar_datos_cap09.R`, depende de `datos/cap07/`). Diagramas en `imagenes/escala/` (`reducir`, `anidar`, `elegir-iteracion`). El resto del libro se corrió un número; con el Cap. 10 nuevo el libro quedó en 16 capítulos. Detalle de pandas 3: `merge_asof()` exige la misma resolución de fecha (`datetime64[us]` del Parquet frente a `[s]` del CSV). DuckDB 2.0: `store_rejects` no se puede combinar con `union_by_name`.
- **Transformación y limpieza dividida en dos capítulos (nov. 2026):** Cap. 7 *Transformar y ordenar*: las seis operaciones en sus escrituras (corchetes, `$`, `transform()`, `subset()`, `dplyr`; corchetes, `.loc`, punto, `assign()`, `query()`, `case_when()` en pandas; SQL con `SELECT * REPLACE`, `COLUMNS()`), trampa del `NA` en corchetes, `transform()` no ve columnas creadas en la misma llamada, asignación encadenada inútil en pandas 3 (Copy-on-Write), resumir frente a calcular dentro del grupo (`.by`, `transform`, `OVER`, `QUALIFY`), uniones con `relationship`/`validate` y una clave repetida sembrada (`P07`), largo y ancho (`pivot_longer/wider`, `melt/pivot`, `UNPIVOT/PIVOT`), `separate_wider_*`/`separate_longer_*`, y volumen con 10 millones de filas (dplyr, data.table, arrow, DuckDB, pandas, polars). Cap. 8 *Limpiar*: principios (crudo intacto, reglas, cuarentena, bitácora, medir antes y después), texto, expresiones regulares (DuckDB/RE2 sin *lookahead*), estandarizar por frecuencia con clave normalizada + distancia de edición + tabla de equivalencias manual, consolidar duplicados por columna, completar faltantes solo desde una referencia, imposibles frente a atípicos (IQR), y limpieza completa de la cartera del Cap. 6 (379 limpias, 23 en cuarentena, 4 copias) con nueva auditoría reutilizando `scripts/auditoria_cartera.R` y `.py`. Datos en `datos/cap07/` y `datos/cap08/` (generadores `scripts/generar_datos_cap07.R` y `cap08.R`). Diagramas en `imagenes/transformacion/` (verbos, uniones, largo-ancho, separar, volumen) e `imagenes/limpieza/` (flujo-limpieza, estandarizar). El resto del libro se corrió un número (16 capítulos).
- **DuckDB 2.0:** las funciones anónimas se escriben `lambda x: ...`; la flecha `x -> ...` da error.
- **Capítulo 6, Tipos de datos y calidad (nov. 2026):** primera parte sobre tipos (equivalencias entre herramientas, coerción con conteo de faltantes nuevos, coma flotante y `DECIMAL`, límite de enteros de 32 bits, identificadores como texto, categorías como regla de calidad con `factor`/`isin()`/`ENUM`); segunda parte sobre calidad con el método perfil, reglas, reporte y decisión. Regla del capítulo: **medir antes de corregir**; el Cap. 6 mide y marca, el Cap. 7 corrige. Dimensiones: completitud, unicidad, validez, consistencia, integridad referencial y plausibilidad (la exactitud solo se comprueba contra una fuente externa). Las reglas se escriben como datos (`tribble` con funciones en R, lista de tuplas con `lambda` en Python, `count_if` + `UNPIVOT` en DuckDB), con severidad `bloquea`/`advierte`; las reglas de validez dejan pasar los faltantes de forma explícita. Ejemplos 6.1 a 6.7 y Ejercicio 6.1 con `datos/cap06/` (`cartera_2026_t1.parquet`, `clientes.parquet`, `recaudos_2026_t1.parquet`), generados con `scripts/generar_datos_cap06.R`. Salida para el Cap. 7: `cartera_2026_t1_auditada.parquet` con la columna `problemas`. Diagramas en `imagenes/calidad/`: `coercion`, `elegir-tipo`, `dimensiones-calidad`, `flujo-auditoria`.
- **SQL en texto crudo (nov. 2026):** desde el Cap. 6, el SQL enviado desde R va en `r"(...)"`. El Cap. 6 tiene la píldora de curiosidades sobre texto crudo en R, Python (`r"..."`, `"""..."""`) y DuckDB (`$$...$$`). Los Cap. 3 a 5 todavía usan comillas normales con `\"`.
- **Idioma de Quarto (nov. 2026):** `lang: es` va en el nivel superior de `_quarto.yml` (el `language: es` dentro de `book:` no tenía efecto y las referencias salían como «Chapter» y «Figure»). Como las secciones se muestran como «Sección 5.4», el artículo antes de `@sec-` de una sección es femenino (`en la @sec-fechas`); antes de un capítulo, masculino (`en el @sec-importacion`).
- **Tercer capítulo de importación (nov. 2026):** Cap. 5 *Importación de datos III: limpieza temprana*, cierre de la importación y preámbulo de la limpieza. Criterio de frontera: lo que depende de cómo se escribió el dato se resuelve al leer (nombres de columnas, marcas de faltante por columna, sí/no a booleano con tabla de equivalencias, fechas con formato declarado y zona horaria, separadores numéricos, columnas vacías); lo que depende de lo que dice el dato (duplicados, categorías, valores imposibles, reglas de negocio) va a los Cap. 6 y 7. Ejemplos 5.1 a 5.6 y ejercicio 5.1 con `datos/cap05/` (`cartera_clientes_2026_02.csv`, `visitas_comerciales.xlsx`), generados con `scripts/generar_datos_cap05.R`. Diagramas: `limpieza-temprana-frontera`, `nombres-columnas`, `significados-na`, `fechas-por-lenguaje`, `columnas-vacias`; `mapa-importacion` pasó a tres paneles. El resto del libro se corrió un número (Tipos de datos y calidad es el Cap. 6).

- **Importación dividida en dos capítulos (nov. 2026, reemplaza la decisión de capítulo unificado):** Cap. 3 *Importación de datos I: el contrato de lectura* (criterio, ecosistema, heurística, múltiples archivos; ejemplos 3.1-3.2, ejercicio 3.1) y Cap. 4 *Importación de datos II: formatos y fuentes* (Excel, Parquet, JSON/APIs, BD, tabla de formatos e integrador; ejemplos 4.1-4.3, ejercicios 4.1-4.2). Cada uno corresponde a una sesión de ~2 horas. El resto del libro se corre un número (Tipos de datos y calidad pasa a ser el Cap. 5). Se descartó usar `part:` de Quarto porque en PDF agruparía bajo esa parte todos los capítulos siguientes.
- **Estilo editorial (nov. 2026):** diagramas en escala de grises, sin íconos, emojis, viñetas decorativas ni símbolos como ✓, ✗ o flechas dentro del texto; lo que se debe evitar se marca con trazo discontinuo y la palabra «Evitar». Los diagramas no llevan título interno (lo da el pie de figura). En la redacción no se usan guiones medios ni rayas (– —); los incisos van entre comas o paréntesis.
- **Diagramas:** SVG en `imagenes/inicio/` e `imagenes/importacion/`, insertados con `{#fig-...}` y `fig-alt`. Para el PDF, Quarto necesita `rsvg-convert` para convertir SVG.
- **Criterio e ingeniería de ingesta:**
  - Importar no es un trámite; define la fluidez del flujo y el consumo de RAM.
  - Nota aparte (`callout-note`) sobre **Power BI**: por qué delegar ingestas y transformaciones pesadas a R/Python en lugar de sobrecargar el lenguaje M (Power Query), dejando en Power BI solo el modelo estrella o copo de nieve (la integración interna queda fuera del alcance del libro).
  - Ecosistemas y dependencias: tensión entre reducir dependencias externas y usar estándares del mercado (`tidyverse`/`readr` + `vroom`, `data.table`, `collapse` en R; `pandas` y `polars` en Python; enlaces a documentación oficial).
  - **duckplyr (nov. 2026):** mencionado en un recuadro del Cap. 3 (ecosistema) y en la tabla de herramientas como alternativa para quien prefiere `dplyr` a SQL; ejemplo con `eval: false` para no sumar una dependencia obligatoria.
  - **DuckDB:** motor analítico OLAP embebido (en memoria o persistente), uso desde terminal, R o Python; postura explícita de que **no reemplaza** por completo a `tidyverse`/`pandas`/`polars`, sino que se usa en patrón híbrido (filtrar/reducir en disco antes de subir a RAM).
  - **Heurística de importación:** codificación (`UTF-8` vs. `Latin-1`), delimitadores, selección temprana de columnas, y cuándo importar todo como texto para proteger identificadores con ceros a la izquierda (cédulas, códigos DANE, NIT).
  - **Múltiples archivos:** rutas relativas, `glob`, `pattern`, nota anticipada sobre expresiones regulares (se profundizan en capítulos posteriores) y manejo de deriva de esquemas (*schema drift*, e.g., `vlr_total` vs. `valor_total`).
- **Formatos y fuentes:**
  - Archivos delimitados (CSV y TXT), Excel (hojas, rangos/filas a saltar, lectura desde DuckDB), JSON y APIs REST (tratados juntos + aplanamiento), Parquet y bases de datos.
  - Por qué no se recomiendan `RDS`, `RData` y `pickle`: solo se enseña Parquet como formato binario.
  - Tabla comparativa de formatos (`_tabla-formatos.qmd`) incluida al final del capítulo (`{{< include _tabla-formatos.qmd >}}`) con `@tbl-formatos` y `@tbl-escenarios`.
- **Diseño de datos y ejercicios del capítulo (`datos/cap03/`):**
  - Dominio transversal: *Operaciones comerciales y recaudos de una red regional de distribución (2024–2026)*.
  - Archivos definidos para crear en el repositorio de materiales: `ventas_2026_01.csv` (`Latin-1`, `;`, ceros a la izquierda), `lotes_mensuales/` (`recaudos_2025_10.csv` a `2026_01.csv` con *schema drift* + distractor `borrador_notas.csv`), `catalogo_sucursales.xlsx` (3 hojas, encabezado en fila 4), `ventas_historico_grande.csv` (~2.5M filas para benchmark CSV vs. Parquet), `respuesta_api_trm.json` y `operaciones.duckdb`.
  - Ejercicios definidos: Ejemplo/Ejercicio 3.1 (consolidación múltiple filtrando por patrón), Ejercicio 3.2 (benchmark CSV vs. Parquet en disco, lectura total y lectura de 2 columnas en R, Python y DuckDB), y Ejercicio 3.3 (proyecto integrador de cierre consolidando 4 fuentes en Parquet para el Cap. 4).
- **Entregable de redacción preparado:** Estructura completa y *prompt* maestro listos (`prompt_cap03_claude.md`) para generar el borrador con Claude.

### Fuera de alcance por ahora

- Servicios en la nube (Drive, OneDrive) y web scraping.

## Pendientes

**Alcance (actualización futura)**

- [ ] Decidir si se suma un segundo ámbito de análisis desde la parte IV (propuesta nov. 2026: datos abiertos reales, como calidad del aire o clima, Saber 11 o encuestas de hogares del DANE con factores de expansión), con copia fija en materiales, fecha de descarga y licencia.

- [ ] Ejercicio de web scraping con una página que lo permita (ética, `robots.txt`, términos de uso).
- [ ] Acceso a la nube (Drive, OneDrive).
- [ ] Otros formatos: XML, ancho fijo, SPSS/Stata/SAS, tablas en PDF, Google Sheets, YAML, SQLite.

**Contenido — Capítulo 3**

- [x] Generar el borrador del capítulo de importación y dividirlo en dos capítulos con diagramas.
- [x] Datos separados por capítulo (nov. 2026): `datos/cap03/` (ventas_2026_01.csv, lotes_mensuales/, chat) y `datos/cap04/` (catálogo y ventas por mes en Excel, JSON, operaciones.duckdb, archivos generados). Replicar en el repositorio de materiales y ajustar allí el generador de datos (el CSV grande ahora se genera con `scripts/generar_ventas_historico_grande.R` en `datos/cap04/`).
- [ ] Agregar `chat_soporte_sucursales.txt` (Ejemplo 3.3, creado a mano en el repositorio del libro) al script generador del repositorio de materiales.
- [x] Pestañas de DuckDB en R en todo el libro (decisión nov. 2026: R es el lenguaje principal; no se alterna con Python).
- [ ] Renderizar los Cap. 3 y 4: ahora sus bloques de R se ejecutan (el Cap. 4 además necesita `readxl`, `jsonlite`, `arrow` y `httr2`; la extensión `excel` de DuckDB se descarga con internet) (requiere `data.table`, `rematch2`, `DBI` y `duckdb` instalados y R 4.4 o superior por `use()`).
- [x] Archivos renombrados para coincidir con el número de capítulo (nov. 2026). Los esbozos vacíos que no corresponden a la estructura actual (`calidad-y-exploracion`, `expresiones-regulares`, `practica-integral`) quedaron en `_borradores/`.
- [x] Cap. 4: probado al renderizar (nov. 2026) con DuckDB 2.0: `read_xlsx` con `range`, `UNION ALL BY NAME` entre hojas y `openxlsx2::wb_to_df(start_row = 4)`. Se corrigió `range = 'A4:E'`, que sin `stop_at_empty = true` devolvía 1.048.572 filas vacías.
- [x] `ventas_2025_por_mes.xlsx` y `scripts/generar_ventas_historico_grande.R` copiados al repositorio de materiales (copia local, sin commit); el README de materiales tiene la sección «Cómo generar los datos».
- [ ] Actualizar los nombres comentados de los capítulos 6 a 15 en `_quarto.yml` cuando se creen.
- [x] Ajustar en `_tabla-formatos.qmd` la frase *"más adelante las mediremos con un ejercicio"* para que haga referencia al ejercicio de conversión a Parquet ya realizado en el capítulo.
- [ ] Crear los scripts generadores de `datos/cap03/` y `datos/cap04/` en `codigo-datos-criterio-material` (los archivos ya están copiados; faltan los scripts que los crean). Borrar de `datos/cap03/` de materiales los tres archivos de la estructura vieja (`catalogo_sucursales.xlsx`, `operaciones.duckdb`, `respuesta_api_trm.json`), que ahora viven en `datos/cap04/`, y hacer commit por rama + PR.
- [ ] Medir tamaños y tiempos reales de CSV frente a Parquet con `ventas_historico_grande.csv` para documentar resultados de referencia.
- [ ] Verificar referencias `@tbl-formatos`, `@tbl-escenarios` y `@sec-elegir-formato` al renderizar con Quarto.
- [ ] Revisar la nota sobre CVE-2024-27322 (RDS, corregida en R 4.4.0) al publicar el capítulo.

**Contenido — Capítulo 5**

- [x] `datos/cap05/` y `scripts/generar_datos_cap05.R` copiados al repositorio de materiales (copia local, sin commit).
- [x] Salidas de Python del Cap. 5 verificadas con pandas 3.1.1 en el entorno de Positron (se instalaron `openpyxl`, `pyarrow`, `duckdb`, `polars` y `requests`).
- [x] Id `sec-tipos-calidad` definido en `06-tipos-de-datos-y-calidad.qmd`.
- [x] Menciones en texto a «Capítulo 6» en los Cap. 3, 4 y 5 cambiadas por `@sec-tipos-calidad` (el Cap. 6 ya está en `_quarto.yml`).

**Contenido — Capítulo 6**

- [x] Capítulo redactado, renderizado y con las salidas de Python verificadas con pandas 3.1.1 (Parquet en pandas: `date32` llega como `object` y un entero con faltantes como `float64`; se convierten de forma explícita).
- [x] `datos/cap06/` y `scripts/generar_datos_cap06.R` copiados al repositorio de materiales (copia local, sin commit).
- [x] Limpieza de la cartera hecha en el Cap. 8 (parte de la cartera cruda y reutiliza las reglas del Cap. 6).
- [x] SQL de los Cap. 3 a 5 migrado a texto crudo; la píldora de curiosidades está en el Cap. 3.

**Contenido — Capítulos 7 y 8**

- [x] Capítulos redactados y renderizados; salidas de Python verificadas con pandas 3.1.1 y polars 2.2.
- [x] `datos/cap07/`, `datos/cap08/` y los scripts copiados al repositorio de materiales (copia local, sin commit).
- [x] (Resuelto en el Cap. 9, recuadro «Modificar una tabla celda por celda».) Para el capítulo de funciones o el de flujos (cuando aparezcan los bucles): copia al modificar en R y el bucle que modifica celda por celda. Medido en R 4.6 con 10.000 asignaciones: `df[i, "x"] <- i` 1,49 s y 763 MB; `df$x[i] <- i` 0,55 s y 382 MB; sobre una lista (`as.list(df)`) 6,4 ms y 91 KB; sobre un vector 2,8 ms. Crear una columna (`df$c <- df$a + df$b`) no copia las columnas existentes (copia superficial); la lista solo ahorra microsegundos. Verificar con `tracemem()`; contrastar con `data.table` (`:=`) y pandas (Copy-on-Write). Se decidió no incluirlo en el Cap. 7 por ser funcionamiento interno de R sin paralelo en Python ni DuckDB.
- [ ] Los tiempos del Ejemplo 7.7 son los de la máquina del autor; revisar el texto si se renderiza en otra máquina y cambia el orden de las herramientas.

**Contenido — Resto del libro**

- [x] Capítulo 9 creado (Transformar a escala).
- [x] Capítulo 10 creado (Guardar y compartir los datos).
- [x] Capítulo 11 creado (Explorar los datos).
- [x] Capítulo 12 creado (Funciones propias).
- [x] Capítulo 13 creado (Flujos reproducibles y depuración).
- [ ] Crear los capítulos 14 a 16 (hoy comentados en `_quarto.yml`).
- [ ] Decidir si los Cap. 1 y 3 a 8 siguen diciendo que están pensados para sesiones de dos horas.
- [ ] Rehacer los diagramas candidatos de la revisión de noviembre.
- [ ] Copiar `scripts/inventario.R` y `scripts/inventario.py` al repositorio de materiales.
- [ ] Agregar `seaborn` (y `scipy` si se usa) a las instrucciones del entorno de Python del Cap. 2.
- [ ] Copiar `datos/cap11/` y `scripts/generar_datos_cap11.R` al repositorio de materiales.
- [ ] Capítulo de reportes: formato de Excel con `openxlsx2` (anchos, estilos, totales, notas) y `XlsxWriter` en Python (agregarlo al entorno del libro).
- [ ] Copiar `datos/cap09/` y `scripts/generar_datos_cap09.R` al repositorio de materiales.
- [x] `references.bib` creado (nov. 2026) con `wickham2014` (citado en el Cap. 7, datos ordenados) y `gelman2013` (para el Cap. 11). `references.qmd` activo, con el título «Referencias». Criterio: citar formalmente solo un par de referencias por tema; las demás se mencionan en el texto con enlace.
- [x] (Hecho: apertura del Cap. 11 redactada.) **Apertura del Cap. 11 (parte Analizar y programar): el mito del 80 %.** Tesis: la limpieza se paga una vez (es ardua pero determinista y converge: el script se repite cada mes); el análisis se paga en cada pregunta (depende de lo que se pida, explorar es abierto, probar modelos y parámetros no tiene final). Matiz de Wickham (2014): la preparación se repite a lo largo del análisis cuando aparecen problemas nuevos. Riesgo propio del análisis: el jardín de los senderos que se bifurcan (Gelman y Loken, 2013, título tomado de Borges, *El jardín de senderos que se bifurcan*, 1941). Fuentes verificadas para mencionar (no citar): Wickham (2014) abre con «It is often said that 80% of data analysis is spent on the process of cleaning and preparing the data (Dasu and Johnson 2003)»; Lohr, NYT, 18 ago. 2014, «For Big-Data Scientists, 'Janitor Work' Is Key Hurdle to Insights» (50 a 80 %, por entrevistas y estimaciones, no por un estudio); CrowdFlower 2016 Data Science Report vía Forbes (Gil Press, 23 mar. 2016): 60 % limpiar y organizar más 19 % recolectar, con unas 80 personas encuestadas; el 60 % parece ser la proporción de encuestados, no del tiempo; CrowdFlower vendía servicios de preparación de datos; Leigh Dodds (31 ene. 2020) rastreó la cadena IBM, HBR, IBM, CrowdFlower; Anaconda State of Data Science 2020 (2.360 personas): 45 % del tiempo en cargar y limpiar. También mencionar a Tukey (1977, *Exploratory Data Analysis*) y el ciclo de *R for Data Science* (2.ª ed., 2023). Llamarlo «mito del 80 %», no «regla 80/20» (no es el principio de Pareto).
- [x] README del repositorio de materiales: qué es, cómo descargarlo, cómo generar los datos, licencias y dónde reportar errores (copia local, sin commit).

**Verificaciones**

- [ ] Confirmar la versión de R usada en el libro (la nota del capítulo 2 dice 4.6.2).
- [ ] Probar el capítulo 2 en una máquina o usuario limpio: `winget`, comprobación de R fuera del `PATH` y las pestañas de descarga.
- [ ] Probar la descarga de materiales en macOS.
- [x] DuckDB 2.0 lee Excel con la extensión `excel` (hojas, rangos, `stop_at_empty`) y admite el tipo `VARIANT` usado en el Ejemplo 4.3.
- [ ] Verificar que `license: "CC BY-NC-SA"` se muestra al renderizar.

**Publicación y seguridad**

- [ ] Decidir cómo publicar el HTML (por ejemplo GitHub Pages).
- [ ] Activar secret scanning y push protection en ambos repositorios.
- [x] `.gitignore` del libro creado. Con `freeze: auto` activo en `_quarto.yml`, la carpeta `_freeze/` **sí** se sube al repositorio: guarda los resultados de cada capítulo y permite publicar sin volver a ejecutar el código.
- [ ] Revisar licencias de imágenes y de otros materiales de terceros.