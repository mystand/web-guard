#todo библиотека которая обновляет данные на странице
config =
  sites: [
    {name: "Инвестиционная карта Хабаровского края", url: "http://investmap.khabkrai.ru/"},
    {name: "Инвестиционная карта Ставропольского края", url: "http://map.stavinvest.ru/"},
    {name: "Инвестиционная карта Сахалинской области", url: "http://sakhalin.mystand.ru/"},
    {name: "Инвестиционная карта Липецкой области", url: "http://map.invest-lipetsk.com/"},
    {name: "Приложение для iOS инвестиционная карта Владимирской области", url: "https://itunes.apple.com/tc/app/investicionnaa-karta-vladimirskoj/id632488737?mt=8"},
    {name: "Инвестиционная карта Свердловской области", url: "http://investmap.midural.ru/"},
    {name: "Инвестиционная карта Владимирской области", url: "http://map.investvladimir.ru/"},
    {name: "Инвестиционная карта Республики Башкортостан", url: "http://map.bashkortostan.ru/"},
    {name: "Инвестиционная карта Омской области", url: "http://map.arvd.ru/"},
    {name: "Инвестиционная карта Смоленской области", url: "http://smolensk2.mystand.ru/"},
    {name: "Инвестиционная карта Камчатского края", url: "http://investmap.kamgov.ru/"},
    {name: "Инвестиционная карта Псковской области", url: "http://investmap.pskov.ru/"},
    {name: "Инвестиционный портал Свердловской области", url: "http://invest.midural.ru/"},
    {name: "Портал информационно-туристической службы Екатеринбурга", url: "http://its.ekburg.ru/"},
    {name: "Туристический портал Хабаровского края", url: "http://khabarovsk-tourism.mystand.ru/"},
    {name: "Инвестиционный портал Владимирской области", url: "http://investvladimir.ru/"},
    {name: "Инвестиционный портал Республики Башкортостан", url: "http://invest.bashkortostan.ru/"},
    {name: "Инвестиционный портал Липецкой области", url: "http://invest-lipetsk.com/"},
    {name: "Инвестиционный портал Кемеровской области", url: "http://kemerovo-invest-portal2.mystand.ru/"},
    {name: "Приложение для iOS инвестиционная карта Магаданской области", url: "https://itunes.apple.com/tc/app/magadan-invest/id765500283?mt=8"},
    {name: "Приложение для iOS инвестиционная карта Сахалинской области", url: "https://itunes.apple.com/tc/app/sakhalin-invest/id808748321?mt=8"},
    {name: "Навигация по Expoarms 2012", url: "http://expoarms.mystand.ru/"},
    {name: "Виртуальная выставка поставщиков атомной отрасли АТОМЕКС-2012", url: "http://atomeks-client.mystand.ru/"},
    {name: "Инвестиционная карта Магаданской области", url: "http://magadan.mystand.ru/"},
    {name: "Туристический путеводитель по Свердловской области", url: "https://itunes.apple.com/tc/app/go-to-ural/id765387129?mt=8"},
    {name: "Навигация по международному форуму Большая Химия", url: "http://great-chemistry.mystand.ru"},
    {name: "Приложение для iOS инвестиционная карта Камчатского края", url: "https://itunes.apple.com/tc/app/kamchatka-invest/id849648881?mt=8"},
    {name: "Приложение для iOS инвестиционная карта Республики Башкортостан", url: "https://itunes.apple.com/tc/app/investicionnaa-karta-respubliki/id645484053?mt=8"},
    {name: "Приложение для Android инвестиционная карта Магаданской области", url: "https://play.google.com/store/apps/details?id=com.telerik.magadanclient"},
    {name: "Приложение для Android инвестиционная карта Владимирской области", url: "https://play.google.com/store/apps/details?id=com.telerik.vladimirClient"},
    {name: "Туристический портал Свердловской области", url: "http://gotoural.com/"},
    {name: "Инвестиционный портал Ставропольского края", url: "http://portal.stavinvest.ru/"},
    {name: "Реестр мер поддержки предпринимательства Свердловской области", url: "http://reestr2.investural.com/"},
    {name: "Система доступная среда РСО-Алании", url: "http://dostupno15.ru/"}
  ]


class Guard
  constructor: (el) ->
    @el = el
    count = 0
    for site in config.sites
      count += 1
      site.index = count
      name = $("<div class='name'>").html(obj.name)
      code = $("<div class='code'>")
      link = $("<a href=\"obj.url\">").html("Ссылка")
      el = $("<li data-index=\"#{count}\">").append(name).append(code).append(link)
      el.appendTo @el
      $.ajax
        data: site
        url: "check"
        type: "GET"
        success: @renderResult

  renderResult: (obj) =>
    el = $ "li[data-url=#{obj.index}]", @el
    status = $ ".status", el
    status.addClass("status-#{obj.statusCode}").html obj.statusCode

$ ->
  new Guard $(".container")
