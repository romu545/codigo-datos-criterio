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
Partes (Quarto `part:`): I Punto de partida (1-2), II Obtener los datos (3-4), III Preparar y guardar los datos (5-8), IV Analizar y programar (9-11), V Automatizar, comunicar y mantener (12-14). El número de cada archivo coincide con su capítulo.

3. Importación de datos I: el contrato de lectura (`03-importacion-de-datos.qmd`)
4. Importación de datos II: formatos y fuentes (`04-importacion-formatos-y-fuentes.qmd`)
5. Tipos de datos y calidad
6. Transformación y limpieza
7. Estructuras, formatos y almacenamiento
8. Exportación de datos
9. Estadística descriptiva, exploración y gráficos
10. Funciones personalizadas
11. Flujos reproducibles y depuración
12. Automatización y programación de tareas
13. Reportes reproducibles y comunicación
14. Pruebas, seguridad, publicación y mantenimiento

## Decisiones de alcance y avance: capítulos 3 y 4 (Importación de datos)

### Decisiones cerradas

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
- [ ] Cap. 4: probar al renderizar la extensión `excel` de DuckDB (`read_xlsx` con `range`, y `UNION ALL BY NAME` entre hojas) y `openxlsx2::wb_to_df(start_row = 4)`; no se pudieron ejecutar en el entorno de redacción.
- [ ] Llevar `ventas_2025_por_mes.xlsx` y `scripts/generar_ventas_historico_grande.R` al repositorio de materiales y actualizar allí la sección «Cómo generar los datos» del README.
- [ ] Actualizar los nombres comentados de los capítulos 5 a 14 en `_quarto.yml` cuando se creen.
- [x] Ajustar en `_tabla-formatos.qmd` la frase *"más adelante las mediremos con un ejercicio"* para que haga referencia al ejercicio de conversión a Parquet ya realizado en el capítulo.
- [ ] Crear los scripts generadores y archivos de ejemplo en `codigo-datos-criterio-material` (`datos/cap03/`).
- [ ] Medir tamaños y tiempos reales de CSV frente a Parquet con `ventas_historico_grande.csv` para documentar resultados de referencia.
- [ ] Verificar referencias `@tbl-formatos`, `@tbl-escenarios` y `@sec-elegir-formato` al renderizar con Quarto.
- [ ] Revisar la nota sobre CVE-2024-27322 (RDS, corregida en R 4.4.0) al publicar el capítulo.

**Contenido — Resto del libro**

- [ ] Crear los capítulos 4 a 13 (hoy comentados en `_quarto.yml`).
- [ ] Crear `references.bib` (o comentar la línea `bibliography` si no se usa todavía).
- [ ] README del repositorio de materiales: qué es, cómo descargarlo, dónde reportar errores, licencia de cada conjunto de datos.

**Verificaciones**

- [ ] Confirmar la versión de R usada en el libro (la nota del capítulo 2 dice 4.6.2).
- [ ] Probar el capítulo 2 en una máquina o usuario limpio: `winget`, comprobación de R fuera del `PATH` y las pestañas de descarga.
- [ ] Probar la descarga de materiales en macOS.
- [ ] Verificar que DuckDB lee Excel en la versión que se use (extensión `excel`) y sus opciones (hojas, rangos).
- [ ] Verificar que `license: "CC BY-NC-SA"` se muestra al renderizar.

**Publicación y seguridad**

- [ ] Decidir cómo publicar el HTML (por ejemplo GitHub Pages).
- [ ] Activar secret scanning y push protection en ambos repositorios.
- [x] `.gitignore` del libro creado. Con `freeze: auto` activo en `_quarto.yml`, la carpeta `_freeze/` **sí** se sube al repositorio: guarda los resultados de cada capítulo y permite publicar sin volver a ejecutar el código.
- [ ] Revisar licencias de imágenes y de otros materiales de terceros.