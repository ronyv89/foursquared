# Ruby's builtin Symbol class
class Symbol
  # Convert camel case symbol to snake case symbol
  def to_usym
    to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
  end
end