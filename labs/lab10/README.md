
# R: Shiny

## Część I: Interaktywna Eksploracja Aut
W tej części będziemy pracować na zbiorze danych mpg (z pakietu ggplot2), który zawiera informacje o zużyciu paliwa przez różne modele samochodów.

### Zadanie 1
Otwórz RStudio i utwórz nową aplikację Shiny. 
*R Studio > File > New File > Shiny Web App*, nazwij ją np. "Eksplorator_Aut" i wybierz opcję *Single File (app.R)*.

### Zadanie 2
Wyczyść domyślny kod wewnątrz funkcji `ui` oraz `server`. Na samym początku pliku załaduj niezbędne biblioteki: `shiny`, `ggplot2` oraz `dplyr`.

### Zadanie 3
W panelu bocznym (`sidebarPanel`) umieść `sliderInput`, który pozwoli wybrać liczbę cylindrów z ramki danych `mpg` (zmienna `cyl`).

### Zadanie 4
W głównym panelu (`mainPanel`) zdefiniuj miejsce na wykres za pomocą `plotOutput`. Następnie w funkcji `server` użyj `renderPlot`, aby wyświetlić wykres punktowy (`geom_point`) zależności pojemności silnika (`displ`) od zużycia paliwa na autostradzie (`hwy`).

### Zadanie 5
Dodaj do panelu bocznego `selectInput`, aby umożliwić wybór producenta (zmienna `manufacturer`).
Zaktualizuj kod w `server` tak, aby wykres filtrował dane na podstawie wybranej marki. Dodatkowo zmień kod w `renderPlot` tak, aby tytuł wykresu był dynamiczny i zawierał nazwę aktualnie wybranego producenta, np. "Modele marki X".

### Zadanie 6
Dodaj filtrację danych na podstawie suwaka z Zadania 3. Na tym etapie niech wykres pokazuje auta o liczbie cylindrów mniejszej lub równej wybranej wartości.

### Zadanie 7
Dodaj do panelu bocznego radioButtons. Użytkownik powinien móc wybrać, czy punkty na wykresie mają być pokolorowane według klasy (`class`), czy rodzaju napędu (`drv`).
  
*Podpowiedź: Wykorzystaj .data[[input$id]] wewnątrz aes().*

### Zadanie 8
Pod wykresem dodaj `textOutput`. W sekcji `server` oblicz średnie zużycie paliwa (`hwy`) dla wybranego producenta i wyświetl komunikat:

"Średnie zużycie paliwa na autostradzie dla modeli marki [Producent] wynosi: [Wynik] mpg."

### Zadanie 9
Zmodyfikuj `sliderInput` tak, aby pozwalał na wybór zakresu (przedziału od-do). Zaktualizuj logikę filtrowania w `server`, aby uwzględniała obie granice zakresu.