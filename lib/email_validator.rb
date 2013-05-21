# lib/email_validator.rb
class EmailValidator < ActiveModel::EachValidator

  EmailAddress = begin
  /
    ^[A-Za-z0-9+_.\-']+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,4}$
  /ix
    #atext = /[A-Za-z0-9!#\$%&'\*\+\-\/=\?\^_`\{\|\}\~]/
    #dot_atom = /(?:#{atext})+(?:\.(?:#{atext})+)+/
    #text = /[\x01-\x09\x0B\x0C\x0E-\x7F]/
    #qtext = /[\x01-\x08\x0B\x0C\x0E-\x1F\x21\x23-\x5B\x5D-\x7E]/
    ##quoted_pair = /\\#{text}/
    #qcontent = /(?:#{qtext}|#{quoted_pair})/
    #quoted_string = /"(?:\s*#{qcontent})*\s*"/
    #dtext = /[\x01-\x08\x0B\x0C\x0E-\x1F\x21-\x5A\x5E-\x7E]/
    ##dcontent = /(?:#{dtext}|#{quoted_pair})/
    #domain_literal = /\[(?:\s*#{dcontent})*\s*\]/
    #domain = /(?:#{dot_atom})/#|#{domain_literal})/
    #local_part = /(?:#{dot_atom}|#{quoted_string})/
    #pattern = /^(#{local_part})@(#{domain})$/
  end
  
  def validate_each(record, attribute, value)
    unless value =~ EmailAddress
      record.errors[attribute] << (options[:message] || "is not valid") 
    end
  end
  
end