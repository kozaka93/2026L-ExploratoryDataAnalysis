# Tekst -------------------------------------------------------------------

# Proces eksploracji tekstu
# Krok 1: Zgromadzenie danych: strony internetowe, e-maile, media społecznościowe, blogi i inne.
# Krok 2: Wstępne przetwarzanie tekstu: czyszczenie tekstu, tokenizacja, filtrowanie, stemming, 
# lematyzacja, przetwarzanie językowe, rozpoznawanie części mowy i ujednoznacznienie znaczenia słów.
# Krok 3: Ekstrakcja informacji, wyszukiwanie informacji, kategoryzacja, grupowanie, wizualizacja i podsumowanie.

# https://rpubs.com/vipero7/introduction-to-text-mining-with-r
# https://www.rdocumentation.org/packages/tidytext/versions/0.3.4 


# tidytext ----------------------------------------------------------------

# Instalacja pakietów -----------------------------------------------------
install.packages("tidytext")
install.packages("janeaustenr")


library(tidytext)
library(janeaustenr)
library(dplyr)

original_books <- austen_books() %>% 
  group_by(book) %>% 
  mutate(line = row_number()) %>% 
  ungroup()

# tokenizacja = podział każdej linii na słowa
?unnest_tokens

tidy_books <- original_books %>%
  unnest_tokens(output = word, input = text)

# czyszczenie tekstu = usunięcie słów stop (stopwords)
?get_stopwords

tidy_books <- tidy_books %>%
  anti_join(get_stopwords())

word_count <- tidy_books %>%
  count(word, sort = TRUE) 

# wordcloud2 
install.packages("wordcloud2")
library(wordcloud2) 

wordcloud2(data = word_count, size=1.6)

# quanteda - bardziej skomplikowany pakiet (tokens, corpus)
# https://quanteda.io/index.html
install.packages("quanteda")
install.packages("quanteda.textplots")

library("quanteda")
library("quanteda.textplots")

textplot_wordcloud(dfm(tokens(tidy_books$word)))

# analiza sentymentu
?get_sentiments


janeaustensentiment <- tidy_books %>%
  inner_join(get_sentiments("bing")) %>% 
  count(book, index = line %/% 80, sentiment) %>% 
  tidyr::pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)


library(ggplot2)

ggplot(janeaustensentiment, aes(index, sentiment)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(~book, ncol = 2, scales = "free_x")


# Zadanie -----------------------------------------------------------------
# Ze strony https://www.gutenberg.org/ pobierz dowolną książke w formacie .txt, 
# a następnie przygotuj wordcloud słów w niej występujących (wykorzystaj tokenizację na słowa, 
# pomiń słowa stopu).

# Możesz również wykonać analizę senstymenu

# Project Gutenberg (Projekt Gutenberg) to najstarsza cyfrowa biblioteka,
# której celem jest tworzenie i udostępnianie elektronicznych wersji książek 
# (e-booków) i innych materiałów w domenie publicznej.



# przykład dla Romeo i Julia

library(tidyverse)
library(tidytext)
library(tibble)

# wczytanie pliku pg1513.txt
raw_text_combined <- readLines("pg1513.txt")


# 1. Przygotowanie danych wejściowych
# Tworzymy wektor linii na podstawie wczytanej zawartości
ksiazka_linie <- unlist(strsplit(raw_text_combined, "\n"))
tekst_sztuki <- ksiazka_linie

play_lines <- tibble(line = tekst_sztuki) %>%
  # Usuwamy puste wiersze i wiersze z samymi spacjami/tabulatorami
  filter(str_detect(line, "^\\s*$", negate = TRUE)) %>%
  # Dodajemy ID dla każdego wiersza, aby zachować porządek
  rowid_to_column("line_id") 

# usuwam wstęp, kilka linii o projekcie i wydaniu
play_lines <- play_lines[-c(1:18),]

# tokenizacja
tidy_books <- play_lines %>%
  unnest_tokens(output = word, input = line)

# usuwany stopwords
tidy_books <- tidy_books %>%
  anti_join(get_stopwords())

# zliczenie
word_count <- tidy_books %>%
  count(word, sort = TRUE) 

wordcloud2(data = word_count, size=1.6) # gdy parametr size jest za duży to słowa 
# o największej liczności mogą się nie pojawiać, wystarczy zmniejszyć parametr 
# lub zwiększyć obszar do rysowania wykresu

wordcloud2(data = word_count, size=0.6) 

romeo_julia <- tidy_books %>%
  inner_join(get_sentiments("bing")) %>% 
  count(index = line_id %/% 80, sentiment) %>% 
  tidyr::pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)


library(ggplot2)

ggplot(romeo_julia, aes(index, sentiment)) +
  geom_bar(stat = "identity", show.legend = FALSE)

