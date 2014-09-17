window.googlePlusParser =
  getAllReviews: ->
    container = jq(":contains('All reviews')").last().parent()
    jq(container.children()[1]).find("[role='article']") if container

  verbalizeRate: (rate) ->
    if rate <= 2
      "negative"
    else if rate is 3
      "neutral"
    else
      "positive"

  parseReviews: ->
    allReviews = window.googlePlusParser.getAllReviews()
    reviews = []
    for el in allReviews
      el = jq el
      review = {}
      link = el.children().find("a[oid]")[1]
      if link
        review.username = link.innerHTML.split(">").reverse()[0]
        review.imageLink = "http:" + el.find(".we.qAa.M5").attr("src")
        review.userLink = "https://plus.google.com/" + jq(link).attr("href").split("./")[1]
      else
        review.username = "A Google User"

      selectedStartSelector = ".b-db-ac.b-db-ac-th"
      review.rate = window.googlePlusParser.verbalizeRate(el.find(selectedStartSelector).length)
      review.content = el.find(".GKa.oAa").html?() || ""

      responseSelector = "span.TTb:contains('Response from the owner')"
      review.hasResponse = el.find(responseSelector).length > 0
      if review.hasResponse
        review.response = el.find(responseSelector).parent().next().html()
      reviews.push review
    reviews
