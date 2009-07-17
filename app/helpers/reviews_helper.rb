module ReviewsHelper

  ResultType = Struct.new(:id,:name)
  ReviewType = Struct.new(:id,:name)

  ReviewResultImg = ["/images/icons/edit_remove ----.png",
                     "/images/icons/button_ok.png",
                     "/images/icons/button_cancel.png",
                     "/images/icons/file_broken.png"]

  def review_result_text(result)
    if result == nil
      resulttext = "not set"
    else
      resulttext = review_result_list[result][1]
    end
    return resulttext
  end

  def review_result_img_for_prj(prj,rtype)
    reviews=Review.find(:all, :conditions => ["project_id = ? and rtype = ?", prj, rtype])
   
    return ReviewResultImg[0] if reviews.nil?
 
    rOK = false
    rPart = false

    reviews.each do |review|
      rOK   = true if (review.result == Review::ResultOK or review.result == Review::ResultOKwithComments)
      rPart = true if (review.result == Review::ResultPartial)
    end  
    return ReviewResultImg[1] if rOK
    return ReviewResultImg[3] if rPart
    return ReviewResultImg[2] #default
  end

  def review_result_txt_for_prj(prj,rtype)
    reviews=Review.find(:all, :conditions => ["project_id = ? and rtype = ?", prj, rtype])
   
    return "no review" if reviews.nil?
 
    rOK = false
    rPart = false

    reviews.each do |review|
      rOK   = true if (review.result == Review::ResultOK or review.result == Review::ResultOKwithComments)
      rPart = true if (review.result == Review::ResultPartial)
    end  
    return "OK" if rOK
    return "Partially reviewed" if rPart
    return "Not OK" #default
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
    resultlist << ResultType.new(Review::ResultPartial, "Partial review")
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
