class String
  def to_usym
    gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
  end
end