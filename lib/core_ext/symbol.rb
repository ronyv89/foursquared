class Symbol
  def to_usym
    to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
  end
end