#=======================================================#
#              WSTĘP DO EKSPLORACJI DANYCH              # 
#                     LABORATORIUM 6                    #
#=======================================================#

# install.packages("sf")
# install.packages("scatterpie")
library(dplyr)
library(ggplot2)
library(forcats)
library(maps)
library(mapdata)
library(sf)
library(scatterpie)
library(patchwork)
library(SmarterPoland)

# 0. Zadanie rozgrzewkowe -------------------------------------------------

## Zadanie 0.1 ------------------------------------------------------------
# Pobierz dane dotyczące granic Polski ze strony
# https://www.geoportal.gov.pl/pl/dane/panstwowy-rejestr-granic-prg/





## Zadanie 0.2 ------------------------------------------------------------
# Mapa "szczęścia" w Europie
# Przygotuj mapę Europy na której zaznaczysz poziom szczęscia wśród osób poniżej 
# 30 roku życia (dane z 2021-2023). Ramka danych (happiness_data) zawiera informację
# o wybranych krajach Europy, dla reszty Państw przyjmij brak danych.
# Narysuj mapę, gdzie kolor wypełnienia zależy od wartości poziomu szczęścia, 
# dla braku danych przyjmij kolor szary.
# Zadbaj o czytelność wykresów, dodaj tytuł, podtytuł.

# Dokładny raport na temat "szczęścia" możesz znaleźć tutaj 
# https://files.worldhappiness.report/WHR24.pdf

happiness_data <- data.frame(
  kraj = c("Poland", "Germany", "France", "Spain", "Italy", "Norway", "Sweden", "Finland"),
  score = c(6.605, 6.578, 6.561, 6.453, 6.618, 6.995, 7.026, 7.300)
)




# 1. Mapa Polski ----------------------------------------------------------

# Pierwszym elementem przygotowania mapy Polski jest pobranie danych opisujących 
# granice państwa, granice województw, granice powiatów lub gmin. Pliki te 
# dostępne są pod adresem 
# https://www.geoportal.gov.pl/pl/dane/panstwowy-rejestr-granic-prg/. 
# Korzystając z www.geoportal.gov.pl można wybrać tylko potrzebny podzbiór danych, 
# natomiast ze strony Państwowy Rejestr Granic (PRG) na końcu strony są 
# gotowe do pobrania pliki spakowane w .zip.

# Pobrane dane należy rozpakować. Folder zawiera granice dla państwa/województw/powiatów .. 
# w różnych rozszerzeniach. Interesującym plikiem do rysowania granic w pakiecie 
# ggplot2 jest tak zwany plik shapefile (.shp).


## a) Mapa województw -----------------------------------------------------

wojewodztwa <- st_read("A01_Granice_wojewodztw.shp")

# Dane https://bdl.stat.gov.pl/bdl/start









## b) Mapa powiatów ------------------------------------------------------

powiaty <-  st_read("A02_Granice_powiatow.shp")






## Zadanie 1.1 ------------------------------------------------------------
# Przygotuj mapę czytelnictwa w Polsce w podziale na powiaty. Wypełnij powiaty 
# kolorem, który będzie oznaczał ile procent czytelników jest w danym powiecie.
# Wykorzystaj załączone dane z GUS - KULT_1699_CTAB_pow.csv.





## c) Kartodiagram --------------------------------------------------------

wojewodztwa <- st_read("A01_Granice_wojewodztw.shp", quiet = TRUE)
# Domyślny układ: ETRS89 (EPSG:4258) - European Terrestrial Reference System 1989
# do zwykłych map jest ok, ale jak chcemy dodać wykresy kołowe o zadanym promieniu
# to ze względu na układ będą one elipsami, układ ETRS89 jest w stopniach.

# Przejście na układ 1992 (EPSG:2180) - jest w metrach, pozwala na zachowanie 
# formatu koła.
wojewodztwa <- st_transform(wojewodztwa, 2180)








dane_szkoly <- dane_zdawalnosc %>%
  mutate(
    proporcja_LO = runif(n(), 0.6, 0.7), # np. licea to 60-70% zdawalności w danym woj.
    Liceum = Wartosc * proporcja_LO,
    Technikum = Wartosc * (1 - proporcja_LO)
  ) %>%
  select(-proporcja_LO) 












# 2. patchwork ------------------------------------------------------------

countries

p1 <- ggplot(countries, aes(x = fct_infreq(continent))) +
  geom_bar(fill = "lightblue") +
  labs(title = "Liczba krajów per kontynent", x = "Kontynent", y = "Liczba państw") +
  theme_light() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))

p2 <- ggplot(countries, aes(x = birth.rate, y = continent)) +
  geom_boxplot() +
  labs(title = "Rozkład wskaźnika urodzeń według kontynentu",
       x = "Współczynnik urodzeń",
       y = "Kontynent") +
  theme_light() 


p2 + p1

p1 / p2


(p1 | p2 | p1) / p2


## Zadanie 2.1 -------------------------------------------------------------
# Stwórz wykres gęstości brzegowych składający się z:
# a) wykresu punktowego (birth.rate ~ death.rate)
# b) rozkład zmiennej death.rate
# c) rozkład zmiennej birth.rate




