module UserHelper
  def  gravatar_for user, size: 80
  	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  	gravatar_url = t "helper.user.gravatar_url"
  	image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
