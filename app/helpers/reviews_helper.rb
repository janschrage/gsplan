module ReviewsHelper

  ResultType = Struct.new(:id,:name)
  ReviewType = Struct.new(:id,:name)

  def review_result_text(result)
    if result == nil
      resulttext = "not set"
    else
      resulttext = review_result_list[result][1]
    end
    return resulttext
  end

  def review_type_text(rtype)
    if rtype == nil
      typetext = "not set"
    else
      typetext = review_type_list[rtype][1]
    end
    return typetext
  end

  def review_result_list
    resultlist = []
    resultlist << ResultType.new(Review::ResultFail, "fail")
    resultlist << ResultType.new(Review::ResultOK, "OK")
    resultlist << ResultType.new(Review::ResultOKwithComments, "OK with comments")
    return resultlist
  end

  def review_type_list
    typelist = []
    typelist << ReviewType.new(Review::ReviewSpec, "Spec")
    typelist << ReviewType.new(Review::ReviewDesign, "Design")
    typelist << ReviewType.new(Review::ReviewCode, "Code")
    #typelist << ReviewType.new(ReviewAT, "AT")
    return typelist
  end

end
