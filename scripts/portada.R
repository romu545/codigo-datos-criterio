# Portada del libro: datos |> código |> criterio.
#
# Se genera con los datos y el código del propio libro:
#   - las filas crudas son de datos/cap13/abril/entregas_2026_04.csv;
#   - el violín usa los 2.400 pedidos de datos/cap11/entregas_2026_t1.parquet.
#
# Uso, desde la carpeta raíz del proyecto:
#   Rscript scripts/portada.R
# Produce imagenes/portada.png (1600 x 2400 px, proporción 2:3).

library(ggplot2)
library(patchwork)

argumentos <- commandArgs(trailingOnly = TRUE)
variante <- if (length(argumentos) >= 1) argumentos[1] else "flujo-titulo"
destino <- if (length(argumentos) >= 2) {
  argumentos[2]
} else {
  file.path("imagenes", "portada.png")
}
# "flujo-titulo": el flujo datos |> código |> criterio es el título; franja corta.
# "flujo-propio": el flujo usa otras palabras y la franja lleva el título.
etiquetas <- if (variante == "flujo-titulo") {
  c("datos", "  |> código", "  |> criterio")
} else {
  c("crudo", "  |> limpio", "  |> pregunta")
}
tam_paso <- if (variante == "flujo-titulo") 15 else 10

# Lienzo y franja del título --------------------------------------------------
lienzo <- theme_void() +
  theme(
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(0, 0, 0, 0)
  )
unidad <- coord_cartesian(xlim = c(0, 1), ylim = c(0, 1), expand = FALSE)

franja <- if (variante == "flujo-titulo") {
  ggplot() +
    annotate(
      "text",
      x = 0.07,
      y = 0.64,
      label = "Un libro sobre análisis de datos con R y Python",
      hjust = 0,
      family = "Segoe UI",
      size = 6.5,
      colour = "grey80"
    ) +
    annotate(
      "text",
      x = 0.07,
      y = 0.30,
      label = "RAFAEL MENDOZA",
      hjust = 0,
      family = "Consolas",
      size = 6,
      colour = "white"
    ) +
    unidad +
    theme_void() +
    theme(plot.background = element_rect(fill = "#111111", colour = NA))
} else {
  ggplot() +
    annotate(
      "text",
      x = 0.07,
      y = 0.72,
      label = "Datos, código
y criterio",
      hjust = 0,
      family = "Georgia",
      fontface = "bold",
      size = 21,
      colour = "white",
      lineheight = 0.9
    ) +
    annotate(
      "text",
      x = 0.07,
      y = 0.33,
      label = "Un libro sobre análisis de datos con R y Python",
      hjust = 0,
      family = "Segoe UI",
      size = 6.5,
      colour = "grey75"
    ) +
    annotate(
      "text",
      x = 0.07,
      y = 0.12,
      label = "RAFAEL MENDOZA",
      hjust = 0,
      family = "Consolas",
      size = 6,
      colour = "white"
    ) +
    unidad +
    theme_void() +
    theme(plot.background = element_rect(fill = "#111111", colour = NA))
}

paso <- function(texto) {
  annotate(
    "text",
    x = 0.06,
    y = 0.80,
    label = texto,
    hjust = 0,
    vjust = 1,
    family = "Consolas",
    fontface = "bold",
    size = tam_paso
  )
}

# datos: dos pedidos tal como llegan en el CSV de abril -----------------------
crudo <- c(
  '"PD-02401","01/04/2026","S03","domicilio",8.4,174,9,82400,5,FALSE',
  '"PD-02402","01/04/2026","S04","domicilio",5.7,1068,5,284600,,FALSE'
)
p_datos <- ggplot() +
  paso(etiquetas[1]) +
  annotate(
    "text",
    x = 0.06,
    y = c(0.32, 0.14),
    label = crudo,
    hjust = 0,
    family = "Consolas",
    size = 3.4,
    colour = "grey60"
  ) +
  unidad +
  lienzo

# código: el flujo del capítulo 13 y lo que devuelve --------------------------
# Las filas de salida siguen el formato de los resultados del libro (#>):
# fecha ISO, minutos convertidos a horas (174 / 60 = 2,9; 1068 / 60 = 17,8) y NA.
limpio <- c(
  "#> PD-02401  2026-04-01  S03  domicilio  8,4 km   2,9 h   5",
  "#> PD-02402  2026-04-01  S04  domicilio  5,7 km  17,8 h  NA"
)
p_codigo <- ggplot() +
  paso(etiquetas[2]) +
  annotate(
    "text",
    x = 0.06,
    y = c(0.48, 0.36),
    hjust = 0,
    family = "Consolas",
    size = 3.6,
    colour = "grey35",
    label = c(
      "leer_crudo(rutas) |> armonizar() |> validar()",
      "leer_crudo(rutas).pipe(armonizar).pipe(validar)"
    )
  ) +
  annotate(
    "text",
    x = 0.06,
    y = c(0.18, 0.07),
    label = limpio,
    hjust = 0,
    family = "Consolas",
    size = 3.6,
    colour = "grey10"
  ) +
  unidad +
  lienzo

# criterio: el gráfico y la pregunta que despierta ---------------------------
entregas <- arrow::read_parquet(file.path(
  "datos",
  "cap11",
  "entregas_2026_t1.parquet"
))
entregas <- subset(entregas, !is.na(tiempo_entrega_h))
elegido <- entregas[which.max(entregas$tiempo_entrega_h), ]
pregunta <- sprintf(
  "# %s horas. ¿Qué pasó en %s?",
  format(elegido$tiempo_entrega_h, decimal.mark = ","),
  elegido$sucursal
)

x_elegido <- match(elegido$sucursal, sort(unique(entregas$sucursal)))
p_titulo_criterio <- ggplot() + paso(etiquetas[3]) + unidad + lienzo
p_violin <- ggplot(entregas, aes(sucursal, tiempo_entrega_h)) +
  geom_violin(fill = "grey93", colour = NA, scale = "width", width = 0.9) +
  geom_point(
    position = position_jitter(width = 0.28, height = 0, seed = 2026),
    colour = "grey55",
    size = 0.7,
    alpha = 0.7
  ) +
  geom_point(data = elegido, colour = "black", size = 2.8) +
  geom_point(
    data = elegido,
    shape = 1,
    colour = "black",
    size = 9,
    stroke = 0.9
  ) +
  annotate(
    "segment",
    x = x_elegido + 0.12,
    y = elegido$tiempo_entrega_h + 0.9,
    xend = x_elegido + 0.6,
    yend = elegido$tiempo_entrega_h + 4.6,
    linewidth = 0.4
  ) +
  annotate(
    "text",
    x = x_elegido + 0.68,
    y = elegido$tiempo_entrega_h + 4.6,
    label = pregunta,
    hjust = 0,
    family = "Consolas",
    size = 3.8
  ) +
  scale_y_continuous(expand = expansion(mult = c(0.04, 0.02))) +
  lienzo +
  theme(plot.margin = margin(4, 30, 20, 30))

# Composición -----------------------------------------------------------------
portada <- wrap_plots(
  p_datos,
  p_codigo,
  p_titulo_criterio,
  p_violin,
  franja,
  ncol = 1
) +
  plot_layout(
    heights = if (variante == "flujo-titulo") {
      c(1.25, 1.75, 0.65, 4.35, 1.1)
    } else {
      c(1.05, 1.6, 0.5, 3.85, 3)
    }
  ) &
  theme(plot.margin = margin(0, 0, 0, 0))

ragg::agg_png(destino, width = 1600, height = 2400, res = 200)
print(portada)
invisible(dev.off())
