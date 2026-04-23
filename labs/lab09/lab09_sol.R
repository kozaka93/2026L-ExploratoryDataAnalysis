#=======================================================#
#              WSTĘP DO EKSPLORACJI DANYCH              # 
#                     LABORATORIUM 9                    #
#=======================================================#


# Grafy -------------------------------------------------------------------

# Instalacja pakietów -----------------------------------------------------
install.packages("igraph")
install.packages('tidygraph')
install.packages('ggraph')


library(igraph)
library(tidygraph)
library(ggraph)

# W jaki sposób można reprezentować grafy? --------------------------------

# Istnieje wiele sposobów na przechowywanie struktur grafowych. 
# Bardziej zaawansowane metody wykorzystują formaty takie 
# jak np. gml, i trzymają wszystkie infromacje w jednym pliku.

?read_graph
dolphins_graph <- read_graph("data/dolphins.gml", format = "gml")
dolphins_graph

# Zbiór danych: The file dolphins.gml contains an undirected social network of frequent
# associations between 62 dolphins in a community living off Doubtful Sound,
# New Zealand.

# Inne podejścia są natomiast bardziej prymitywne 
# i wykorzystują formaty takie jak csv, aby w dwóch osobnych
# plikać trzymać informacje o wierzchołkach oraz krawędziach. 
# W takich strukturach często zauważyć można dodatkowe informacje, 
# takie jak np. waga krawędzi, albo dodatkowe cechy wierzchołków.

LOTR_edges <- read.csv('data/LOTR-edges.csv')
LOTR_nodes <- read.csv('data/LOTR-nodes.csv', sep = '\t')
View(LOTR_edges)
View(LOTR_nodes)

# Zbiór danych: Lord of the Rings

# W niektórych przypadkach, sieci (networks - inna nazwa na grafy) 
# mogą być reprezentowane poprzez bardzo proste struktury, 
# opisujące jedynie zbiór krawędzi.

Erdos_edges <- read.csv('data/ca-Erdos992.csv', sep = ' ', header = FALSE)
head(Erdos_edges)

# Zbiór danych: Erdos collaboration network = Liczba Erdősa

# Wizualizacja grafów ----------------------------------------------------

# igraph https://igraph.org/ ---------------------------------------------

# igraph jest jednym z najpopularniejszych narzędzi służących 
# do analizy grafów. Poza samą wizualizacją sieci, 
# jest on przede szystkim zorientowany na ich analizę, oraz generowanie.

# Zbiór danych dolphins

?igraph.plotting
?layout


# Zadanie 1 ---------------------------------------------------------------
# Narysuj graf dla danych dolphins_graph. Spróbuj zmienić jego wygląd ustawiając
# inne wartości argumentów funkcji niż domyślne.

# default
plot.igraph(dolphins_graph)

# dopracowane (https://r.igraph.org/articles/igraph.html#layouts-and-plotting)
plot.igraph(dolphins_graph,
            vertex.size = 14,
            vertex.color = 'lightgreen',
            vertex.frame.color = 'darkgreen',
            vertex.frame.width = 2,
            vertex.shape = 'rectangle',
            vertex.size2 = 7,
            vertex.label.cex = 1,
            vertex.label.color = 'black',
            vertex.label.dist = 0,
            edge.color = 'darkgrey',
            edge.width = 2,
            edge.arrow.size = 2,
            edge.lty = 3,
            edge.curved = TRUE, 
            layout = layout_with_graphopt, # np. layout_randomly, layout_as_tree
            margin = 0,
            rescale = TRUE,
            asp = 0.5,
            frame = FALSE,
            main = 'Dolphins community network',
            sub = 'Representing the interaction between individuals from the same group')



# ggraph ------------------------------------------------------------------

# Alternatywą do wizualizacji grafów za pomocą biblioteki igraph jest 
# inspirowany ggplotem, pakiet ggraph. Jest on zorientowany jedynie 
# w kierunku wizualizacji i zasadniczo oferuje więcej możliwości niż sam igraph, 
# jednak jest też trochę bardziej skomplikowany.


# Zbiór danych dolphins

?as_tbl_graph

tg <- tidygraph::as_tbl_graph(dolphins_graph) %>% 
  tidygraph::activate(nodes)
tg

edge_list <- tg %>%
  activate(edges) %>%
  data.frame()

node_list <- tg %>%
  activate(nodes) %>%
  data.frame()


tg %>%
  ggraph(layout = "auto") +
  geom_node_point() +
  geom_edge_link() +
  geom_node_text(aes(label = label))


# stopień wierzchołka 

node_list$degree <- rep(0, nrow(node_list))
node_list$id <- node_list$id + 1

for (i in 1:nrow(node_list)) {
  node_list$degree[i] <- sum(edge_list$from == node_list$id[i]) + sum(edge_list$to == node_list$id[i])
}
head(edge_list)
head(node_list)


my_graph <- graph_from_data_frame(
  d = edge_list,      
  vertices = node_list, 
  directed = FALSE   
)


my_graph %>%
  ggraph(layout = "auto") +
  geom_node_point(aes(size = degree)) +
  geom_edge_link() +
  geom_node_text(aes(label = label), repel = TRUE, size = 3.5) +
  labs(title = "Wizualizacja Grafu z Wierzchołkami i Krawędziami", size = "Stopień") +
  theme_bw() +
  theme_graph(base_family = "sans")

? theme_graph 



my_graph %>%
  ggraph(layout = "auto") +
  geom_node_point(aes(size = degree),
                  color = 'blue',
                  alpha = 0.9) +
  geom_edge_link(colour   = "darkgrey",
                 lineend  = "round",
                 linejoin = 'round',
                 n = 100,
                 alpha = 0.5) +
  geom_node_text(aes(label = label, 
                     size = degree + 10),
                 repel         = TRUE, 
                 point.padding = unit(0.2, "lines"), 
                 colour        = "darkblue") +
  theme_graph(background = "white",
              foreground = 'lightgreen') +
  guides(edge_width = FALSE,
         edge_alpha = FALSE,
         size       = FALSE,
         scale = 'none') +
  labs(title = 'Dolphins community network')


# Analiza grafowa ---------------------------------------------------------

# Aby uzupełnić naszą wiedzę na temat grafów, jako że policzyliśmy 
# stopnie wierzchołków w grafie dokanmy także sprawdzenia
# czy sieć delfinów jest siecią rzeczywistą. 

ggplot(node_list, aes(degree)) +         
  geom_histogram(bins = 10) +         
  labs(title = "Histogram of nodes degree (bin = 10)", x = "Wieghted node degree", y = "Number of nodes") +         
  theme_minimal()

# Z powyższego grafu wynika, że rozkład stopni wierzchołków nie do końca posiada gruby ogon oraz ma dość mało wierzchołków.

cat('Clustering coefficient:', transitivity(my_graph),'\nDiameter of the graph:', 
    diameter(my_graph, directed = FALSE, weights = NULL))

# Ponadto zobaczyć możemy, że funkcja transitivity (innna nazwa na clsutering coefficient, zakres wartości [0,1]) 
# jest niewielka 0.31, natomiast średnica grafu (najdłuższa z najkrótszych ścieżek między wierchołkami) wynosi, aż 8.

# Niniejsza sieć wykazuje zatem pewne cechy sieci rzeczywistej (clustering coefficient), natomiast nie jest ich zbyt wiele.


# Zadanie 2 ---------------------------------------------------------------

# Analogicznie do zbioru dolphins, narysuj graf przedstawiający relacje między 
# członkami klubu Zacharego, tak aby wizualizacja była czytelniejsza.
# Dokonaj analizy czy sieć jest rzeczywista czy nie.

karate <- read_graph("data/karate.gml", format = "gml")

tg <- tidygraph::as_tbl_graph(karate) %>% 
  tidygraph::activate(nodes)
edge_list <- tg %>%
  activate(edges) %>%
  data.frame()

node_list <- tg %>%
  activate(nodes) %>%
  data.frame()

node_list$degree <- rep(0, nrow(node_list))
node_list$id <- node_list$id

for (i in 1:nrow(node_list)) {
  node_list$degree[i] <- sum(edge_list$from == node_list$id[i]) + sum(edge_list$to == node_list$id[i])
  node_list$label[i]  <- node_list$id[i]
}
ig <- igraph::graph_from_data_frame(d = edge_list, vertices = node_list, directed = FALSE)

ig %>%
  ggraph() +
  geom_node_point() +
  geom_edge_link() +
  geom_node_text(aes(label = label))

ggplot(node_list, aes(degree)) +         
  geom_histogram(bins = 10) +         
  labs(title = "Histogram of nodes degree (bin = 10)", x = "Wieghted node degree", y = "Number of nodes") +         
  theme_minimal()

cat('Clustering coefficient:', transitivity(my_graph),'\nDiameter of the graph:', 
    diameter(my_graph, directed = FALSE, weights = NULL))

