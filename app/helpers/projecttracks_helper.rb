module ProjecttracksHelper
  TrackStatusImages = [ "/images/icons/ok.png",
                        "/images/icons/error.png"]

  def track_status_image(status)
    return TrackStatusImages[0] if status 
    return TrackStatusImages[1]
  end
end
