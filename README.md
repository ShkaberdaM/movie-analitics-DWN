# movie analytics DWH
## Стек технологий
Python, Pandas, Sqlalchemy, SQL (PostgreSQL), Star Schema (Kimball Methodology), 3NF Normalization
## Архитектура Хранилища
Данные проходят обработку через два ключевых слоя:
1. Staging Layer (`stg_movies`): Сырой слой для первично загруженных данных из CSV с помощью Python-скрипта
2. Gold Layer (Star Schema): Очищенная аналитическая схема:
`fact_movies` — таблица фактов метрики (выручка, рейтинги, хронометраж)
`dim_directors` — измерение режиссеров связь 1:N
`dim_genres` — измерение жанров
`map_movie_genres` — мостовая таблица для связи N:M
## Структура проекта
```text
netflix_data/
│
├── data/                      
├── sql/                       
│   ├── Script_create.sql       
│   ├── Script_populate_gold.sql 
│   └── Script_views.sql         
│
├── docker-compose.yml         
├── learn_data.py             
├── .gitignore                 
└── README.md                
