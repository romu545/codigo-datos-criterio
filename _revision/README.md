# Revisión del libro con otras IA

Instrucciones para usar Gemini, ChatGPT y otras herramientas como pares evaluadores de *Datos, código y criterio*. La carpeta empieza con `_` para que Quarto no la publique.

## Qué entregar

- **Un capítulo por conversación**, más `index` y el capítulo 1 como contexto.
- **El libro renderizado, no los `.qmd`**: así el revisor ve el texto junto con las salidas reales del código y puede detectar cuando el texto contradice la salida. Desde el navegador, abre `_book/<capitulo>.html` e imprímelo a PDF.
- Para revisar el código ejecutándolo (ChatGPT con análisis de datos, Gemini con ejecución de código), adjunta también los archivos de `datos/capNN/` que usa el capítulo.

## Cómo hacerlo

1. Elige **un rol por pasada** (`instrucciones/`). Mezclar roles produce comentarios superficiales de todo.
2. Pega la instrucción del rol, cambia lo que está entre corchetes y adjunta el capítulo.
3. Envía **la misma instrucción a Gemini y a ChatGPT**.
4. Copia los hallazgos en `hallazgos.md`, uno por fila, con la herramienta que lo encontró.
5. **Cruza las respuestas**: lo que señalan las dos va primero; lo que señala una sola se verifica con más cuidado.
6. **Verifica cada hallazgo antes de corregir**, ejecutando el código cuando se pueda. Los modelos también inventan errores que no existen: es la misma lección de las auditorías del libro.
7. Marca en `hallazgos.md` qué se corrigió, qué se descartó y por qué.

## Herramientas

| Herramienta | Para qué sirve mejor |
|---|---|
| Gemini y ChatGPT | Revisión por rol, un capítulo a la vez, con las instrucciones de `instrucciones/`. |
| NotebookLM | Preguntas sobre el libro completo, con respuestas basadas solo en el texto: contradicciones entre capítulos, términos usados con dos significados. Ver `instrucciones/06-notebooklm.md`. |
| LanguageTool | Ortografía, tildes y concordancia en español. Basado en reglas, más fiable que un modelo para esto. |
| Claude en una sesión nueva | Ojos frescos, sin el contexto de las sesiones de escritura. Dar menos peso: es la misma familia de modelos que ayudó a escribir el libro. |
| Lectores humanos del público objetivo | Dónde se pierde una persona real. Ninguna IA lo reemplaza. |

## Cuidados

- El libro es público, así que compartirlo no expone nada privado. Aun así, no adjuntes archivos como `.Renviron` o `.env`.
- Si no quieres que el texto se use para entrenar modelos, revisa esa opción en la configuración de cada servicio antes de subirlo.
- Pide siempre ubicación y cita textual: un hallazgo que no se puede ubicar no se puede verificar.
