# загрузка пакетов
library('data.table')          # работаем с объектами "таблица данных"
#library('moments')   # функции skewness() и kurtosis()
# Пакет "ggplot2" ==============================================================

# загрузка пакетов
library('ggplot2')             # графическая система 'ggplot2'
library('plyr')

# загружаем файл с данными по импорту масла в РФ (из прошлой практики)
fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/COMTRADE/040510-Imp-RF-comtrade.csv'
if (!file.exists('./homework/lab2/data')) {
  

dir.create('./homework')
dir.create('./homework/lab2')
dir.create('./homework/lab2/data')
}
# создаём файл с логом загрузок, если он ещё не существует:
if (!file.exists('./homework/lab2/data/download.log')) {
  file.create('./homework/lab2/data/download.log')
}
# загружаем файл, если он ещё не существует,
#  и делаем запись о загрузке в лог:
if (!file.exists('./homework/lab2/data/040510-Imp-RF-comtrade.csv')) {
  download.file(fileURL, './homework/lab2/data/040510-Imp-RF-comtrade.csv')
  # сделать запись в лог
  write(paste('Файл "040510-Imp-RF-comtrade.csv" загружен', Sys.time()), 
        file = './homework/lab2/data/download.log', append = T)
}
# читаем данные из загруженного .csv во фрейм, если он ещё не существует
if (!exists('DT')){
  DT <- data.table(read.csv('./homework/lab2/data/040510-Imp-RF-comtrade.csv', as.is = T))
}
# предварительный просмотр
dim(DT)     # размерность таблицы
str(DT)     # структура (характеристики столбцов)
DT          # удобный просмотр объекта data.table
#qplot(Year, Trade.Value.USD, data = DT)
#начинаем строить ggplot с объявления исходных данных

gp <- ggplot(data = DT,
             #aes(x = Year, y = Trade.Value.USD))
aes(Trade.Value.USD ))

#Добавляем плотность распределения

gp <- gp + geom_density()

#gp <- gp + facet_grid( Year ~ .) Добавляем фасетки по годам.

gp <- gp + facet_wrap( ~ Year )

#Задаем название графика и осей

gp <- gp + labs(title = "График плотностей распределения стоимости поставки,
разделённый на панели (фасетки) по годам.", 
                x = "Стоимость поставок в $", y = "Года")  
#Строим вертикальные прямые-медианы
gp <- gp + geom_vline(data=DT, aes(xintercept=mean(Trade.Value.USD), color="red"))
gp
