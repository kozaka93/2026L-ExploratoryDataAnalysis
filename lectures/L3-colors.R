library(ggplot2)
library(RColorBrewer)

RColorBrewer::brewer.pal(n = 5, name = "Set1")
c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00")
RColorBrewer::brewer.pal(n = 5, name = "Blues")
c("#EFF3FF", "#BDD7E7", "#6BAED6", "#3182BD", "#08519C")


ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 3, alpha = 0.7) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Skala jakościowa: Typy samochodów") +
  theme_minimal()

ggplot(mtcars, aes(x = hp, y = mpg, color = disp)) +
  geom_point(size = 4) +
  scale_color_viridis_c(option = "plasma") +
  labs(title = "Skala uporządkowana: Pojemność silnika",
       color = "Pojemność") +
  theme_light()


df_div <- data.frame(
  osoba = factor(1:10),
  wynik = c(-5, -3, -1, 0, 0.5, 1, 2, 4, 5, 6)
)

ggplot(df_div, aes(x = osoba, y = wynik, fill = wynik)) +
  geom_col() +
  scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0) +
  labs(title = "Skala rozbieżna: Odchylenie od zera",
       fill = "Wartość") +
  theme_minimal()


library(reshape2)

cor_matrix <- melt(cor(mtcars))

ggplot(cor_matrix, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "red", mid = "white", high = "blue", 
                       midpoint = 0, limit = c(-1, 1)) +
  theme_minimal() +
  labs(title = "Macierz korelacji: Poprawne użycie skali rozbieżnej",
       fill = "Współczynnik\nkorelacji")

