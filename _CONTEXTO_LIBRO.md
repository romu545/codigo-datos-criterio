# Pendientes y contexto del libro

> Archivo de trabajo, no forma parte del libro. Empieza con `_` para que Quarto no lo renderice (no está en `chapters`). Sirve para retomar el proyecto sin perder las decisiones tomadas.
>
> **Punto de partida: 27 de noviembre de 2026.** El historial de cómo se llegó aquí está en los commits y pull requests (#1 a #8); este archivo describe solo el estado actual.

## Estado actual

- Los **17 capítulos están redactados y renderizados** en HTML (unas 12.700 líneas de `.qmd`). El render completo funciona con `quarto render --to html` (Quarto 1.11.9) y usa los resultados guardados en `_freeze/`.
- La etapa actual es la **revisión del libro completo** leyendo el HTML en `_book/index.html`.
- **Git al día (27 nov. 2026):** el PR #9 del libro y el PR #2 de materiales están unidos en `main`; no quedan ramas abiertas. `main` de materiales tiene los datos de todos los capítulos. Los dos repositorios tienen activados secret scanning y push protection, y una regla en `main` que exige PR (sin aprobaciones obligatorias).
- El PDF no se ha probado de punta a punta.

## Contexto

- **Título:** *Datos, código y criterio*. Subtítulo: *Un libro sobre análisis de datos con R y Python*. Antes se llamaba «Código, datos y criterio»; el repositorio conserva el nombre `codigo-datos-criterio`. **Autor:** Rafael Mendoza. **Idioma:** español (`es-CO`).
- **Enfoque:** análisis de datos de principio a fin, práctico y reproducible. R es el lenguaje principal y Python aparece en pestañas para comparar. También se usan SQL (DuckDB) y PowerShell.
- **Herramientas del entorno:** Positron, R 4.6.2, Python (instalado con `uv`), DuckDB 2.0. Git es opcional al inicio.
- **Sistemas operativos:** Windows (`winget`) y macOS (instaladores oficiales o Homebrew).
- **Caso transversal:** operaciones comerciales, cartera, recaudos y entregas de una red regional de distribución (2024 a 2026), con sucursales S01 a S07. Cada capítulo tiene su carpeta `datos/capNN/`.
- **Extensión de los capítulos:** no hay límite de dos horas. Un tema puede necesitar más; desde el Cap. 9 los capítulos no dicen cuánto duran.

## Repositorios y flujo de trabajo

- Libro (público): `https://github.com/romu545/codigo-datos-criterio`
- Materiales (público): `https://github.com/romu545/codigo-datos-criterio-material`
- Los issues se reportan en el repositorio del libro.
- **Datos y código de práctica (decisión 27 nov. 2026, opción A):** el repositorio del libro es la fuente; materiales es una copia con las mismas rutas. Se sincroniza en un solo sentido con `python _herramientas/sincronizar_materiales.py` (muestra los cambios) y `--aplicar` (copia). Copia lo que git sigue en `datos/`, `scripts/`, `tests/`, `reportes/`, `air.toml` y `ruff.toml`, sin `datos/cap10/` (salidas) ni `scripts/portada.R`. Nunca borra: lista los huérfanos. Correrlo después de cambiar datos o scripts.
- `main` está protegida: todo cambio entra por rama + pull request (`gh pr create --fill`, `gh pr merge --squash --delete-branch`).
- No proteger la rama `gh-pages` si se publica con `quarto publish gh-pages`.
- `_freeze/` **sí** se sube al repositorio (`freeze: auto`): guarda los resultados de cada capítulo y permite publicar sin volver a ejecutar el código. `_book/` está en `.gitignore`.

## Licencias

- Texto del libro: CC BY-NC-SA 4.0 (se muestra en el pie de página).
- Código de los materiales: MIT.
- Datos: conservan la licencia de su fuente; documentarla en el README del repositorio de materiales.

## Estructura

Cinco partes (Quarto `part:`). El número de cada archivo coincide con su capítulo.

**I. Punto de partida**

1. Introducción (`01-introduccion.qmd`). Diagrama `imagenes/inicio/ia-criterio.svg`.
2. Fundamentos y preparación del entorno (`02-...`, `#sec-entorno`). Editor, lenguaje, paquete y herramienta; instalación con `winget` y macOS; descarga de materiales; instalación de todos los paquetes de R y Python (`#sec-instalar-paquetes`, con `uv add`, no `uv pip install`, para que queden en `uv.lock`). Los demás capítulos remiten a esa sección.

**II. Obtener los datos**

3. Importación I: el contrato de lectura (`03-...`). Criterio, ecosistemas (`readr`/`vroom`, `data.table`, `collapse`, `pandas`, `polars`, `duckplyr` en recuadro con `eval: false`), heurística (codificación, delimitadores, identificadores como texto), múltiples archivos y deriva de esquema. Píldora sobre texto crudo. Datos `datos/cap03/`.
4. Importación II: formatos y fuentes (`04-...`). Excel (también desde DuckDB), Parquet, JSON y APIs, bases de datos, experimento CSV frente a Parquet con `ventas_historico_grande.csv` (se genera con `scripts/generar_ventas_historico_grande.R`), tabla de formatos (`_tabla-formatos.qmd`, incluida con `include`) y proyecto integrador. No se enseñan `RDS`, `RData` ni `pickle`. Datos `datos/cap04/`.
5. Importación III: limpieza temprana (`05-...`). Frontera: lo que depende de cómo se escribió el dato se resuelve al leer; lo que depende de lo que dice el dato va a los Cap. 6 a 8. Datos `datos/cap05/`.

**III. Preparar y guardar los datos**

6. Tipos de datos y calidad (`06-...`). Regla: medir antes de corregir. Dimensiones de calidad, reglas escritas como datos con severidad `bloquea`/`advierte`; las mismas reglas como contrato con `pointblank` y `pandera` (`#sec-contratos`). Scripts `auditoria_cartera.R` y `.py`. Datos `datos/cap06/`.
7. Transformar y ordenar (`07-...`). Seis operaciones en todas sus escrituras, uniones con `relationship`/`validate`, largo y ancho, volumen con 10 millones de filas (dplyr, data.table, collapse, arrow, DuckDB, pandas, polars). Datos `datos/cap07/`.
8. Limpiar (`08-...`). Principios (crudo intacto, cuarentena, bitácora), texto, expresiones regulares, estandarizar categorías, limpieza completa de la cartera (379 limpias, 23 en cuarentena, 4 copias). Ejemplo 8.8 (`#sec-clasificar-ia`): clasificar 400 reclamos de texto libre con un modelo de lenguaje en cuatro pasos (ocultar datos personales con regex, preguntar con salida estructurada y guardar las respuestas con versión de instrucciones, medir contra 150 revisados a mano, decidir por categoría); código de la API con `eval: false` (`ellmer` en R, SDK `anthropic` con `messages.parse` en Python, modelo `claude-opus-5-5`); las respuestas de `reclamos_clasificados.csv` son **simuladas** y el texto lo dice (generador `scripts/generar_datos_cap08_reclamos.R`). Datos `datos/cap08/`.
9. Transformar a escala (`09-...`). Muchas columnas, muchas tablas (`reduce`), uniones por desigualdad, completar la estructura, columnas-lista, iterar con criterio. Abre con código copiado y pegado. Datos `datos/cap09/`.
10. Guardar y compartir los datos (`10-...`). Hilo: ¿quién va a leer esto? Capas, ida y vuelta, metadatos, idempotencia, historia de cierres, un archivo por sucursal, CSV con contrato. Salidas en `datos/cap10/`.

**IV. Analizar y programar**

11. Explorar los datos (`11-...`). Abre con el mito del 80 %. Guía de preguntas, gráficos de trabajo (`ggplot2`, `seaborn`), patrones sembrados en `datos/cap11/`. Remuestreo de medianas (`#sec-remuestreo`, cita `efron1979`): S07 entre 9,3 y 15,8 h; la diferencia S07 menos S02 cambia de signo según la semilla (R −0,4, Python +0,3), y el texto lo usa como lección.
12. Funciones propias (`12-...`). Anatomía, argumentos, anónimas, orden superior, alcance y clausuras, evaluación perezosa, validación, clases pequeñas (S3, `dataclass`), hacia paquetes. Scripts `inventario.R` y `.py`.
13. Flujos reproducibles y depuración (`13-...`). Abre con el fallo del archivo de abril. Flujo como tubería (`scripts/flujo_entregas.R` y `.py`), sesión limpia, rehacer solo lo que cambió, depurar en cinco pasos y, al final, programar tareas (`#sec-programar`). Datos `datos/cap13/`.

**V. Comunicar y mantener** (usa los datos y funciones del flujo del Cap. 13)

14. Gráficos que explican (`14-...`). Del gráfico de trabajo al explicativo: gramática de gráficos, destacado, etiquetas directas, anotaciones, tipografía, composición (`patchwork`, `cowplot`), accesibilidad, interactivo con Observable Plot y `plotly`.
15. Reportes con Quarto (`15-...`). Plantilla parametrizada `reportes/reporte_entregas.qmd` (y versión Python), un reporte por sucursal, HTML, PDF con Typst y Word.
16. Excel, presentaciones y tableros (`16-...`). Elegir por el verbo de quien recibe; Excel con `openxlsx2` y `XlsxWriter`; `revealjs` y `pptx`; tablero sin servidor `reportes/tablero_entregas.qmd`.
17. Probar, proteger, publicar y mantener (`17-...`). Validar datos frente a probar código (`tests/testthat/test-flujo.R`, `tests/test_flujo.py`), secretos en variables de entorno, seudonimizar, Ley 1581 de 2012 (`#sec-habeas-data`: principios del art. 4, datos sensibles, transferencia internacional del art. 26; verificada en el Régimen Legal de Bogotá), GitHub Actions, `quarto publish`, cierre del libro sobre el criterio.

Cierra con `references.qmd` («Referencias», a partir de `references.bib`).

## Convenciones

- **Estilo editorial:** sin guiones medios ni rayas (– —) en la redacción; los incisos van entre comas o paréntesis. Sin íconos, emojis ni símbolos como ✓ o ✗ dentro del texto.
- **Diagramas:** SVG en escala de grises en `imagenes/<tema>/`, insertados con `{#fig-...}` y `fig-alt`. Sin título interno (lo da el pie de figura). Lo que se debe evitar va con trazo discontinuo y la palabra «Evitar». Deben mostrar el mecanismo paso a paso con valores reales, no solo etiquetar cajas. Para el PDF, Quarto necesita `rsvg-convert`.
- **Pestañas:** las de lenguaje usan `::: {.panel-tabset group="lenguaje"}` (Quarto recuerda la elección del lector en todo el libro); las de sistema operativo, `group="sistema"`. La del Cap. 2 (formas de descargar los materiales) queda sin grupo. Las pestañas de DuckDB se ejecutan desde R.
- **SQL desde R:** en texto crudo `r"(...)"` en todo el libro.
- **Formato del código:** R con `air` (estilo tidyverse, 80 caracteres; `air.toml`) y Python con `ruff format` (PEP 8, 79 caracteres; `ruff.toml`). Para reformatear los bloques dentro de los `.qmd` hay que extraerlos, porque ninguno de los dos formatea Quarto directamente. Consecuencia aceptada: `air` abre en varias líneas las llamadas con SQL en texto crudo y las listas largas de `use()`. El fragmento suelto del inicio del Cap. 12 no se formatea (no es código completo).
- **Bloques de Python (desde el 27 nov. 2026 se ejecutan):** son bloques `{python}` que `knitr` ejecuta con `reticulate` en el mismo proceso de R. El entorno es el `.venv` del proyecto, creado con `uv sync` a partir de `pyproject.toml` y `uv.lock` (Python 3.14, `.python-version`); el `.Rprofile` fija `RETICULATE_PYTHON` a ese `.venv`. Para renderizar en un equipo nuevo: `uv sync` y `install.packages("reticulate")`. Solo quedan con `eval: false` los ejercicios por completar, la descarga de materiales (Cap. 2), las llamadas a servicios externos (Cap. 4 API, Cap. 8 modelo de lenguaje) y la medición sobre el CSV grande del Cap. 4 (igual que en R). `_quarto.yml` activa `jupyter_compat: true`: solo se imprime el valor de la última expresión de cada bloque, como en Jupyter (sin él, `reticulate` imprime el valor de cada llamada a `matplotlib` dentro de un `for`).
- **Conflicto de `arrow.dll` en Windows:** el paquete `arrow` de R y `pyarrow` traen cada uno una biblioteca llamada `arrow.dll`; en un mismo proceso gana la que se carga primero, y si R carga la suya antes, `pyarrow` (y `pd.read_parquet`) fallan. El `.Rprofile`, solo cuando Quarto renderiza (`QUARTO_DOCUMENT_PATH`), importa `pyarrow` antes que cualquier capítulo cargue `arrow`.
- **pandas 3 en las salidas reales:** el texto es de tipo `str`, no `object` (las salidas escritas a mano decían `object`); las fechas leídas de Parquet siguen llegando como `object` (`datetime.date`). El ancho de las tablas es de 80 columnas al renderizar (`knitr` lo fija; no se puede cambiar sin ensanchar también las salidas de R): para tablas anchas, `print(df.to_string())`.
- **Referencias cruzadas:** `lang: es` va en el nivel superior de `_quarto.yml`. Antes de una sección, artículo femenino (`en la @sec-fechas`); antes de un capítulo, masculino (`en el @sec-importacion`).
- **Citas:** citar formalmente solo un par de referencias por tema (`wickham2014`, `gelman2013`, `cleveland1984`, `wickham2019`, `wickham2023`, `efron1979`); las demás se mencionan en el texto con enlace.
- **Aperturas:** cada capítulo abre de una forma distinta (pregunta, caso, error real, código copiado), no siempre con el resumen del anterior.
- **Un solo libro, no tres tomos:** la comparación entre herramientas es lo que distingue al libro. Si algún día se quieren ediciones en PDF por lenguaje, hacerlo con perfiles de Quarto y `.content-visible`.
- **Auditorías (decisión 27 nov. 2026):** los Cap. 3, 7, 8 y 11 cierran con «Auditoría N.1» (`#sec-auditoria-*`): un pedido corto, el código típico de un asistente que se ejecuta sin errores (pestañas R y Python), la pregunta, y la solución en `callout-tip collapse="true"` con evidencia ejecutada y una lección general. No se dice que el código lo generó un asistente real, sino que es «del tipo que entrega». Cifras: Cap. 3, 1.215 códigos DANE sin cero; Cap. 7, 6 de 8 sucursales «cumplen» la meta frente a 1 real (S08) por `P07` repetido y descuento ignorado; Cap. 8, `na.omit()` + `distinct(nit)` dejan 179 de 200 clientes con 19 repetidos; Cap. 11, ranking por promedio frente a mediana y % > 24 h (S03 28,2 %).
- **«Otra herramienta» (decisión 27 nov. 2026):** `dplyr` es la sintaxis principal de R; las alternativas aparecen en secciones `### Otra herramienta: ...` con el mismo problema resuelto y una tabla de cuándo conviene cada una. Hechas: `collapse` en el Cap. 9 (`#sec-otra-collapse`: mismo resumen, 1.000 remuestreos unas 5 veces más rápidos, `fmean()` ignora faltantes por defecto) y contratos con `pointblank`/`pandera` en el Cap. 6 (`#sec-contratos`). Criterio: no alternar herramientas al azar; solo donde la alternativa tiene una razón concreta.
- **Power BI:** solo notas aparte; las transformaciones pesadas van en R o Python y en Power BI queda el modelo estrella.

## Hallazgos técnicos que conviene recordar

- **DuckDB 2.0:** las funciones anónimas se escriben `lambda x: ...` (la flecha `x -> ...` da error); `store_rejects` no se combina con `union_by_name`; `read_xlsx` con `range = 'A4:E'` necesita `stop_at_empty = true` o devuelve un millón de filas vacías.
- **pandas 3:** la asignación encadenada no tiene efecto (Copy-on-Write); `merge_asof()` exige la misma resolución de fecha; Parquet trae `date32` como `object` y enteros con faltantes como `float64`; `corr(method="spearman")` necesita `scipy` (el libro usa `rank()`).
- **R:** `use()` con lista de funciones impide que `library()` cargue el resto del paquete; `all()` de un vector vacío es `TRUE`; en Windows un Parquet leído queda mapeado y no se puede sobrescribir en la misma sesión (`mmap = FALSE`).
- **Quarto:** las celdas de Observable no funcionan abiertas como archivo (`file://`), hay que servirlas; los faltantes de R llegan a JavaScript como el texto `"NA"`; el reporte por sucursal debe renderizarse desde la carpeta `reportes/` o falla `embed-resources`; la versión Python del reporte necesita `papermill`, `QUARTO_PYTHON` y `--execute-daemon-restart`.

## Fuera de alcance por ahora

- Servicios en la nube (Drive, OneDrive) y web scraping.
- Otros formatos: XML, ancho fijo, SPSS/Stata/SAS, tablas en PDF, Google Sheets, YAML, SQLite.

## Pendientes

**Revisión y contenido**

- [ ] Revisar el libro completo en el HTML renderizado.
- [ ] Hacer la revisión con otras IA siguiendo `_revision/README.md` y registrar los hallazgos en `_revision/hallazgos.md`.
- [ ] Agregar `fig-alt` a los gráficos de las pestañas de Python (ahora que se ejecutan, se dibujan sin texto alternativo).
- [ ] Decidir el público del libro y escribir sus requisitos en «Para quién es este libro» (hoy dice que no hace falta conocer R ni Python en profundidad, pero ningún capítulo explica asignación, vectores ni data frames).
- [ ] Decidir si se agregan prefacio, agradecimientos y una sección de alcance («qué cubre y qué no») en `index.qmd`.
- [ ] Rehacer con el estilo explicativo los diagramas que solo etiquetan: `transformacion/volumen.svg`, `transformacion/verbos.svg`, `calidad/flujo-auditoria.svg` y `limpieza/flujo-limpieza.svg` (con las cifras reales), `importacion/flujo-hibrido.svg` y `guardar/capas.svg`.
- [ ] Los tiempos del Ejemplo 7.7 son los de la máquina del autor; revisar el texto si se renderiza en otra máquina y cambia el orden de las herramientas.
- [ ] Revisar la nota sobre CVE-2024-27322 (RDS, corregida en R 4.4.0) en `_tabla-formatos.qmd` antes de publicar.
- [ ] Más secciones «Otra herramienta» donde haya una razón concreta (candidatas: `data.table` para modificar por referencia, R base para scripts sin dependencias, `polars` en Python).
- [ ] Decidir si se suma un capítulo final de proyecto integrador con datos públicos reales; o un segundo ámbito de análisis desde la parte IV (datos abiertos reales: calidad del aire o clima, Saber 11, encuestas de hogares del DANE con factores de expansión), con copia fija en materiales, fecha de descarga y licencia.

**Repositorio de materiales**

- [ ] Crear los scripts generadores de `datos/cap03/` y `datos/cap04/` (los archivos ya están copiados).

**Verificaciones**

- [ ] Probar el Cap. 2 en una máquina o usuario limpio: `winget`, comprobación de R fuera del `PATH` y pestañas de descarga.
- [ ] Probar la descarga de materiales en macOS.
- [ ] Renderizar el PDF completo (necesita `rsvg-convert` para los SVG).

**Publicación y orden del repositorio**

- [ ] Decidir cómo publicar el HTML (por ejemplo GitHub Pages).
- [ ] Revisar licencias de imágenes y de otros materiales de terceros.
