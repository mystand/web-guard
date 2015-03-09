// Generated by CoffeeScript 1.7.1
(function() {
  window.googlePlusParser = {
    getAllReviews: function() {
      var container;
      container = jq(":contains('All reviews')").last().parent();
      if (container) {
        return jq(container.children()[1]).find("[role='article']");
      }
    },
    verbalizeRate: function(rate) {
      if (rate <= 2) {
        return "negative";
      } else if (rate === 3) {
        return "neutral";
      } else {
        return "positive";
      }
    },
    parseReviews: function() {
      var allReviews, el, link, responseSelector, review, reviews, selectedStarSelector, _base, _base1, _i, _len;
      allReviews = window.googlePlusParser.getAllReviews();
      reviews = [];
      for (_i = 0, _len = allReviews.length; _i < _len; _i++) {
        el = allReviews[_i];
        el = jq(el);
        review = {};
        link = el.children().find("a[oid]").last();
        if (link.length > 0) {
          review.imageLink = "http:" + el.find("img").attr("src");
          review.userLink = "https://plus.google.com/" + link.attr("href").split("./")[1];
          review.username = link.html().split(">").reverse()[0];
        } else {
          review.username = "A Google User";
        }
        selectedStarSelector = "[role='button'].b-db-ac-th";
        review.content = (typeof (_base = el.find(".GKa.oAa")).html === "function" ? _base.html() : void 0) || "";
        review.ratingValue = el.find(selectedStarSelector).length;
        review.rate = window.googlePlusParser.verbalizeRate(review.ratingValue);
        review.time = (typeof (_base1 = el.find(selectedStarSelector).last().parent().next().find("span")).html === "function" ? _base1.html() : void 0) || "";
        responseSelector = "span:contains('Response from the owner')";
        review.hasResponse = el.find(responseSelector).length > 0;
        if (review.hasResponse) {
          review.response = el.find(responseSelector).parent().next().html();
        }
        reviews.push(review);
      }
      return reviews;
    }
  };

}).call(this);
