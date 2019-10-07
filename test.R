df.1 = mapDKexp()
df.2 = mapDKexp(values = "indbrud", id = "kommune", data = test.data)
library("ggvis")

all_values <- function(x) {
  if(is.null(x)) return(NULL)
  paste0(names(x), ": ", format(x), collapse = "<br />")
}


df.2 %>%
  ggvis(~long, ~lat, fill = ~values) %>%
  group_by(group, id) %>%
  layer_paths(strokeOpacity:=0.5, stroke:="#7f7f7f") %>%
  hide_legend("fill") %>%
  hide_axis("x") %>% hide_axis("y") %>%
  add_tooltip(all_values, "click")
