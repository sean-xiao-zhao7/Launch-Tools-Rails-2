# Source/Documentation: http://github.com/rails/token_generator
# Modified to work with rails 2.3.8
module TokenGenerator
  def generate_token(size = 24, &validity)
    constant = "#{self.class.name}#{id}"

    begin
      # With help from http://stackoverflow.com/questions/88311/how-best-to-generate-a-random-string-in-ruby
      chars =  [('a'..'z'),('A'..'Z'),('0'..'9'),'-'].map{|i| i.to_a}.flatten
      token = (0..size).map{ chars[rand(chars.length)] }.join

      # Old Method: Created problems because some characters got lost when moving variables
      # token = ActiveSupport::SecureRandom.base64(size)
      # token.gsub!(%r{[/,\\]},'-')
    end while !validity.call(token) if block_given?

    token
  end

  def set_token
    self.token = generate_token { |token| self.class.find_by_token(token).nil? }
  end
end
