window.googlePlusParser =
  getAllReviews: ->
    container = jq(":contains('All reviews')").last().parent()
    jq(container.children()[1]).find("[role='article']") if container

  getReviewsWithResponse: ->
    allReviews = window.googlePlusParser.getAllReviews()
    reviews = []
    review = undefined
    response = undefined
    for el in allReviews
      el = jq el
      #      response = jq(el).find(".Cta .t7a")
      #        if response
      review = {}
      review["username"] = el.children().find("a")[1].innerHTML.split(">").reverse()[0]
      review["image_link"] = el.find(".we.qAa.M5").attr("src")
      review["review_rate"] = window.googlePlusParser.verbalizeRate(el.find(".b-db-ac-th").length)
      review["review_text"] = el.find(".GKa.oAa").html()
      #TODO finish here
      #      review["response_text"] = response.html()
      reviews.push review
    reviews

  parseReviews: () ->
    allReviews = window.googlePlusParser.getAllReviews()
    totalReviews = allReviews.length
    reviewsWithResponse = window.googlePlusParser.getReviewsWithResponse()
    console.log "#{reviewsWithResponse} out of #{totalReviews} reviews have a response"
    [
      "negative"
      "positive"
      "neutral"
    ].forEach (sentiment) ->
      totalBySentiment = window.googlePlusParser.countReviewsBySentiment["withResponse"]
      responded = window.googlePlusParser.countReviewsBySentiment["all"]
      console.log "#{totalBySentiment} out of #{responded} have a  #{sentiment} response"

    ParserResults = []
    ParserResults.push data for data in reviewsWithResponse

    console.log "------ FINISH ------"
    console.log JSON.stringify(ParserResults)
    reviewsWithResponse

  verbalizeRate: (rate) ->
    if rate <= 2
      "negative"
    else if rate is 3
      "neutral"
    else
      "positive"

  countReviewsBySentiment: (sentiment) ->
    reviews = getAllReviews()
    result = {}
    result["all"] = reviews.filter((el) ->
      verbalizeRate(jq(el).find(".b-db-ac-th").length) is sentiment
    )
    result["withResponse"] = result["all"].filter((el) ->
      jq(el).find ".Cta .t7a"
    )
    result