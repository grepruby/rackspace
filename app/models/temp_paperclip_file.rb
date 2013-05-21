class TempPaperclipFile < ActiveRecord::Base
  has_attached_file :photo,
                    :default_style => :small,
                    :styles => { :small => '78x78#', :big => '600x600#' },
                    :url => "/system/tempfile/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/tempfile/:id/:style/:basename.:extension"
end