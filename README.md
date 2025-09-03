# schedule_app

Проект для записи и отслеживания статистики для мастеров парикмахерской.

## Средства разработки

В проекте используются ключевые библиотеки и фреймворки:

- [cupertino_icons](https://pub.dev/packages/cupertino_icons) — иконки в стиле iOS.
- [google_fonts](https://pub.dev/packages/google_fonts) — подключение шрифтов Google.
- [intl](https://pub.dev/packages/intl) — интернационализация и работа с датами/числами.

- [firebase_core](https://pub.dev/packages/firebase_core),  
  [firebase_auth](https://pub.dev/packages/firebase_auth),  
  [firebase_storage](https://pub.dev/packages/firebase_storage),  
  [cloud_firestore](https://pub.dev/packages/cloud_firestore) — интеграция с Firebase (core,
  аутентификация, хранилище, база данных).

- [image_picker](https://pub.dev/packages/image_picker) — выбор изображений из галереи и камеры.
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) — управление состоянием (BLoC/Cubit).
- [fl_chart](https://pub.dev/packages/fl_chart) — визуализация данных (графики, диаграммы).
- [go_router](https://pub.dev/packages/go_router) — современный маршрутизатор для Flutter.
- [vibration](https://pub.dev/packages/vibration) — управление вибрацией устройства.
- [carousel_slider](https://pub.dev/packages/carousel_slider) — создание слайдеров и каруселей.
- [flutter_expandable_fab](https://pub.dev/packages/flutter_expandable_fab) — расширяемая
  FloatingActionButton.
- [uuid](https://pub.dev/packages/uuid) — генерация уникальных идентификаторов.
- [shared_preferences](https://pub.dev/packages/shared_preferences) — хранение пользовательских
  настроек локально.
- [mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter) — маски для ввода
  текста.

## Авторизация и профиль специалиста

![1.gif](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/schedule_app/1.gif)

## Главный экран и статистика по записям

Главный экран отображает список сегодняшних записей и интерактивную статистику.

Для графиков используется fl_chart, с поддержкой анимаций и переключения между метриками (количество
записей или выручка).

![2.gif](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/schedule_app/2.gif)

## Расписание и управление услугами

Экран расписания отображает таблицу записей с мастерами и временем. Доступен переход с главного
экрана.
Создание, редактирование и удаление записей осуществляется через всплывающие окна.
Пользователь может добавлять, изменять и удалять только свои записи.
Администратор имеет возможность добавлять, изменять и удалять записи всех специалистов.

![3.gif](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/schedule_app/3.gif)

## Экраны и управление услугами и категориями услуг

Управление услугами и категориями осуществляется через диалоговые окна, вызываемые кнопкой или
долгим нажатием.
Удаление доступно через свайп с подтверждением.
Категории редактируются аналогично, с дополнительным выбором связанных услуг.
Изменения доступны только администраторам.

![4.gif](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/schedule_app/4.gif)

## Экран и управление портфолио

Экран портфолио — это карусель фотографий портфолио активного пользователя.
Добавление фото осуществляется через расширяемую кнопку FloatingActionButton с выбором: камера или
галерея.
Удаление фото возможно через долгое нажатие с подтверждением через диалоговое окно. При активном
диалоговом окне карусель временно приостанавливается.

![5.gif](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/schedule_app/5.gif)

## Экран и управление профилем специалиста

Экран профиля отображает данные специалиста в виде формы.

| ![6.png](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/schedule_app/6.png) | ![7.png](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/schedule_app/7.png) |
|-------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|


