# Instrucciones de redacción — Capítulo 3: Importación de datos

Actúa como coautor técnico de **Rafael Mendoza** en el libro ***Datos, código y criterio*** (español `es-CO`, enfoque práctico y reproducible de análisis de datos de principio a fin).

Tu tarea es redactar el **Capítulo 3: Importación de datos** en formato **Quarto Markdown (`.qmd`)**, listo para integrarse en el libro (`https://github.com/romu545/codigo-datos-criterio`), respetando rigurosamente la estructura, el tono pedagógico, los bloques de código paralelos (R, Python y DuckDB) y las convenciones técnicas detalladas abajo.

---

## 1. Contexto editorial y reglas técnicas obligatorias

- **Tono y estilo:** Claro, directo, pragmático y con criterio de ingeniería de datos aplicada (`es-CO`). No enseñes sintaxis de memoria: explica el *porqué* técnico detrás de cada parámetro (memoria RAM, contratos de esquema, reducción de dependencias, lectura selectiva).
- **Jerarquía de lenguajes:**
  - **R** es el lenguaje principal del libro.
  - **Python** y **DuckDB** aparecen en bloques paralelos mediante `::: {.panel-tabset}` para comparar enfoques.
- **Entorno asumido:** Positron, R (versión 4.6.2+), Python gestionado con `uv`, y DuckDB (CLI, R y Python).
- **Formato de estudio:** El capítulo está unificado (no se divide) y corresponde a unas 3.5 a 4 horas de trabajo (dos sesiones de ~2 horas). Indícalo brevemente en la introducción del capítulo para gestionar la expectativa del lector.
- **Regla de no duplicación con el anexo final:** Al final del capítulo se incluirá mediante `{{< include _tabla-formatos.qmd >}}` una sección ya redactada (`#sec-elegir-formato`) que contiene `@tbl-formatos`, `@tbl-escenarios`, la explicación detallada sobre el peso de los archivos y las razones para descartar `RDS`, `RData` y `pickle` (incluyendo la mención a `CVE-2024-27322`). **No repitas esa explicación en medio del capítulo**; menciónala brevemente cuando corresponda y remite al lector a `@sec-elegir-formato`, `@tbl-formatos` y `@tbl-escenarios`.
- **Convenciones de código Quarto:**
  - Usa bloques ejecutables estándar (` ```{r} `, ` ```{python} `) dentro de `::: {.panel-tabset}` con pestañas `### R`, `### Python` y `### DuckDB` (cuando aplique).
  - Usa bloques de aviso de Quarto (`::: {.callout-note}`, `::: {.callout-tip}`, `::: {.callout-warning}`) para notas conceptuales y advertencias.
  - Todas las rutas a los archivos de ejemplo deben apuntar de forma relativa a `datos/cap03/...` (provenientes del repositorio `codigo-datos-criterio-material`).
  - Incluye enlaces en formato Markdown a la documentación oficial de cada ecosistema mencionado.

---

## 2. Ecosistema de datos de ejemplo (`datos/cap03/`)

Todos los ejemplos y ejercicios del capítulo deben girar alrededor de un mismo dominio realista en contexto colombiano (**Operaciones comerciales y recaudos de una red regional de distribución, 2024–2026**) para dar continuidad narrativa:

1. **`datos/cap03/ventas_2026_01.csv`** (~5.000 filas):
   - Archivo delimitado por punto y coma (`;`), coma decimal (`,`) y codificación `Latin-1` (`ISO-8859-1`) con tildes y eñes (`Bogotá`, `Nariño`, `Año`).
   - Contiene columnas con ceros a la izquierda que no deben perderse: `codigo_dane` (`"05001"`, `"08001"`), `nit_cliente` (`"0090123456"`), junto con `fecha`, `ciudad`, `valor_venta`, y columnas innecesarias (`observacion_interna`, `usuario_auditoria`).
2. **`datos/cap03/lotes_mensuales/`** (carpeta para importación múltiple):
   - Archivos: `recaudos_2025_10.csv`, `recaudos_2025_11.csv`, `recaudos_2025_12.csv`, `recaudos_2026_01.csv` y un archivo distractor `borrador_notas.csv`.
   - **Deriva de esquema (*schema drift*):** En los archivos de `2025` la columna de monto se llama `vlr_total`; en el de `2026` se llama `valor_total`.
3. **`datos/cap03/catalogo_sucursales.xlsx`**:
   - Libro Excel con 3 hojas: `Portada`, `Sucursales` (donde los encabezados reales empiezan en la fila 4, tras 3 filas de título/metadatos) y `Metas_2026`.
4. **`datos/cap03/ventas_historico_grande.csv`** (~2.5 millones de filas, ~400 MB, generado mediante un script auxiliar incluido en el repositorio de materiales):
   - Insumo para el benchmark entre CSV y Parquet.
5. **`datos/cap03/respuesta_api_trm.json`**:
   - Archivo JSON con estructura anidada típica de una API REST (`status`, `paginacion` y un arreglo `resultados` donde cada elemento contiene `id_operacion`, `fecha`, `monto_usd` y un objeto anidado `cliente` con `nit` y `ciudad`).
6. **`datos/cap03/operaciones.duckdb`**:
   - Base de datos embebida con dos tablas (`facturas` y `clientes`) para demostrar consultas `JOIN` y filtros `WHERE` ejecutados en el motor antes de cargar los resultados en RAM.

---

## 3. Estructura detallada del Capítulo 3

### Encabezado y apertura (`# Importación de datos {#sec-importacion}`)
- Breve introducción ubicando el capítulo en el flujo del proyecto y señalando que, por su amplitud práctica, está pensado para desarrollarse en dos sesiones de estudio (~2 horas cada una).

### 3.1. Importar no es un trámite: criterio, memoria y fluidez (`## Importar no es un trámite: criterio, memoria y fluidez {#sec-criterio-importacion}`)
- Explicar por qué la importación condiciona la velocidad, estabilidad y reproducibilidad de todo el análisis.
- El cuello de botella real: leer columnas o filas innecesarias y saturar la memoria RAM (recordando que un *data frame* en memoria suele ocupar más espacio que el archivo plano en disco).
- **Bloque destacado (`::: {.callout-note}`):** *Más allá de las hojas de cálculo y el ETL visual (el caso Power BI).* Explicar que, aunque herramientas como Power BI dominan el mercado empresarial, usar lenguaje M (Power Query) para ingerir, limpiar y transformar volúmenes altos suele volver lento y pesado el flujo. La mejor práctica es aprovechar la integración nativa de R y Python para ejecutar la ingesta y transformación pesada fuera, entregándole a Power BI únicamente un modelo estrella o copo de nieve limpio y listo para consultar. Aclarar explícitamente que la configuración interna dentro de Power BI queda fuera del alcance del libro, pero que todo lo aprendido en este capítulo se aplica directamente allí.

### 3.2. El ecosistema de herramientas: estándares, rendimiento y bajas dependencias (`## El ecosistema de herramientas: estándares, rendimiento y bajas dependencias {#sec-ecosistema-importacion}`)
- Discutir la tensión entre la buena práctica de **minimizar dependencias externas** y la conveniencia de apoyarse en los estándares consolidados del mercado.
- **En R:**
  - El estándar `tidyverse` (`readr` —`https://readr.tidyverse.org/`— y `readxl`), explicando que `readr` utiliza por debajo el motor `vroom` (`https://vroom.r-lib.org/`) para lectura indexada.
  - Cuándo justificar otras alternativas de alto rendimiento o mínimas dependencias: `data.table` (`fread`, `https://rdatatable.gitlab.io/data.table/`) para archivos grandes en memoria y `collapse` (`https://sebkrantz.github.io/collapse/`) para cómputo estadístico ultrarrápido.
- **En Python:**
  - `pandas` (`https://pandas.pydata.org/`) como estándar histórico omnipresente y `polars` (`https://pola.rs/`) como alternativa moderna de alto rendimiento y menor consumo de memoria. Indicar que `tidyverse` y `pandas`/`polars` cubren la gran mayoría de tareas cotidianas.
- **DuckDB como motor transversal (`https://duckdb.org/`):**
  - Qué es: una base de datos analítica (OLAP) embebida que puede correr en memoria o de forma persistente en disco, utilizable desde la terminal, R o Python.
  - Su versatilidad para leer y consultar directamente CSV, JSON, Excel y Parquet sin cargar todo el archivo en RAM.
  - **Responder explícitamente a la pregunta clave:** *¿Conviene abandonar `tidyverse`, `pandas` o `polars` y hacerlo todo con DuckDB?* Argumentar por qué **no** conviene reemplazarlos por completo, sino adoptar un **flujo híbrido**: usar DuckDB para filtrar, agregar y reducir grandes volúmenes en disco, y pasar un *data frame* ligero a R o Python para manipulación compleja, modelado y visualización.

### 3.3. La heurística de importación: definir el contrato desde el inicio (`## La heurística de importación: definir el contrato desde el inicio {#sec-heuristica-importacion}`)
- Explicar que pasar una ruta local o una URL es la parte trivial; lo verdaderamente desafiante y profesional es definir el **contrato de lectura** desde el primer momento en lugar de confiar en la inferencia automática:
  1. **Delimitadores y codificación (`encoding`):** El problema clásico de `UTF-8` frente a `Latin-1` / `Windows-1252` en español (tildes y eñes corruptas).
  2. **Gestión de tipos de columna:** Cuándo especificar el esquema columna por columna y cuándo importar **todas las columnas como texto** (`character` / `str`) como medida defensiva para proteger identificadores con ceros a la izquierda (cédulas, códigos DANE de municipios, NIT, consecutivos) antes de validarlos en el Capítulo 4.
  3. **Proyección temprana:** Seleccionar únicamente las columnas necesarias al momento de leer para ahorrar memoria y tiempo.
- **Ejemplo guiado 3.1 (`panel-tabset` R / Python / DuckDB):**
  - Mostrar primero qué sale mal al leer `datos/cap03/ventas_2026_01.csv` con configuración por defecto (tildes rotas, pérdida del cero inicial en `codigo_dane` y `nit_cliente`, carga de columnas basura).
  - Mostrar luego la lectura controlada especificando codificación `Latin-1`, delimitador `;`, selección de 5 columnas (`fecha`, `codigo_dane`, `nit_cliente`, `ciudad`, `valor_venta`) y tipos explícitos (`codigo_dane` y `nit_cliente` como texto).

### 3.4. Escalar a múltiples archivos sin perder el control (`## Escalar a múltiples archivos sin perder el control {#sec-multiples-archivos}`)
- Rescatar la heurística de la sección anterior aplicada a carpetas con decenas o cientos de archivos:
  - Descubrimiento dinámico mediante rutas relativas, expresiones *glob* (`*.csv`) y patrones (`pattern`).
  - **Nota anticipada (`::: {.callout-tip}`): El papel de las expresiones regulares (Regex).** Explicar que, aunque las expresiones regulares se estudiarán en detalle en capítulos posteriores, aquí se usan de forma puntual para filtrar nombres de archivo con precisión y evitar listas manuales frágiles que rompen la reproducibilidad.
  - **El problema real de la deriva de esquemas (*schema drift*):** Qué pasa cuando múltiples archivos representan la misma entidad pero tienen nombres de columna distintos (`vlr_total` vs. `valor_total`), columnas adicionales o tipos que cambian entre meses. Estrategias: leer todo como texto inicialmente, homologar nombres antes o inmediatamente después de apilar, y conservar el nombre del archivo de origen como columna de trazabilidad (`archivo_origen`).
- **Ejemplo guiado 3.2 (`panel-tabset` R / Python / DuckDB):**
  - Leer todos los archivos `recaudos_*.csv` dentro de `datos/cap03/lotes_mensuales/` excluyendo `borrador_notas.csv`, resolviendo la diferencia entre `vlr_total` (2025) y `valor_total` (2026) y agregando la columna `archivo_origen`.
- **Ejercicio 3.1 (Práctica guiada/autónoma):**
  - Pedir al lector que importe únicamente los archivos correspondientes al año `2025` dentro de `datos/cap03/lotes_mensuales/` usando un patrón, estandarice los nombres de columna, verifique que no existan valores nulos inesperados tras la unión y deje un espacio/estructura clara para su solución.

### 3.5. Hojas de cálculo (Excel) y formatos binarios eficientes (Parquet) (`## Hojas de cálculo y formatos binarios eficientes {#sec-excel-parquet}`)
- **Excel (`.xlsx`):** Cuándo es inevitable usarlo (recepción de insumos de áreas administrativas), cómo inspeccionar nombres de hojas, leer una hoja específica y saltar filas decorativas (`skip`), y cómo leer archivos Excel directamente desde DuckDB (usando su extensión `excel`). Recordar su límite físico (1.048.576 filas) y remitir a `@sec-elegir-formato`.
- **Ejemplo guiado 3.3 (`panel-tabset` R / Python / DuckDB):**
  - Leer la hoja `Sucursales` de `datos/cap03/catalogo_sucursales.xlsx` saltando las 3 primeras filas de encabezado decorativo.
- **Introducción a Apache Parquet:** Explicar brevemente su arquitectura columnar y por qué es el estándar recomendado para análisis local en reemplazo de formatos nativos cerrados (`RDS`, `RData`, `pickle`), remitiendo a `@sec-elegir-formato` para el detalle comparativo y de seguridad.
- **Ejercicio 3.2 — El experimento práctico (CSV vs. Parquet):**
  - Instruir al lector para que tome `datos/cap03/ventas_historico_grande.csv` (o lo genere con el script del repositorio de materiales), lo convierta a `ventas_historico.parquet` y mida en su propio equipo:
    1. Tamaño en disco de ambos archivos (MB).
    2. Tiempo de lectura completa (todas las columnas).
    3. Tiempo de lectura de **solo dos columnas** (`codigo_dane` y `valor_venta`).
  - Incluir el código reproducible para ejecutar la medición en R (`readr` / `arrow`), Python (`polars`) y DuckDB, junto con una plantilla de tabla vacía para que el lector registre sus propios tiempos y tamaños.

### 3.6. Datos semiestructurados (JSON), APIs y bases de datos (`## Datos semiestructurados, APIs y bases de datos {#sec-json-apis-bd}`)
- **JSON y APIs REST:** Explicar por qué se abordan juntos (la gran mayoría de las APIs web entregan respuestas en formato JSON). Mostrar cómo pasar de una estructura jerárquica/anidada a una tabla plana (*flattening*) y cómo aplicar consultas directamente sobre JSON con DuckDB.
- **Ejemplo guiado 3.4 (`panel-tabset` R / Python / DuckDB):**
  - Leer `datos/cap03/respuesta_api_trm.json`, extraer el arreglo `resultados` y desanidar el objeto `cliente` (`nit`, `ciudad`) en columnas planas. Incluir una nota breve mostrando cómo el mismo flujo aplica al consumir una URL de API HTTP antes de guardar copia local.
- **Bases de datos relacionales:** Explicar el cambio de mentalidad: en lugar de descargar tablas enteras a la RAM para filtrarlas en R o Python, delegar el filtrado (`WHERE`) y la combinación (`JOIN`) al motor de base de datos mediante SQL.
- **Ejemplo guiado 3.5 (`panel-tabset` R / Python):**
  - Conectarse a `datos/cap03/operaciones.duckdb`, ejecutar una consulta SQL con `JOIN` entre `facturas` y `clientes` filtrando por un rango de fechas, y traer únicamente el resultado agregado al entorno local.

### 3.7. Cierre e integración de la tabla comparativa (`{{< include _tabla-formatos.qmd >}}`)
- Introducir brevemente la síntesis final conectándola con los resultados del Ejercicio 3.2 (CSV vs. Parquet).
- Colocar exactamente la directiva de Quarto:
  ```markdown
  {{< include _tabla-formatos.qmd >}}
  ```
- **Nota de edición para el archivo incluido:** Señala en un comentario que en `_tabla-formatos.qmd` conviene ajustar la frase *"más adelante las mediremos con un ejercicio"* por *"como comprobaste en el ejercicio de conversión a Parquet"*, ya que el anexo aparece al final del capítulo.
- **Ejercicio 3.3 — Proyecto integrador del capítulo:**
  - Plantear un caso de cierre donde el lector debe integrar cuatro fuentes del repositorio (`ventas_2026_01.csv`, `catalogo_sucursales.xlsx`, `respuesta_api_trm.json` y `operaciones.duckdb`), aplicar la heurística de selección de columnas y control de tipos desde la lectura, y exportar una tabla consolidada en formato **Parquet** lista para ser auditada en el **Capítulo 4 (Tipos de datos y calidad)**.

---

## 4. Entregable esperado

Genera el contenido completo del archivo `chapters/03-importacion.qmd` en español (`es-CO`), bien estructurado, con prosa fluida, sin relleno innecesario, listo para ser revisado y compilado con Quarto.