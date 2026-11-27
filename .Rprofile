# Python del proyecto para los bloques {python} que Quarto ejecuta con
# reticulate. El entorno se crea con `uv sync` a partir de pyproject.toml y
# uv.lock. Si .venv no existe, reticulate usa el Python que encuentre.
local({
  python <- if (.Platform$OS.type == "windows") {
    ".venv/Scripts/python.exe"
  } else {
    ".venv/bin/python"
  }
  if (!file.exists(python)) {
    return(invisible())
  }
  Sys.setenv(RETICULATE_PYTHON = normalizePath(python))

  # Solo al renderizar con Quarto: cargar pyarrow antes de que R cargue el
  # paquete arrow. En Windows los dos traen una biblioteca llamada arrow.dll;
  # en un mismo proceso, la que se carga primero gana, y pyarrow falla si R
  # cargó la suya antes.
  rendering <- nzchar(Sys.getenv("QUARTO_DOCUMENT_PATH"))
  if (rendering && requireNamespace("reticulate", quietly = TRUE)) {
    try(reticulate::import("pyarrow"), silent = TRUE)
  }
})
