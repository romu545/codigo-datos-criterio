# Pendientes y contexto del libro

> Archivo de trabajo, no forma parte del libro. Empieza con `_` para que Quarto no lo renderice (no está en `chapters`). Sirve para retomar el proyecto sin perder las decisiones tomadas.

## Contexto

- **Título:** Código, datos y criterio. **Autor:** Rafael Mendoza. **Idioma:** español (`es-CO`).
- **Enfoque:** análisis de datos de principio a fin, práctico y reproducible. R es el lenguaje principal y Python aparece en pestañas para comparar. También se usan SQL (DuckDB) y PowerShell.
- **Herramientas del entorno:** Positron, R, Python (instalado con `uv`), DuckDB. Git es opcional al inicio.
- **Sistemas operativos:** Windows (`winget`) y macOS (instaladores oficiales o Homebrew).
- **Ritmo de construcción (autor):** bloques de trabajo de aproximadamente dos horas por sesión para avanzar en la redacción y materiales. El lector avanza a su propio ritmo, ya sea por capítulo completo o por secciones específicas.

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
9. Estructuras, formatos y almacenamiento
10. Exportación de datos
11. Estadística descriptiva, exploración y gráficos
12. Funciones personalizadas
13. Flujos reproducibles y depuración
14. Automatización y programación de tareas
15. Reportes reproducibles y comunicación
16. Pruebas, seguridad, publicación y mantenimiento

## Decisiones de alcance y avance: capítulos 3 y 4 (Importación de datos)

### Decisiones cerradas

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
- [ ] Para el capítulo de funciones o el de flujos (cuando aparezcan los bucles): copia al modificar en R y el bucle que modifica celda por celda. Medido en R 4.6 con 10.000 asignaciones: `df[i, "x"] <- i` 1,49 s y 763 MB; `df$x[i] <- i` 0,55 s y 382 MB; sobre una lista (`as.list(df)`) 6,4 ms y 91 KB; sobre un vector 2,8 ms. Crear una columna (`df$c <- df$a + df$b`) no copia las columnas existentes (copia superficial); la lista solo ahorra microsegundos. Verificar con `tracemem()`; contrastar con `data.table` (`:=`) y pandas (Copy-on-Write). Se decidió no incluirlo en el Cap. 7 por ser funcionamiento interno de R sin paralelo en Python ni DuckDB.
- [ ] Los tiempos del Ejemplo 7.7 son los de la máquina del autor; revisar el texto si se renderiza en otra máquina y cambia el orden de las herramientas.

**Contenido — Resto del libro**

- [ ] Crear los capítulos 9 a 16 (hoy comentados en `_quarto.yml`).
- [ ] Crear `references.bib` (o comentar la línea `bibliography` si no se usa todavía).
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